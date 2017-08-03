/*
 * Copyright 2015-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"). You may
 * not use this file except in compliance with the License. A copy of the
 * License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
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

#include <pciaccess.h>
#include <glog/logging.h>
#include <json/json.h>

#include "config.h"
#include "string_printf.h"
#include "fd_guard.h"

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

static Json::Value g_db;
static const std::string g_tmp_dir_path = "/tmp/bce_fpga_dev_kit";
static const std::string g_db_path = g_tmp_dir_path + "/db";
static const std::string EXPECTED_PARTIAL_SUFFIX = "partial.bin";
static const std::string EXPECTED_CLEAR_SUFFIX = "partial_clear.bin";

static const char *g_bce_fpga_usage[] = {
    "Synopsis",
    "   bce_fpga_mgmt_tool <general option> [general option args] [-h]",
    "General Option",
    "   LoadPartialLogic/LoadDefaultPartialLogic/DescribeSlot",

};

static void print_usage(const char **usage, size_t nlines)
{
    for (size_t i = 0; i < nlines; ++i) {
        printf("%s\n", usage[i]);
    }
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

/*
 *static int fpga_pci_get_id(const char *path, uint16_t *id)
 *{
 *    CHECK_NOTNULL(path);
 *    CHECK_NOTNULL(id);
 *
 *    int ret = 0;
 *    FILE *fp = fopen(path, "r");
 *    if (!fp) {
 *        LOG(WARNING) << "Error opening " << path;
 *        ret = -1;
 *        goto err;
 *    }
 *
 *    uint32_t tmp_id;
 *    ret = fscanf(fp, "%x", &tmp_id);
 *    if (ret < 0) {
 *        LOG(WARNING) << "Error parsing " << path;
 *        ret = -1;
 *        goto err_close;
 *    } else {
 *        ret = 0;
 *    }
 *
 *    *id = (uint16_t)tmp_id;
 *
 *err_close:
 *    fclose(fp);
 *err:
 *    return ret;
 *}
 */

/*
 *static int write_loop(int fd, const char *buf, size_t count)
 *{
 *    CHECK(fd > 0);
 *
 *    ssize_t cur = 0;
 *
 *    for (size_t sent = 0; sent < count; sent += cur) {
 *        do {
 *            cur = write(fd, buf + sent, count - sent);
 *        } while (cur == -1 && errno == EINTR);
 *
 *        if (cur < 0) {
 *            return -1;
 *        }
 *
 *        if (cur == 0) {
 *            return 1;
 *        }
 *    }
 *
 *    return 0;
 *}
 */

/*
 *static int fpga_pci_write_one2file(const char *path)
 *{
 *    CHECK_NOTNULL(path);
 *
 *    int ret = 0;
 *
 *    int fd = open(path, O_WRONLY);
 *    if (fd < 0) {
 *        LOG(WARNING) << "Error opening " << path;
 *        ret = -1;
 *        goto err;
 *    }
 *
 *    const static char buf[] = "1";
 *    ret = write_loop(fd, buf, sizeof(buf));
 *    if (ret) {
 *        LOG(WARNING) << "Error writing " << path;
 *        ret = -1;
 *    }
 *
 *err_close:
 *    close(fd);
 *err:
 *    return ret;
 *}
 */

static struct bce_fpga_device {
    bool present;
    struct pci_device pci_device;
} g_bce_fpga_devices[8];

static int reg_read_32(int slot, uint64_t addr, uint32_t *value)
{
    CHECK((slot >= 0) && (slot < 8));
    CHECK(g_bce_fpga_devices[slot].present);
    CHECK_NOTNULL(g_bce_fpga_devices[slot].pci_device.regions[0].memory);

    *value = *(uint32_t *)((uint64_t)g_bce_fpga_devices[slot].pci_device.regions[0].memory + addr);
    return 0;
}

static int reg_write_32(int slot, uint64_t addr, uint32_t value)
{
    CHECK((slot >= 0) && (slot < 8));
    CHECK(g_bce_fpga_devices[slot].present);
    CHECK_NOTNULL(g_bce_fpga_devices[slot].pci_device.regions[0].memory);

    *(uint32_t *)((uint64_t)g_bce_fpga_devices[slot].pci_device.regions[0].memory + addr) = value;
    return 0;
}

static int probe_all_slots()
{
    int ret = 0;
    struct pci_device_iterator *it = NULL;
    struct pci_device *dev = NULL;

    ret = pci_system_init();
    if (ret) {
        LOG(WARNING) << "Error calling pci_system_init";
        return -1;
    }

    struct pci_id_match xilinx_match = {
        0x10ee,          /* vendor_id */
        PCI_MATCH_ANY,   /* device_id */
        PCI_MATCH_ANY,   /* subvendor_id */
        PCI_MATCH_ANY,   /* subdevice_id */
    };
    int slot = 0;

    memset(&g_bce_fpga_devices, 0, sizeof(g_bce_fpga_devices));
    it = pci_id_match_iterator_create(&xilinx_match);
    if (!it) {
        LOG(WARNING) << "Error calling pci_id_match_iterator_create";
        ret = -1;
        goto err;
    }
    for (;;) {
        dev = pci_device_next(it);
        if (!dev) {
            /* End of iteration */
            goto err_it;
        }

        /**
         * pci_enable_device - Initialize device before it's used by a driver.
         * @dev: PCI device to be initialized
         *
         *  Initialize device before it's used by a driver. Ask low-level code
         *  to enable I/O and memory. Wake up the device if it was suspended.
         *  Beware, this function can fail.
         *
         *  Note we don't actually enable the device many times if we call
         *  this function repeatedly (we just increment the count).
         */
        /* equalvalent with `echo 1 > /sys/bus/pci/devices/.../enable` */
        pci_device_enable(dev);

        /* Probes a PCI device to learn various information about the device. Before calling this
         * function, the only public fields in the pci_device structure that have valid values are
         * pci_device::domain, pci_device::bus, pci_device::dev, and pci_device::func. */
        ret = pci_device_probe(dev);
        if (ret) {
            LOG(WARNING) << "Error calling pci_device_probe";
            ret = -1;
            goto err_it;
        }

        /* mmap BAR0 */
        ret = pci_device_map_range(dev, dev->regions[0].base_addr, dev->regions[0].size,
                                   PCI_DEV_MAP_FLAG_WRITABLE, &dev->regions[0].memory);
        if (ret) {
            LOG(WARNING) << "Error calling pci_device_map_range";
            ret = -1;
            goto err_it;
        }

        g_bce_fpga_devices[slot].present = true;
        g_bce_fpga_devices[slot].pci_device = *dev;
        ++slot;
    }

err_it:
    pci_iterator_destroy(it);
err:
    /* XXX: pci_system_cleanup() would munmap all PCI BARs... */
    //pci_system_cleanup();
    return ret;
}

enum BCE_FPGA_CMD_WORD {
    LOAD_PARTIAL_LOGIC = 1,
    LOAD_DEFAULT_PARTIAL_LOGIC,
    DESCRIBE_SLOT,
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

static struct bce_fpga_cmd {
    enum BCE_FPGA_CMD_WORD cmd;
    bool finished;

    /* XXX: Cannot use `union` here, as some inner structs have non-trivial ctor/dtor. */
    struct {
        struct bce_fpga_load_partial_logic_cmd load_partial_logic;
        struct bce_fpga_describe_slot_cmd describe_slot;
    } payload;
} g_bce_fpga_cmd;

typedef int (*bce_fpga_parse_cmd_args_func_t)(int argc, char **argv);
typedef int (*bce_fpga_action_func_t)();

static void print_version()
{
    printf("bce_fpga_mgmt_tool : V%d.%d\n", BCE_FPGA_MGMT_TOOL_VERSION_MAJOR,
           BCE_FPGA_MGMT_TOOL_VERSION_MINOR);
}

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

show_usage:
out:
    return ret;
}

static void describe_one_slot(int slot)
{
    printf("|");
    printf(" %10d |", slot);
    char dbdf[13];
    snprintf(dbdf, sizeof(dbdf), "%04x:%02x:%02x.%01x",
             g_bce_fpga_devices[slot].pci_device.domain,
             g_bce_fpga_devices[slot].pci_device.bus,
             g_bce_fpga_devices[slot].pci_device.dev,
             g_bce_fpga_devices[slot].pci_device.func);
    printf(" %15s |", dbdf);
    printf(" %#10x |", g_bce_fpga_devices[slot].pci_device.vendor_id);
    printf(" %#10x |", g_bce_fpga_devices[slot].pci_device.device_id);
    printf(" %20s |", "<TODO>");
    printf(" %20s |", "<TODO>");
    printf(" %20s |", "<TODO>");
    printf(" %20s |", "<TODO>");
    printf(" %20s |", "<TODO>");
    printf(" %20s |", "<TODO>");
    printf("\n");
}

static int do_describe_slot()
{
    printf("| %10s | %15s | %10s | %10s | %20s | %20s | %20s | %20s | %20s | %20s |\n",
           "Slot", "DBDF", "VendorId", "DeviceId",
           "StaticVersion", "StaticStatusCode", "StaticStatus",
           "PartialUUID", "PartialStatusCode", "PartialStatus");
    printf("%s\n",
           std::string(10 + 15 + 10 + 10 + 20 + 20 + 20 + 20 + 20 + 20 + 10 * 3 + 1, '-').c_str());

    if (g_bce_fpga_cmd.payload.describe_slot.slot == -1) {
        /* show all slots */
        for (int i = 0; i < 8; ++i) {
            if (g_bce_fpga_devices[i].present) {
                describe_one_slot(i);
            }
        }
    } else {
        if (g_bce_fpga_devices[g_bce_fpga_cmd.payload.describe_slot.slot].present) {
            describe_one_slot(g_bce_fpga_cmd.payload.describe_slot.slot);
        }
    }

    return 0;
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

static int check_load_partial_logic()
{
    struct bce_fpga_load_partial_logic_cmd& load_partial_logic =
                g_bce_fpga_cmd.payload.load_partial_logic;

    if (pci_device_has_kernel_driver(&g_bce_fpga_devices[load_partial_logic.slot].pci_device)) {
        LOG(WARNING) << "Slot [" << load_partial_logic.slot
                     << "] is occupied by kernel driver, please `rmmod` first.";
        return -1;
    }

    /* Check partial_bin_path */
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

    /* Check clear_bin_path */
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

    /* Check last_clear_bin_path */
    if (load_partial_logic.last_clear_bin_path.size() == 0) {
        LOG(WARNING) << "Last clear bin path is not set.";
        return -1;
    }
    if (!regular_file_readable(load_partial_logic.last_clear_bin_path)) {
        LOG(WARNING) << "Last partial clear bin path [" << load_partial_logic.last_clear_bin_path
                     << "] is not a readable regular file.";
        return -1;
    }

    /* TODO: check static logic version and bin file md5sum */

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
    if (!g_bce_fpga_devices[load_partial_logic.slot].present) {
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
            partial_bin_path = optarg;
            break;
        case 'C':
            clear_bin_path = optarg;
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
    if (!g_bce_fpga_devices[load_partial_logic.slot].present) {
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

    LOG(INFO) << "Set decouple";
    reg_write_32(load_partial_logic.slot, 8, 1);
    sleep(1);
    LOG(INFO) << "Set decouple done";

    LOG(INFO) << "Download clear bin";
    argc_argv_parser clear_parser;
    clear_parser.append("mcap -x 9038 -C");
    clear_parser.append(load_partial_logic.last_clear_bin_path);
    //clear_parser.dump();
    /* there's getopt() inside mcap_main, reset `optind` first */
    optind = 1;
    mcap_main(clear_parser.argc(), const_cast<char **>(clear_parser.argv()));
    LOG(INFO) << "Download clear bin done";

    LOG(INFO) << "Download partial bin";
    argc_argv_parser partial_parser;
    partial_parser.append("mcap -x 9038 -p");
    partial_parser.append(load_partial_logic.partial_bin_path);
    //partial_parser.dump();
    /* there's getopt() inside mcap_main, reset `optind` first */
    optind = 1;
    mcap_main(partial_parser.argc(), const_cast<char **>(partial_parser.argv()));
    LOG(INFO) << "Download partial bin done";

    LOG(INFO) << "Unset decouple";
    reg_write_32(load_partial_logic.slot, 8, 0);
    sleep(1);
    LOG(INFO) << "Unset decouple done";

    LOG(INFO) << "Reset";
    reg_write_32(load_partial_logic.slot, 248, 0);
    LOG(INFO) << "Reset done";

    std::string fmt_time = get_fmt_time_string();
    {
        std::string clear_bin_basename = fmt_time + " partial_clear.bin";
        std::string cp_cmd = base::string_printf(
                                     "cp -rf \"%s\" \"%s/%d/%s\" && "
                                     "ln -sf \"%s/%d/%s\" \"%s/%d/last_partial_clear.bin\"",
                                     load_partial_logic.clear_bin_path.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot,
                                     clear_bin_basename.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot,
                                     clear_bin_basename.c_str(),
                                     g_tmp_dir_path.c_str(),
                                     load_partial_logic.slot);
        int sh_ret = system(cp_cmd.c_str());
        if (sh_ret) {
            LOG(WARNING) << "Error in exec [" << cp_cmd << "]";
        }
    }

    g_db["slots"][load_partial_logic.slot]["last_load_timestamp"] = fmt_time;
    g_db["slots"][load_partial_logic.slot]["status_after_load"] = 0b00000;

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
        if (g_bce_fpga_devices[i].present) {
            std::string slot_dir_path = base::string_printf("%s/%d", g_tmp_dir_path.c_str(), i);
            ret = mkdir(slot_dir_path.c_str(), 0777);
            if (ret && (errno != EEXIST)) {
                LOG(WARNING) << "Error in mkdir";
                return -1;
            }
        }
    }

    if (!regular_file_readable(g_db_path)) {
regenerate_db:
        Json::Value root;
        Json::Value slots;
        Json::Value slot;

        for (int i = 0; i < 8; ++i) {
            slot["slot"] = i;
            slot["present"] = false;
            slot["status"] = 0xffffffff;
            slot["static_version"] = "testversion";
            slots.append(slot);
        }
        root["slots"] = slots;
        root["version"] = "testversion";
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
        if (g_bce_fpga_devices[i].present) {
            /*
             *uint32_t status;
             *reg_read_32(i, 4, &status);
             *g_db["slots"][i]["status"] = status;
             */
            g_db["slots"][i]["present"] = true;
            g_db["slots"][i]["status"] = 0b00000;
            g_db["slots"][i]["static_version"] = "testversion";
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

    struct sigaction ignore_signal;
    memset(&ignore_signal, 0, sizeof(struct sigaction));
    ignore_signal.sa_handler = SIG_IGN;
    sigaction(SIGINT, &ignore_signal, NULL);
    sigaction(SIGTERM, &ignore_signal, NULL);
    sigaction(SIGQUIT, &ignore_signal, NULL);

    /* only one single instance is permitted */
    base::fd_guard pid_file(open("/var/tmp/bce_fpga_dev_kit.pid", O_CREAT | O_RDWR, 0666));
    if (pid_file == -1) {
        LOG(WARNING) << "Error opening pid file /var/tmp/bce_fpga_dev_kit.pid";
        return 1;
    }
    if (flock(pid_file, LOCK_EX | LOCK_NB) != 0) {
        LOG(WARNING) << "Another bce_fpga_dev_kit instance is running";
        return 1;
    }

    umask(0000);

    int ret = 0;
    ret = probe_all_slots();
    if (ret) {
        LOG(WARNING) << "Error in probe_all_slots";
        return 1;
    }

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

#if 0
/**
 * Remove the application PF for the given app map.
 *
 * @param[out]  app_map         the application device resource map to remove
 *
 * @returns
 *  0   on success
 * -1   on failure
 */
static int
fpga_pci_remove_app_pf(struct fpga_pci_resource_map *app_map)
{
    fail_on(!app_map, err, CLI_INTERNAL_ERR_STR);

    /** Construct the PCI device directory name using the PCI_DEV_FMT */
    char dir_name[NAME_MAX + 1];
    int ret = snprintf(dir_name, sizeof(dir_name), PCI_DEV_FMT,
                       app_map->domain, app_map->bus, app_map->dev, app_map->func);

    fail_on_quiet(ret < 0, err, "Error building the dir_name");
    fail_on_quiet((size_t) ret >= sizeof(dir_name), err, "dir_name too long");

    /** Setup the path to the device's remove file */
    char sysfs_name[NAME_MAX + 1];
    ret = snprintf(sysfs_name, sizeof(sysfs_name),
                   "/sys/bus/pci/devices/%s/remove", dir_name);

    fail_on_quiet(ret < 0, err,
                  "Error building the sysfs path for remove file");
    fail_on_quiet((size_t) ret >= sizeof(sysfs_name), err,
                  "sysfs path too long for remove file");

    /** Write a "1" to the device's remove file */
    ret = fpga_pci_write_one2file(sysfs_name);
    fail_on_quiet(ret != 0, err, "cli_write_one2file failed");

    bool done = false;
    uint32_t retries = 0;
    while (!done) {
        /** Check for file existence, should fail */
        struct stat file_stat;
        ret = stat(sysfs_name, &file_stat);
        if (ret != 0) {
            done = true;
        } else {
            fail_on_quiet(retries >= F1_REMOVE_APP_PF_MAX_RETRIES, err,
                          "remove failed for path=%s", sysfs_name);
            retries++;
            msleep(F1_REMOVE_APP_PF_DELAY_MSEC);
        }
    }

    errno = 0;
    return 0;
err:
    errno = 0;
    return FPGA_ERR_FAIL;
}

/**
 * PCI rescan.
 *
 * @returns
 *  0   on success
 * -1   on failure
 */
static int
fpga_pci_rescan(void)
{
    /** Setup and write '1' to the PCI rescan file */
    char sysfs_name[NAME_MAX + 1];
    int ret = snprintf(sysfs_name, sizeof(sysfs_name), "/sys/bus/pci/rescan");

    fail_on_quiet(ret < 0, err,
                  "Error building the sysfs path for PCI rescan file");
    fail_on_quiet((size_t) ret >= sizeof(sysfs_name), err,
                  "sysfs path too long for PCI rescan file");

    /** Write a "1" to the PCI rescan file */
    ret = fpga_pci_write_one2file(sysfs_name);
    fail_on_quiet(ret != 0, err, "fpga_pci_write_one2file failed");

    return 0;
err:
    return FPGA_ERR_FAIL;
}

int
fpga_pci_rescan_slot_app_pfs(int slot_id)
{
    struct fpga_slot_spec spec;
    int ret = fpga_pci_get_slot_spec(slot_id, &spec);
    fail_on_quiet(ret != 0, err, "fpga_pci_get_slot_spec failed");

    ret = fpga_pci_remove_app_pf(&spec.map[FPGA_APP_PF]);
    fail_on_quiet(ret != 0, err, "fpga_pci_remove_app_pf failed");

    ret = fpga_pci_rescan();
    fail_on_quiet(ret != 0, err, "fpga_pci_rescan failed");

    return 0;
err:
    return FPGA_ERR_FAIL;
}
#endif

