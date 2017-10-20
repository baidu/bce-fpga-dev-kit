/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fcntl.h>
#include <unistd.h>
#include <getopt.h>
#include <dirent.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/errno.h>
#include <sys/mman.h>
#include <sys/file.h>

#include <assert.h>
#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include <iostream>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <iomanip>
#include <functional>

#include <pciaccess.h>
#include <glog/logging.h>
#include <json/json.h>

#include "config.h"
#include "string_printf.h"
#include "fd_guard.h"
#include "llapi.h"
#include "md5.h"

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

namespace llapi = baidu::fpga::llapi;

static Json::Value g_db;
static const std::string g_tmp_dir_path = "/tmp/bce_fpga_dev_kit";
static const std::string g_db_path = g_tmp_dir_path + "/db";
static const std::string EXPECTED_PARTIAL_SUFFIX = "partial.bin";
static const std::string EXPECTED_CLEAR_SUFFIX = "partial_clear.bin";
static std::map<std::string, uint32_t> g_static_dcp_md5sum_2_version = {
    { "e41a401bcf6637eb0cf79643660df28c", 0x00000103 },
    { "6e60f7d0e98a415c81b456adbd2da5b7", 0x00000104 },
    { "8527bc67dcf71020ca295e0d872df7b0", 0x00000105 },
};

static std::string md5sum_hex_2_std_string(const unsigned char hex[16])
{
    return base::string_printf("%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                               hex[0], hex[1], hex[2], hex[3], hex[4], hex[5], hex[6], hex[7],
                               hex[8], hex[9], hex[10], hex[11], hex[12], hex[13], hex[14], hex[15]);
}

static void md5sum_std_string_2_hex(const std::string& str, unsigned char hex[16])
{
    CHECK(str.size() == 32);
    for (int i = 0; i < 16; ++i) {
        hex[i] = (unsigned char)strtol(str.substr(2 * i, 2).c_str(), NULL, 16);
    }
}

static std::string md5sum(const std::string& path)
{
    unsigned char hex[16];

    FILE *fp = fopen(path.c_str(), "r");
    if (!fp) {
        goto err;
    }
    if (md5_stream(fp, &hex[0])) {
        goto err;
    }
    fclose(fp);

    return md5sum_hex_2_std_string(hex);

err:
    return std::string(32, 'f');
}

static const char *g_bce_fpga_usage[] = {
    "Synopsis",
    "   bce_fpga_mgmt_tool <general command> [<general command args>]",
    "   bce_fpga_mgmt_tool -h",
    "   bce_fpga_mgmt_tool --version",
    "General Command",
    "   LoadPartialLogic/LoadDefaultPartialLogic/DescribeSlot/ResetPartialLogic/ResetStaticLogic",
};

static const char *g_load_partial_logic_usage[] = {
    "Synopsis",
    "   bce_fpga_mgmt_tool LoadPartialLogic -S <Slot#> --partial-bin-path=<path_to_partial_bin>",
    "                                       [--partial-clear-bin-path=<path_to_partial_clear_bin>] [--force]",
    "   bce_fpga_mgmt_tool LoadPartialLogic -h",
    "   bce_fpga_mgmt_tool LoadPartialLogic --version",
    "Description",
    "   Load tcl/vivado generated partial bin to FPGA specified by <Slot#>",
    "Option",
    "   -S/--slot                               FPGA slot#",
    "   -P/--partial-bin-path                   Path to tcl/vivado generated partial bin",
    "   -C/--partial-clear-bin-path             Path to tcl/vivado generated partial clear bin",
    "   -f/--force                              Don't enforce filename validness check",
    "   -h/--help                               Print this usage",
    "   -V/--version                            Print version",
};

static const char *g_load_default_partial_logic_usage[] = {
    "Synopsis",
    "   bce_fpga_mgmt_tool LoadDefaultPartialLogic -S <Slot#>",
    "   bce_fpga_mgmt_tool LoadDefaultPartialLogic -h",
    "   bce_fpga_mgmt_tool LoadDefaultPartialLogic --version",
    "Description",
    "   Load default partial logic to FPGA specified by <Slot#>",
    "Option",
    "   -S/--slot                               FPGA slot#",
    "   -h/--help                               Print this usage",
    "   -V/--version                            Print version",
};

static const char *g_describe_slot_usage[] = {
    "Synopsis",
    "   bce_fpga_mgmt_tool DescribeSlot",
    "   bce_fpga_mgmt_tool DescribeSlot -S <Slot#>",
    "   bce_fpga_mgmt_tool DescribeSlot -h",
    "   bce_fpga_mgmt_tool DescribeSlot --version",
    "Description",
    "   The default action is to describe all FPGAs passthroughed to current VM instance. If <Slot#>",
    "   is specified, it will print extra information and performance metrics about this slot.",
    "Option",
    "   -S/--slot                               FPGA slot#",
    "   -h/--help                               Print this usage",
    "   -V/--version                            Print version",
};

static const char *g_reset_partial_logic_usage[] = {
    "Synopsis",
    "   bce_fpga_mgmt_tool ResetPartialLogic -S <Slot#>",
    "   bce_fpga_mgmt_tool ResetPartialLogic -h",
    "   bce_fpga_mgmt_tool ResetPartialLogic --version",
    "Description",
    "   Generate a RESET to **partial** logic of FPGA in <Slot#>",
    "Option",
    "   -S/--slot                               FPGA slot#",
    "   -h/--help                               Print this usage",
    "   -V/--version                            Print version",
};

static const char *g_reset_static_logic_usage[] = {
    "Synopsis",
    "   bce_fpga_mgmt_tool ResetStaticLogic -S <Slot#>",
    "   bce_fpga_mgmt_tool ResetStaticLogic -h",
    "   bce_fpga_mgmt_tool ResetStaticLogic --version",
    "Description",
    "   Generate a RESET to **static** logic of FPGA in <Slot#>",
    "Option",
    "   -S/--slot                               FPGA slot#",
    "   -h/--help                               Print this usage",
    "   -V/--version                            Print version",
};

static void print_usage(const char **usage, size_t nlines)
{
    for (size_t i = 0; i < nlines; ++i) {
        printf("%s\n", usage[i]);
    }
}

static void print_version()
{
    printf("bce_fpga_mgmt_tool : V%d.%d\n", BCE_FPGA_MGMT_TOOL_VERSION_MAJOR,
           BCE_FPGA_MGMT_TOOL_VERSION_MINOR);
}

static std::string normalize_path(const std::string& path)
{
    /* To handle relative path beginning with ~/$HOME */
    if (path.compare(0, 2, "~/") == 0) {
        std::string ret;
        ret = getenv("HOME");
        ret += path.substr(1);
        return ret;
    }

    return path;
}

static std::string get_fmt_time_string()
{
    time_t raw_time;
    struct tm *time_info = NULL;
    char fmt_time[128];
    time(&raw_time);
    time_info = localtime(&raw_time);
    strftime(fmt_time, sizeof(fmt_time), "%Y-%m-%d %H:%M:%S", time_info);
    return std::string(fmt_time);
}

static bool std_string_a_ends_with_b(const std::string& a, const std::string& b)
{
    if ((a.size() < b.size()) || (a.substr(a.size() - b.size(), b.size()) != b)) {
        return false;
    }
    return true;
}

static bool regular_file_readable(const std::string& path)
{
    if (access(path.c_str(), R_OK)) {
        return false;
    }

    struct stat s;
    if (stat(path.c_str(), &s)) {
        return false;
    }
    if (!S_ISREG(s.st_mode)) {
        /* Not a regular file */
        return false;
    }

    return true;
}

enum BCE_FPGA_CMD_WORD {
    LOAD_PARTIAL_LOGIC = 1,
    LOAD_DEFAULT_PARTIAL_LOGIC,
    DESCRIBE_SLOT,
    RESET_PARTIAL_LOGIC,
    RESET_STATIC_LOGIC,
};

struct bce_fpga_load_partial_logic_cmd {
    int slot;
    std::string partial_bin_path;
    std::string clear_bin_path;
    std::string last_clear_bin_path;
    bool force;
};

struct bce_fpga_describe_slot_cmd {
    int slot;
    bool show_mgmt_functions;
};

struct bce_fpga_reset_partial_logic_cmd {
    int slot;
};

struct bce_fpga_reset_static_logic_cmd {
    int slot;
};

static struct bce_fpga_cmd {
    enum BCE_FPGA_CMD_WORD cmd;
    bool finished;

    /* XXX: Cannot use `union` here, as some inner structs have non-trivial ctor/dtor. */
    struct {
        struct bce_fpga_load_partial_logic_cmd load_partial_logic;
        struct bce_fpga_describe_slot_cmd describe_slot;
        struct bce_fpga_reset_partial_logic_cmd reset_partial_logic;
        struct bce_fpga_reset_static_logic_cmd reset_static_logic;
    } payload;
} g_bce_fpga_cmd;

typedef int (*bce_fpga_parse_cmd_args_func_t)(int argc, char **argv);
typedef int (*bce_fpga_action_func_t)();

static int parse_describe_slot(int argc, char **argv)
{
    g_bce_fpga_cmd.payload.describe_slot.slot = -1;
    g_bce_fpga_cmd.payload.describe_slot.show_mgmt_functions = false;

    static struct option long_options[] = {
        { "slot", required_argument, 0, 'S' },
        { "show-mgmt-functions", no_argument, 0, 'M' },
        { "help", no_argument, 0, 'h' },
        { "version", no_argument, 0, 'V' },
        { 0, 0, 0, 0 },
    };

    int opt = 0;
    int long_index = 0;
    int ret = 0;
    optind = 2;
    while ((opt = getopt_long(argc, argv, "S:M?hV", long_options, &long_index)) != -1) {
        switch (opt) {
        case 'S':
            g_bce_fpga_cmd.payload.describe_slot.slot = atoi(optarg);
            if ((g_bce_fpga_cmd.payload.describe_slot.slot < 0)
                || (g_bce_fpga_cmd.payload.describe_slot.slot >= 8)) {
                LOG(WARNING) << "Slot should be >= 0 and < 8.";
                ret = -1;
                goto show_usage;
            }
            break;
        case 'M':
            g_bce_fpga_cmd.payload.describe_slot.show_mgmt_functions = true;
            break;
        case 'h':
            g_bce_fpga_cmd.finished = true;
            goto show_usage;
        case 'V':
            print_version();
            g_bce_fpga_cmd.finished = true;
            goto out;
        default:
            ret = -1;
            goto show_usage;
        }
    }

    goto out;

show_usage:
    print_usage(g_describe_slot_usage, ARRAY_SIZE(g_describe_slot_usage));
out:
    return ret;
}

static const struct slot_desc_column {
    const char *column_header;
    bool left_aligned;
    size_t column_width;
    std::function<std::string(int)> gen_str;
} g_slot_desc_columns[] = {
    {
        "Slot", true, 4, [](int s)
        {
            return base::string_printf("%d", s);
        }
    },
    {
        "DBDF", true, 12, [](int s)
        {
            return base::string_printf("%04x:%02x:%02x.%01x",
                                       llapi::g_bce_fpga_devices[s].pci_device.domain,
                                       llapi::g_bce_fpga_devices[s].pci_device.bus,
                                       llapi::g_bce_fpga_devices[s].pci_device.dev,
                                       llapi::g_bce_fpga_devices[s].pci_device.func);
        }
    },
    {
        "VendorID", true, 8, [](int s)
        {
            return base::string_printf("0x%04x", llapi::g_bce_fpga_devices[s].pci_device.vendor_id);
        }
    },
    {
        "DeviceID", true, 8, [](int s)
        {
            return base::string_printf("0x%04x", llapi::g_bce_fpga_devices[s].pci_device.device_id);
        }
    },
    {
        "StaticVersion", true, 13, [](int s)
        {
            return base::string_printf("0x%08x", g_db["slots"][s]["static_version"].asUInt());
        }
    },
    {
        "StaticStatus", true, 12, [](int s)
        {
            return base::string_printf("0x%08x", g_db["slots"][s]["status"].asUInt());
        }
    },
    {
        "PartialBinPath", true, 50, [](int s)
        {
            if (g_db["slots"][s]["status"].asUInt() & 0x2) {
                return std::string("base");
            } else {
                return g_db["slots"][s]["last_partial_bin_path"].asString();
            }
        }
    },
};

static void describe_one_slot(int slot)
{
    std::cout << "|";
    for (struct slot_desc_column c : g_slot_desc_columns) {
        std::string s = c.gen_str(slot);
        std::cout << " ";
        if (c.left_aligned) {
            std::cout << std::left;
        } else {
            std::cout << std::right;
        }
        std::cout << std::setw(c.column_width) << std::setfill(' ');
        std::cout << s.substr(0, c.column_width);
        std::cout << " |";
    }
    std::cout << "\n";
}

static int do_describe_slot()
{
    std::cout << "+";
    for (struct slot_desc_column c : g_slot_desc_columns) {
        std::cout << std::string(c.column_width + 2, '-') << "+";
    }
    std::cout << "\n";

    std::cout << "|";
    for (struct slot_desc_column c : g_slot_desc_columns) {
        std::cout << " " << std::left << std::setw(c.column_width)  << std::setfill(' ')
                  << c.column_header << " |";
    }
    std::cout << "\n";

    std::cout << "+";
    for (struct slot_desc_column c : g_slot_desc_columns) {
        std::cout << std::string(c.column_width + 2, '-') << "+";
    }
    std::cout << "\n";

    if (g_bce_fpga_cmd.payload.describe_slot.slot == -1) {
        /* show all slots */
        for (int i = 0; i < 8; ++i) {
            if (llapi::g_bce_fpga_devices[i].present) {
                describe_one_slot(i);
            }
        }
    } else {
        if (llapi::g_bce_fpga_devices[g_bce_fpga_cmd.payload.describe_slot.slot].present) {
            describe_one_slot(g_bce_fpga_cmd.payload.describe_slot.slot);
        }
    }

    std::cout << "+";
    for (struct slot_desc_column c : g_slot_desc_columns) {
        std::cout << std::string(c.column_width + 2, '-') << "+";
    }
    std::cout << "\n";

    return 0;
}

static int check_meta_file(int slot, const std::string& bin_path, const std::string& meta_path)
{
    if (!regular_file_readable(meta_path)) {
        LOG(WARNING) << "Partial meta path [" << meta_path
                     << "] is not a readable regular file.";
        return -1;
    }

    Json::Value root;
    std::ifstream ifs(meta_path);
    if (!ifs.is_open()) {
        LOG(WARNING) << "Error in ifstream";
        return -1;
    }
    ifs >> root;

    if (!root.isMember("md5sum")) {
        LOG(WARNING) << "Invalid meta file, no `md5sum` member.";
        return -1;
    }
    if (root["md5sum"].asString() != md5sum(bin_path)) {
        LOG(WARNING) << "Md5sum mismatch";
        return -1;
    }

    if (!root.isMember("my_top_static_routed_dcp_md5sum")) {
        LOG(WARNING) << "Invalid meta file, no `my_top_static_routed_dcp_md5sum` member.";
        return -1;
    }
    std::string static_dcp_md5sum = root["my_top_static_routed_dcp_md5sum"].asString();
    auto static_version_it = g_static_dcp_md5sum_2_version.find(static_dcp_md5sum);
    if (static_version_it == g_static_dcp_md5sum_2_version.end()) {
        LOG(WARNING) << "Unversioned my_top_static_routed.dcp";
        return -1;
    }
    uint32_t expected_static_version =
            g_db["slots"][slot]["static_version"].asUInt();
    if (static_version_it->second != expected_static_version) {
        LOG(WARNING) << "Given partial logic mismatches static version";
        return -1;
    }

    return 0;
}

static int check_load_partial_logic()
{
    struct bce_fpga_load_partial_logic_cmd& load_partial_logic =
                g_bce_fpga_cmd.payload.load_partial_logic;

    if (pci_device_has_kernel_driver(
                &llapi::g_bce_fpga_devices[load_partial_logic.slot].pci_device)) {
        LOG(WARNING) << "Slot [" << load_partial_logic.slot
                     << "] is occupied by kernel driver, please `rmmod` first.";
        return -1;
    }

    /* Check partial.bin */
    if (load_partial_logic.partial_bin_path.size() == 0) {
        LOG(WARNING) << "You MUST specify a valid partial bin path "
                     << "with `--partial-bin-path` option.";
        return -1;
    }
    if (!load_partial_logic.force
        && !std_string_a_ends_with_b(load_partial_logic.partial_bin_path, EXPECTED_PARTIAL_SUFFIX)) {
        LOG(WARNING) << "Given partial bin path [" << load_partial_logic.partial_bin_path
                     << "] is not end with [" << EXPECTED_PARTIAL_SUFFIX << "].";
        return -1;
    }
    if (!regular_file_readable(load_partial_logic.partial_bin_path)) {
        LOG(WARNING) << "Given partial bin path [" << load_partial_logic.partial_bin_path
                     << "] is not a readable regular file.";
        return -1;
    }

    /* Check partial.bin.meta */
    const std::string partial_meta_path = load_partial_logic.partial_bin_path + ".meta";
    if (check_meta_file(load_partial_logic.slot, load_partial_logic.partial_bin_path,
                        partial_meta_path) != 0) {
        return -1;
    }

    /* Check partial_clear.bin */
    if (load_partial_logic.clear_bin_path.size() == 0) {
        LOG(WARNING) << "You MUST specify a valid partial clear bin path "
                     << "with `--partial-clear-bin-path` option.";
        return -1;
    }
    if (!load_partial_logic.force
        && !std_string_a_ends_with_b(load_partial_logic.clear_bin_path, EXPECTED_CLEAR_SUFFIX)) {
        LOG(WARNING) << "Given partial clear bin path [" << load_partial_logic.clear_bin_path
                     << "] is not end with [" << EXPECTED_CLEAR_SUFFIX << "].";
        return -1;
    }
    if (!regular_file_readable(load_partial_logic.clear_bin_path)) {
        LOG(WARNING) << "Given partial clear bin path [" << load_partial_logic.clear_bin_path
                     << "] is not a readable regular file.";
        return -1;
    }

    /* Check partial_clear.bin.meta */
    const std::string clear_meta_path = load_partial_logic.clear_bin_path + ".meta";
    if (check_meta_file(load_partial_logic.slot, load_partial_logic.clear_bin_path,
                        clear_meta_path) != 0) {
        return -1;
    }

    /* Check last_partial_clear.bin */
    if (load_partial_logic.last_clear_bin_path.size() == 0) {
        LOG(WARNING) << "Last clear bin path is not set.";
        return -1;
    }
    if (!regular_file_readable(load_partial_logic.last_clear_bin_path)) {
        LOG(WARNING) << "Last partial clear bin path [" << load_partial_logic.last_clear_bin_path
                     << "] is not a readable regular file.";
        return -1;
    }

    /* Check last_partial_clear.bin.meta */
    const std::string last_clear_meta_path = load_partial_logic.last_clear_bin_path + ".meta";
    if (check_meta_file(load_partial_logic.slot, load_partial_logic.last_clear_bin_path,
                        last_clear_meta_path) != 0) {
        return -1;
    }
    if (!(g_db["slots"][load_partial_logic.slot]["status"].asUInt() & 0x2)) {
        if (md5sum(load_partial_logic.last_clear_bin_path) !=
            g_db["slots"][load_partial_logic.slot]["last_clear_bin_md5sum"].asString()) {
            LOG(WARNING) << "Md5sum mismatch";
            return -1;
        }
    }

    return 0;
}

static int parse_load_default_partial_logic(int argc, char **argv)
{
    g_bce_fpga_cmd.payload.load_partial_logic.slot = -1;
    g_bce_fpga_cmd.payload.load_partial_logic.partial_bin_path = "";
    g_bce_fpga_cmd.payload.load_partial_logic.clear_bin_path = "";
    g_bce_fpga_cmd.payload.load_partial_logic.last_clear_bin_path = "";
    g_bce_fpga_cmd.payload.load_partial_logic.force = false;

    static struct option long_options[] = {
        { "slot", required_argument, 0, 'S' },
        { "help", no_argument, 0, 'h' },
        { "version", no_argument, 0, 'V' },
        { 0, 0, 0, 0 },
    };
    struct bce_fpga_load_partial_logic_cmd& load_partial_logic =
                g_bce_fpga_cmd.payload.load_partial_logic;

    int opt = 0;
    int long_index = 0;
    int ret = 0;
    optind = 2;
    while ((opt = getopt_long(argc, argv, "S:?hV", long_options, &long_index)) != -1) {
        switch (opt) {
        case 'S':
            load_partial_logic.slot = atoi(optarg);
            if ((load_partial_logic.slot < 0) || (load_partial_logic.slot >= 8)) {
                LOG(WARNING) << "Slot should be >= 0 and < 8.";
                ret = -1;
                goto show_usage;
            }
            break;
        case 'h':
            g_bce_fpga_cmd.finished = true;
            goto show_usage;
        case 'V':
            print_version();
            g_bce_fpga_cmd.finished = true;
            goto out;
        default:
            ret = -1;
            goto show_usage;
        }
    }

    /* Check slot */
    if (load_partial_logic.slot == -1) {
        LOG(WARNING) << "You MUST specify a valid slot with `-S` option.";
        ret = -1;
        goto show_usage;
    }
    if (!llapi::g_bce_fpga_devices[load_partial_logic.slot].present) {
        LOG(WARNING) << "Slot [" << load_partial_logic.slot << "] is not present.";
        ret = -1;
        goto show_usage;
    }

    load_partial_logic.partial_bin_path = "./base/base_pr_region_partial.bin";
    load_partial_logic.clear_bin_path = "./base/base_pr_region_partial_clear.bin";
    if (g_db["slots"][load_partial_logic.slot]["status"].asUInt() & 0x2) {
        /* default logic */
        load_partial_logic.last_clear_bin_path = "./base/base_pr_region_partial_clear.bin";
    } else {
        load_partial_logic.last_clear_bin_path = base::string_printf("%s/%d/last_partial_clear.bin",
                g_tmp_dir_path.c_str(), load_partial_logic.slot);
    }

    if (check_load_partial_logic()) {
        /* failed */
        ret = -1;
    } else {
        /* passed */
        ret = 0;
        goto out;
    }

show_usage:
    print_usage(g_load_default_partial_logic_usage, ARRAY_SIZE(g_load_default_partial_logic_usage));
out:
    return ret;
}

static int parse_load_partial_logic(int argc, char **argv)
{
    g_bce_fpga_cmd.payload.load_partial_logic.slot = -1;
    g_bce_fpga_cmd.payload.load_partial_logic.partial_bin_path = "";
    g_bce_fpga_cmd.payload.load_partial_logic.clear_bin_path = "";
    g_bce_fpga_cmd.payload.load_partial_logic.last_clear_bin_path = "";
    g_bce_fpga_cmd.payload.load_partial_logic.force = false;

    static struct option long_options[] = {
        { "slot", required_argument, 0, 'S' },
        { "partial-bin-path", required_argument, 0, 'P' },
        { "partial-clear-bin-path", required_argument, 0, 'C' },
        { "force", no_argument, 0, 'f' },
        { "help", no_argument, 0, 'h' },
        { "version", no_argument, 0, 'V' },
        { 0, 0, 0, 0 },
    };
    struct bce_fpga_load_partial_logic_cmd& load_partial_logic =
                g_bce_fpga_cmd.payload.load_partial_logic;
    std::string& partial_bin_path = g_bce_fpga_cmd.payload.load_partial_logic.partial_bin_path;
    std::string& clear_bin_path = g_bce_fpga_cmd.payload.load_partial_logic.clear_bin_path;

    int opt = 0;
    int long_index = 0;
    int ret = 0;
    optind = 2;
    while ((opt = getopt_long(argc, argv, "S:P:C:f?hV", long_options, &long_index)) != -1) {
        switch (opt) {
        case 'S':
            load_partial_logic.slot = atoi(optarg);
            if ((load_partial_logic.slot < 0) || (load_partial_logic.slot >= 8)) {
                LOG(WARNING) << "Slot should be >= 0 and < 8.";
                ret = -1;
                goto show_usage;
            }
            break;
        case 'P':
            partial_bin_path = normalize_path(optarg);
            break;
        case 'C':
            clear_bin_path = normalize_path(optarg);
            break;
        case 'f':
            load_partial_logic.force = true;
            break;
        case 'h':
            g_bce_fpga_cmd.finished = true;
            goto show_usage;
        case 'V':
            print_version();
            g_bce_fpga_cmd.finished = true;
            goto out;
        default:
            ret = -1;
            goto show_usage;
        }
    }

    /* Check slot */
    if (load_partial_logic.slot == -1) {
        LOG(WARNING) << "You MUST specify a valid slot with `-S` option.";
        ret = -1;
        goto show_usage;
    }
    if (!llapi::g_bce_fpga_devices[load_partial_logic.slot].present) {
        LOG(WARNING) << "Slot [" << load_partial_logic.slot << "] is not present.";
        ret = -1;
        goto show_usage;
    }

    if ((clear_bin_path.size() == 0)
        && std_string_a_ends_with_b(partial_bin_path, EXPECTED_PARTIAL_SUFFIX)) {
        clear_bin_path = partial_bin_path.substr(0,
                         partial_bin_path.size() - EXPECTED_PARTIAL_SUFFIX.size())
                         + EXPECTED_CLEAR_SUFFIX;
    }

    if (g_db["slots"][load_partial_logic.slot]["status"].asUInt() & 0x2) {
        /* default logic */
        load_partial_logic.last_clear_bin_path = "./base/base_pr_region_partial_clear.bin";
    } else {
        load_partial_logic.last_clear_bin_path = base::string_printf("%s/%d/last_partial_clear.bin",
                g_tmp_dir_path.c_str(), load_partial_logic.slot);
    }

    if (check_load_partial_logic()) {
        /* failed */
        ret = -1;
    } else {
        /* passed */
        ret = 0;
        goto out;
    }

show_usage:
    print_usage(g_load_partial_logic_usage, ARRAY_SIZE(g_load_partial_logic_usage));
out:
    return ret;
}

class argc_argv_parser {
public:
    argc_argv_parser() : _content(CAPACITY, '\0'), _cur(0)
    {
    }

    void append(const std::string& arg)
    {
        std::istringstream iss(arg);
        std::vector<std::string> tokens;
        std::copy(std::istream_iterator<std::string>(iss),
                  std::istream_iterator<std::string>(), std::back_inserter(tokens));
        for (auto&& token : tokens) {
            if (_cur + token.size() + 1 > CAPACITY) {
                break;
            }

            std::copy(token.cbegin(), token.cend(), &_content[_cur]);
            _content[_cur + token.size()] = '\0';
            _argv.push_back(&_content[_cur]);

            _cur += token.size() + 1;
        }
    }

    const int argc() const
    {
        return _argv.size();
    }

    const char *const *argv() const
    {
        return &_argv[0];
    }

    void dump() const
    {
        LOG(INFO) << __func__;
        LOG(INFO) << "_content = " << _content;
        for (std::string::size_type i = 0; i < _argv.size(); ++i) {
            LOG(INFO) << i << " - " << _argv[i];
        }
        LOG(INFO) << __func__;
    }

private:
    std::vector<const char *> _argv;
    std::string _content;
    size_t _cur;

    static const size_t CAPACITY = 4096;
};

extern "C" {
    int mcap_main(int argc, char **argv);
}

/* TODO: error handling */
static int do_load_partial_logic()
{
    struct bce_fpga_load_partial_logic_cmd& load_partial_logic =
                g_bce_fpga_cmd.payload.load_partial_logic;
    int ret = 0;
    argc_argv_parser clear_parser;
    argc_argv_parser partial_parser;
    std::string fmt_time;

    LOG(INFO) << "Set decouple ...";
    ret = llapi::mgmt_reg_write_32(load_partial_logic.slot, 8, 1);
    if (ret != 0) {
        LOG(WARNING) << "Error in llapi::mgmt_reg_write_32";
        ret = -1;
        goto out;
    }
    sleep(1);
    LOG(INFO) << "Set decouple done";

    LOG(INFO) << "Download clear bin ...";
    clear_parser.append("mcap -x 9038 -C");
    clear_parser.append(load_partial_logic.last_clear_bin_path);
    //clear_parser.dump();
    /* there's getopt() inside mcap_main, reset `optind` first */
    optind = 1;
    ret = mcap_main(clear_parser.argc(), const_cast<char **>(clear_parser.argv()));
    if (ret != 0) {
        LOG(WARNING) << "Error in mcap_main when downloading clear bin";
        ret = -1;
        goto out;
    }
    sleep(1);
    LOG(INFO) << "Download clear bin done";

    LOG(INFO) << "Download partial bin ...";
    partial_parser.append("mcap -x 9038 -p");
    partial_parser.append(load_partial_logic.partial_bin_path);
    //partial_parser.dump();
    /* there's getopt() inside mcap_main, reset `optind` first */
    optind = 1;
    ret = mcap_main(partial_parser.argc(), const_cast<char **>(partial_parser.argv()));
    if (ret != 0) {
        LOG(WARNING) << "Error in mcap_main when downloading partial bin";
        ret = -1;
        goto out;
    }
    sleep(1);
    LOG(INFO) << "Download partial bin done";

    LOG(INFO) << "Unset decouple ...";
    ret = llapi::mgmt_reg_write_32(load_partial_logic.slot, 8, 0);
    if (ret != 0) {
        LOG(WARNING) << "Error in llapi::mgmt_reg_write_32";
        ret = -1;
        goto out;
    }
    sleep(1);
    LOG(INFO) << "Unset decouple done";

    LOG(INFO) << "Reset ...";
    ret = llapi::mgmt_reg_write_32(load_partial_logic.slot, 248, 0);
    if (ret != 0) {
        LOG(WARNING) << "Error in llapi::mgmt_reg_write_32";
        ret = -1;
        goto out;
    }
    sleep(1);
    LOG(INFO) << "Reset done";

    LOG(INFO) << "Write clear bin md5 ...";
    {
        unsigned char hex[16];
        std::string str = md5sum(load_partial_logic.clear_bin_path);
        md5sum_std_string_2_hex(str, hex);
        llapi::mgmt_reg_write_32(load_partial_logic.slot, 0x100, *(uint32_t *)&hex[0]);
        llapi::mgmt_reg_write_32(load_partial_logic.slot, 0x104, *(uint32_t *)&hex[4]);
        llapi::mgmt_reg_write_32(load_partial_logic.slot, 0x108, *(uint32_t *)&hex[8]);
        llapi::mgmt_reg_write_32(load_partial_logic.slot, 0x10c, *(uint32_t *)&hex[12]);
    }
    LOG(INFO) << "Write clear bin md5 done";

    fmt_time = get_fmt_time_string();
    {
        std::string clear_bin_basename = fmt_time + " partial_clear.bin";
        std::string clear_meta_basename = fmt_time + " partial_clear.bin.meta";
        std::string cp_cmd = base::string_printf(
                                     "cp -rf \"%s\" \"%s/%d/%s\" && "
                                     "ln -sf \"%s/%d/%s\" \"%s/%d/last_partial_clear.bin\" && "
                                     "cp -rf \"%s\" \"%s/%d/%s\" && "
                                     "ln -sf \"%s/%d/%s\" \"%s/%d/last_partial_clear.bin.meta\"",
                                     load_partial_logic.clear_bin_path.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot,
                                     clear_bin_basename.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot,
                                     clear_bin_basename.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot,
                                     (load_partial_logic.clear_bin_path + ".meta").c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot,
                                     clear_meta_basename.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot,
                                     clear_meta_basename.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot);
        int sh_ret = system(cp_cmd.c_str());
        if (sh_ret) {
            LOG(WARNING) << "Error in exec [" << cp_cmd << "]";
        }
    }

    uint32_t value;
    g_db["slots"][load_partial_logic.slot]["last_load_timestamp"] = fmt_time;
    g_db["slots"][load_partial_logic.slot]["last_partial_bin_path"] =
            load_partial_logic.partial_bin_path;
    g_db["slots"][load_partial_logic.slot]["last_clear_bin_path"] =
            load_partial_logic.clear_bin_path;
    llapi::mgmt_reg_read_32(load_partial_logic.slot, 4, &value);
    g_db["slots"][load_partial_logic.slot]["status_after_load"] = value;

out:
    return ret;
}

static int parse_reset_partial_logic(int argc, char **argv)
{
    g_bce_fpga_cmd.payload.reset_partial_logic.slot = -1;

    static struct option long_options[] = {
        { "slot", required_argument, 0, 'S' },
        { "help", no_argument, 0, 'h' },
        { "version", no_argument, 0, 'V' },
        { 0, 0, 0, 0 },
    };

    int opt = 0;
    int long_index = 0;
    int ret = 0;
    optind = 2;
    while ((opt = getopt_long(argc, argv, "S:?hV", long_options, &long_index)) != -1) {
        switch (opt) {
        case 'S':
            g_bce_fpga_cmd.payload.reset_partial_logic.slot = atoi(optarg);
            if ((g_bce_fpga_cmd.payload.reset_partial_logic.slot < 0)
                || (g_bce_fpga_cmd.payload.reset_partial_logic.slot >= 8)) {
                LOG(WARNING) << "Slot should be >= 0 and < 8.";
                ret = -1;
                goto show_usage;
            }
            break;
        case 'h':
            g_bce_fpga_cmd.finished = true;
            goto show_usage;
        case 'V':
            print_version();
            g_bce_fpga_cmd.finished = true;
            goto out;
        default:
            ret = -1;
            goto show_usage;
        }
    }

    /* Check slot */
    if (g_bce_fpga_cmd.payload.reset_partial_logic.slot == -1) {
        LOG(WARNING) << "You MUST specify a valid slot with `-S` option.";
        ret = -1;
        goto show_usage;
    }
    if (!llapi::g_bce_fpga_devices[g_bce_fpga_cmd.payload.reset_partial_logic.slot].present) {
        LOG(WARNING) << "Slot [" << g_bce_fpga_cmd.payload.reset_partial_logic.slot
                     << "] is not present.";
        ret = -1;
        goto show_usage;
    }

    goto out;

show_usage:
    print_usage(g_reset_partial_logic_usage, ARRAY_SIZE(g_reset_partial_logic_usage));
out:
    return ret;
}

static int do_reset_partial_logic()
{
    struct bce_fpga_reset_partial_logic_cmd& reset_partial_logic =
                g_bce_fpga_cmd.payload.reset_partial_logic;

    LOG(INFO) << "Reset partial logic ...";
    llapi::mgmt_reg_write_32(reset_partial_logic.slot, 248, 0);
    LOG(INFO) << "Reset partial logic done";

    return 0;
}

static int parse_reset_static_logic(int argc, char **argv)
{
    g_bce_fpga_cmd.payload.reset_static_logic.slot = -1;

    static struct option long_options[] = {
        { "slot", required_argument, 0, 'S' },
        { "help", no_argument, 0, 'h' },
        { "version", no_argument, 0, 'V' },
        { 0, 0, 0, 0 },
    };

    int opt = 0;
    int long_index = 0;
    int ret = 0;
    optind = 2;
    while ((opt = getopt_long(argc, argv, "S:?hV", long_options, &long_index)) != -1) {
        switch (opt) {
        case 'S':
            g_bce_fpga_cmd.payload.reset_static_logic.slot = atoi(optarg);
            if ((g_bce_fpga_cmd.payload.reset_static_logic.slot < 0)
                || (g_bce_fpga_cmd.payload.reset_static_logic.slot >= 8)) {
                LOG(WARNING) << "Slot should be >= 0 and < 8.";
                ret = -1;
                goto show_usage;
            }
            break;
        case 'h':
            g_bce_fpga_cmd.finished = true;
            goto show_usage;
        case 'V':
            print_version();
            g_bce_fpga_cmd.finished = true;
            goto out;
        default:
            ret = -1;
            goto show_usage;
        }
    }

    /* Check slot */
    if (g_bce_fpga_cmd.payload.reset_static_logic.slot == -1) {
        LOG(WARNING) << "You MUST specify a valid slot with `-S` option.";
        ret = -1;
        goto show_usage;
    }
    if (!llapi::g_bce_fpga_devices[g_bce_fpga_cmd.payload.reset_static_logic.slot].present) {
        LOG(WARNING) << "Slot [" << g_bce_fpga_cmd.payload.reset_static_logic.slot
                     << "] is not present.";
        ret = -1;
        goto show_usage;
    }

    goto out;

show_usage:
    print_usage(g_reset_static_logic_usage, ARRAY_SIZE(g_reset_static_logic_usage));
out:
    return ret;
}

static int do_reset_static_logic()
{
    struct bce_fpga_reset_static_logic_cmd& reset_static_logic =
                g_bce_fpga_cmd.payload.reset_static_logic;

    LOG(INFO) << "Reset static logic ...";
    llapi::mgmt_reg_write_32(reset_static_logic.slot, 252, 0);
    LOG(INFO) << "Reset static logic done";

    return 0;
}

static struct bce_fpga_cmd_parse_ent {
    const char *str;
    enum BCE_FPGA_CMD_WORD cmd;
    bce_fpga_parse_cmd_args_func_t parse_func;
    bce_fpga_action_func_t action_func;
} g_bce_fpga_cmd_parse_tbl[] = {
    {
        "LoadPartialLogic", LOAD_PARTIAL_LOGIC,
        &parse_load_partial_logic, &do_load_partial_logic
    },
    {
        "LoadDefaultPartialLogic", LOAD_DEFAULT_PARTIAL_LOGIC,
        &parse_load_default_partial_logic, &do_load_partial_logic
    },
    {
        "DescribeSlot", DESCRIBE_SLOT,
        &parse_describe_slot, &do_describe_slot
    },
    {
        "ResetPartialLogic", RESET_PARTIAL_LOGIC,
        &parse_reset_partial_logic, &do_reset_partial_logic
    },
    {
        "ResetStaticLogic", RESET_STATIC_LOGIC,
        &parse_reset_static_logic, &do_reset_static_logic
    },
};

static int parse_bce_fpga_cmd(int argc, char **argv)
{
    int ret = -1;

    if (argc < 2) {
        goto show_usage;
    }

    g_bce_fpga_cmd.finished = false;
    for (int i = 0; i < ARRAY_SIZE(g_bce_fpga_cmd_parse_tbl); ++i) {
        if (strcasecmp(argv[1], g_bce_fpga_cmd_parse_tbl[i].str) == 0) {
            g_bce_fpga_cmd.cmd = g_bce_fpga_cmd_parse_tbl[i].cmd;
            if (g_bce_fpga_cmd_parse_tbl[i].parse_func) {
                ret = g_bce_fpga_cmd_parse_tbl[i].parse_func(argc, argv);
            }
            goto out;
        }
    }

show_usage:
    print_usage(g_bce_fpga_usage, ARRAY_SIZE(g_bce_fpga_usage));
out:
    return ret;
}

int exec_bce_fpga_cmd()
{
    if (g_bce_fpga_cmd.finished) {
        return 0;
    }

    for (int i = 0; i < ARRAY_SIZE(g_bce_fpga_cmd_parse_tbl); ++i) {
        if (g_bce_fpga_cmd.cmd == g_bce_fpga_cmd_parse_tbl[i].cmd) {
            if (g_bce_fpga_cmd_parse_tbl[i].action_func) {
                return g_bce_fpga_cmd_parse_tbl[i].action_func();
            }
        }
    }

    return -1;
}

static int prologue()
{
    int ret = 0;

    ret = mkdir(g_tmp_dir_path.c_str(), 0777);
    if (ret && (errno != EEXIST)) {
        LOG(WARNING) << "Error in mkdir";
        return -1;
    }
    for (int i = 0; i < 8; ++i) {
        if (llapi::g_bce_fpga_devices[i].present) {
            std::string slot_dir_path = base::string_printf("%s/%d", g_tmp_dir_path.c_str(), i);
            ret = mkdir(slot_dir_path.c_str(), 0777);
            if (ret && (errno != EEXIST)) {
                LOG(WARNING) << "Error in mkdir";
                return -1;
            }
        }
    }

    if (!regular_file_readable(g_db_path)) {
        Json::Value root;
        Json::Value slots;
        Json::Value slot;

        for (int i = 0; i < 8; ++i) {
            slot["slot"] = i;
            slot["present"] = false;
            slot["status"] = 0xffffffff;
            slot["static_version"] = "n/a";
            slot["last_clear_bin_md5sum"] = "n/a";
            slots.append(slot);
        }
        root["slots"] = slots;
        root["version"] = "n/a";
        root["magic"] = "bce_fpga_mgmt_tool";
        root["created"] = get_fmt_time_string();

        std::ofstream ofs(g_db_path, std::ios_base::trunc);
        if (!ofs.is_open()) {
            LOG(WARNING) << "Error in ofstream";
            return -1;
        }
        ofs << root;
    }

    std::ifstream ifs(g_db_path);
    if (!ifs.is_open()) {
        LOG(WARNING) << "Error in ifstream";
        return -1;
    }
    ifs >> g_db;
    //LOG(WARNING) << g_db.toStyledString();

    for (int i = 0; i < 8; ++i) {
        if (llapi::g_bce_fpga_devices[i].present) {
            uint32_t value;
            g_db["slots"][i]["present"] = true;
            llapi::mgmt_reg_read_32(i, 4, &value);
            g_db["slots"][i]["status"] = value;
            llapi::mgmt_reg_read_32(i, 0, &value);
            g_db["slots"][i]["static_version"] = value;

            unsigned char hex[16];
            llapi::mgmt_reg_read_32(i, 0x100, (uint32_t *)&hex[0]);
            llapi::mgmt_reg_read_32(i, 0x104, (uint32_t *)&hex[4]);
            llapi::mgmt_reg_read_32(i, 0x108, (uint32_t *)&hex[8]);
            llapi::mgmt_reg_read_32(i, 0x10c, (uint32_t *)&hex[12]);
            g_db["slots"][i]["last_clear_bin_md5sum"] = md5sum_hex_2_std_string(hex);
        }
    }

    return 0;
}

static int epilogue()
{
    g_db["modified"] = get_fmt_time_string();

    std::ofstream ofs(g_db_path, std::ios_base::trunc);
    if (!ofs.is_open()) {
        LOG(WARNING) << "Error in ofstream";
        return -1;
    }
    ofs << g_db;

    return 0;
}

int main(int argc, char **argv)
{
    ::google::InitGoogleLogging(argv[0]);
    FLAGS_alsologtostderr = 1;

    /* ignore signals like SIGINT/SIGTERM/SIGQUIT, some key process
     * in this program can not be interrupted */
    struct sigaction ignore_signal;
    memset(&ignore_signal, 0, sizeof(struct sigaction));
    ignore_signal.sa_handler = SIG_IGN;
    sigaction(SIGINT, &ignore_signal, NULL);
    sigaction(SIGTERM, &ignore_signal, NULL);
    sigaction(SIGQUIT, &ignore_signal, NULL);

    /* only one single instance is permitted */
    base::fd_guard pid_file(open("/var/tmp/bce_fpga_dev_kit.pid", O_CREAT | O_RDWR, 0666));
    if (pid_file == -1) {
        LOG(WARNING) << "Error opening pid file /var/tmp/bce_fpga_dev_kit.pid.";
        return 1;
    }
    if (flock(pid_file, LOCK_EX | LOCK_NB) != 0) {
        LOG(WARNING) << "Another bce_fpga_dev_kit instance is running.";
        return 1;
    }

    if (geteuid() != 0) {
        LOG(WARNING) << "bce_fpga_mgmt_tool should be run as root.";
        return 1;
    }

    umask(0000);

    int ret = 0;
    ret = prologue();
    if (ret) {
        return 1;
    }
    ret = epilogue();
    if (ret) {
        return 1;
    }

    ret = parse_bce_fpga_cmd(argc, argv);
    if (ret) {
        return 1;
    }

    ret = exec_bce_fpga_cmd();
    if (ret) {
        return 1;
    }

    ret = epilogue();
    if (ret) {
        return 1;
    }

    return 0;
}

