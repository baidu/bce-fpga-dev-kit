/*
 * Xilinx XVC PCIe Driver
 * Copyright (C) 2017 Xilinx Corporation
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifndef _XVC_PCIE_DRIVER_H
#define _XVC_PCIE_DRIVER_H


#include "xvc_pcie_ioctl.h"

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
	struct pci_dev *pci_dev;
	struct xvc_algo_t xvc_algo;
};

ssize_t xil_xvc_ioctl(struct pci_dev *pci_dev, struct xvc_algo_t *algo, const char __user *arg);
int xil_xvc_get_offset(struct pci_dev *pci_dev, size_t *offset);

#endif /* _XVC_PCIE_DRIVER_H */
