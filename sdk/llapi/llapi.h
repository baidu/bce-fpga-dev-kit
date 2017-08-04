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

int reg_read_32(int slot, uint64_t addr, uint32_t *value);
int reg_write_32(int slot, uint64_t addr, uint32_t value);

} // namespace llapi
} // namespace fpga
} // namespace baidu

#endif

