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
    if (argc != 3) {
        printf("Usage: %s <dev id> <register offset in decimal>\n", argv[0]);
        exit(1);
    }

    char *end = NULL;
    const char *dev_id_str = argv[1];
    const char *reg_addr_str = argv[2];

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

    uint32_t value = 0;
    int ret = api::reg_read_32(dev_id, addr, &value);
    if (ret != 0) {
        fprintf(stderr, "fail to call api::reg_read_32, ret %d\n", ret);
        exit(4);
    }
    printf("read success, addr = %016" PRIx64 ", value = %08" PRIx32 "\n", addr, value);

    return 0;
}
