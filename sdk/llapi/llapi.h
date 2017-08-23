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

#ifndef LLAPI_H
#define LLAPI_H

#include <stddef.h>
#include <pciaccess.h>

namespace baidu {
namespace fpga {
namespace llapi {

struct bce_fpga_device {
    bool present;
    struct pci_device pci_device;
};

#define NR_MAX_SLOTS (8)

extern struct bce_fpga_device g_bce_fpga_devices[NR_MAX_SLOTS];

/**
 * @brief   Read register in 32-bit
 *
 * @param [in]  slot    : slot number
 * @param [in]  addr    : register offset
 * @param [out] value   : output value
 *
 * @return  return 0 on success, or error code while failed
 *
 * @note
 *
 * @author  miaotianxiang@baidu.com
 * @date    2017-08-25
 **/
int reg_read_32(int slot, uint64_t addr, uint32_t *value);

/**
 * @brief   Write register in 32-bit
 *
 * @param [in] slot     : slot number
 * @param [in] addr     : register offset
 * @param [in] value    : input value
 *
 * @return  return 0 on success, or error code while failed
 *
 * @note
 *
 * @author  miaotianxiang@baidu.com
 * @date    2017-08-25
 **/
int reg_write_32(int slot, uint64_t addr, uint32_t value);

/**
 * @brief   DMA between host main memory and FPGA DDR
 *
 * @param [in] slot     : slot number
 * @param [in] dest     : DMA dest addr
 * @param [in] src      : DMA src addr
 * @param [in] n        : DMA length
 * @param [in] to_fpga  : DMA direction, [1] for host->fpga and [0] for fpga->host
 *
 * @return  return 0 on success, or error code while failed
 *
 * @note
 *
 * @author  miaotianxiang@baidu.com
 * @date    2017-08-25
 **/
int fpga_memcpy(int slot, uint64_t dest, uint64_t src, size_t n, int to_fpga);

} // namespace llapi
} // namespace fpga
} // namespace baidu

#endif

