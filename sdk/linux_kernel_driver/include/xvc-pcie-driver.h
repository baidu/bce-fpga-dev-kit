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

#ifndef _XVC_PCIE_DRIVER_H
#define _XVC_PCIE_DRIVER_H

#include "xvc-pcie-ioctl.h"

enum xvc_algo_type {
    XVC_ALGO_NULL,
    XVC_ALGO_CFG,
    XVC_ALGO_BAR
};

struct xvc_algo_t {
    enum xvc_algo_type type;
    union offset_t {
        void* __iomem bar;
        size_t cfg;
    } offset;
};

struct xil_xvc_char {
    struct xvc_algo_t xvc_algo;
};

ssize_t xil_xvc_ioctl(struct pci_dev *pci_dev, struct xvc_algo_t *algo, const char __user *arg);
int xil_xvc_get_offset(struct pci_dev *pci_dev, size_t *offset);

#endif /* _XVC_PCIE_DRIVER_H */

