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

#ifndef _XVC_PCIE_USER_CONFIG_H
#define _XVC_PCIE_USER_CONFIG_H

enum pcie_config_space {
    AUTO,
    CONFIG,
    BAR
};

struct pcie_user_config {
    enum pcie_config_space config_space;
    unsigned int bar_index;
    unsigned int bar_offset;
};

/*
 *  Modify the macros and structure below with PCIe customizations for the driver, if desired.
 *    device_vendor - hex value for PCIe device vendor
 *    device_id     - hex value for PCIe device ID
 *    config_space  - AUTO (to let the driver search first for CONFIG followed by BAR space)
 *                  - CONFIG (to explicitly use PCIe configuration space)
 *                  - BAR (to explicitly use PCIe BAR space)
 *    bar_index     - PCIe BAR index specifies which PCIe BAR should be used to access the
 *                    XVC pcie peripheral for the AXI-XVC peripheral.
 *    bar_offset    - PCIe BAR space offset specifies the offset within the PCIe BAR that
 *                    should be used to access the AXI-XVC peripheral.
 */

#define PCIE_VENDOR_ID 0x10EE
#define PCIE_DEVICE_ID 0x9038

static const struct pcie_user_config user_config = {
    .config_space = AUTO,
    .bar_index    = 0x0,
    .bar_offset   = 0x20000, /* 128K */
};

#endif /* _XVC_PCIE_USER_CONFIG_H */

