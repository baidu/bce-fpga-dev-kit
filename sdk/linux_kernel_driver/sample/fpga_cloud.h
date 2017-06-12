#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <pthread.h>

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

namespace fpga {
namespace cloud {
namespace api {

/**
 * @brief   Read register
 *
 * @param [in]  dev     : dev number
 * @param [in]  addr    : register offset
 * @param [out] value   : output value
 *
 * @return  return 0 on success, error code while failed
 *
 * @note
 *
 * @author  miaotianxiang@baidu.com
 * @date    2016-08-25
 **/
int reg_read(int dev, uint64_t addr, uint64_t *value);

/**
 * @brief   Write register
 *
 * @param [in] dev      : dev number
 * @param [in] addr     : register offset
 * @param [in] value    : input value
 *
 * @return  return 0 on success, error code while failed
 *
 * @note
 *
 * @author  miaotianxiang@baidu.com
 * @date    2016-08-25
 **/
int reg_write(int dev, uint64_t addr, uint64_t value);

int reg_read_32(int dev, uint64_t addr, uint32_t *value);

int reg_write_32(int dev, uint64_t addr, uint32_t value);

int fpga_memcpy(int dev, uint64_t dest, uint64_t src, size_t n, int to_dev);

}
}
}
