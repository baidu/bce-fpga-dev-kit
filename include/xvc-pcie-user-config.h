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

#define PCIE_VENDOR_ID	0x10EE
#define PCIE_DEVICE_ID	0x9038

static const struct pcie_user_config user_config = {
	.config_space 	= AUTO,
	.bar_index      = 0x0,
	.bar_offset 	= 0x0,
};

#endif /* _XVC_PCIE_USER_CONFIG_H */
