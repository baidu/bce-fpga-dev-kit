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

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define __STDC_FORMAT_MACROS 1
#include <inttypes.h>

#include "fpga_cloud.h"

namespace api = fpga::cloud::api;

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <dev id> <register offset in decimal> <value in hex, e.g. 0x1a or 1a>\n",
                argv[0]);
        exit(1);
    }

    char *end = NULL;
    const char *dev_id_str = argv[1];
    const char *reg_addr_str = argv[2];
    const char *reg_value_str = argv[3];

    int dev_id = (int)strtoul(dev_id_str, &end, 10);
    if (*end != '\0') {
        fprintf(stderr, "fail to parse dev id: %s\n", dev_id_str);
        exit(2);
    }

    uint64_t addr = (uint64_t)strtoull(reg_addr_str, &end, 10);
    if (*end != '\0') {
        fprintf(stderr, "fail to parse register address: %s\n", reg_addr_str);
        exit(3);
    }

    uint32_t value = (uint32_t)strtoull(reg_value_str, &end, 16);
    if (*end != '\0') {
        fprintf(stderr, "fail to parse register value: %s\n", reg_value_str);
        exit(4);
    }

    int ret = api::reg_write_32(dev_id, addr, value);
    if (ret != 0) {
        fprintf(stderr, "fail to call api::reg_write_32, ret %d\n", ret);
        exit(5);
    }
    printf("write success, addr = %016" PRIx64 ", value = %08" PRIx32 "\n", addr, value);

    return 0;
}

