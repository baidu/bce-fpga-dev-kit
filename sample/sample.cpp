#include "fpga_cloud.h"
#include <assert.h>

using namespace fpga::cloud::api;

const float float_a_array[8] = {
    1.0f, 2.0f, 3.0f, 4.0f, 1.0f, 2.0f, 3.0f, 4.0f,
};
uint64_t float_a_addr = 4096;

const float float_b_array[8] = {
    1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
};
uint64_t float_b_addr = 4096 * 2;

float float_c_array[8];
uint64_t float_c_addr = 4096 * 3;

int main(int argc, char **argv) {
    int ret = 0;

    /* DMA float_a_array and float_b_array to FPGA */
    ret = fpga_memcpy(0, 4096,
            reinterpret_cast<uint64_t>(&float_a_array),
            sizeof(float_a_array), 1);
    assert(ret == 0);
    ret = fpga_memcpy(0, 4096 * 2,
            reinterpret_cast<uint64_t>(&float_b_array),
            sizeof(float_b_array), 1);
    assert(ret == 0);

    /* wr reg float_a_addr */
    ret = reg_write_32(0, 64 * 1024 + 4, float_a_addr / 32);
    assert(ret == 0);
    /* wr reg float_b_addr */
    ret = reg_write_32(0, 64 * 1024 + 8, float_b_addr / 32);
    assert(ret == 0);
    /* wr reg float_c_addr */
    ret = reg_write_32(0, 64 * 1024 + 12, float_c_addr / 32);
    assert(ret == 0);
    /* wr reg float_array_len */
    ret = reg_write_32(0, 64 * 1024 + 16, 1);
    assert(ret == 0);
    /* wr reg start_pe */
    ret = reg_write_32(0, 64 * 1024, 1);
    assert(ret == 0);

    /* rd reg polling_pe_status */
    uint32_t status;
    do {
        ret = reg_read_32(0, 64 * 1024 + 36, &status);
        assert(ret == 0);
    } while (status == 0);

    /* DMA float_c_array from FPGA */
    ret = fpga_memcpy(0,
            reinterpret_cast<uint64_t>(&float_c_array), 4096 * 3,
            sizeof(float_c_array), 0);
    assert(ret == 0);

    /* print output */
    printf("float_a_array : ");
    for (int i = 0; i < 8; ++i) {
        printf("\t%.2f", float_a_array[i]);
    }
    printf("\n");
    printf("float_b_array : ");
    for (int i = 0; i < 8; ++i) {
        printf("\t%.2f", float_b_array[i]);
    }
    printf("\n");
    printf("float_c_array : ");
    for (int i = 0; i < 8; ++i) {
        printf("\t%.2f", float_c_array[i]);
    }
    printf("\n");

    return 0;
}
