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

#ifndef _MMCONFIG_CUSTOM_H
#define _MMCONFIG_CUSTOM_H

#include <linux/kernel.h>
#include <linux/acpi.h>
#include <acpi/acpi.h>

int pci_mmcfg_driver_init(void);
void pci_mmcfg_driver_exit(void);

int pci_mmcfg_arch_init(void);
void pci_mmcfg_arch_free(void);

extern struct acpi_mcfg_allocation *pci_mmcfg_config;
extern int pci_mmcfg_config_num;

int pci_mmcfg_read(unsigned int seg, unsigned int bus,
        unsigned int devfn, int reg, int len, u32 *value);
int pci_mmcfg_write(unsigned int seg, unsigned int bus,
        unsigned int devfn, int reg, int len, u32 value);

#endif /* _MMCONFIG_CUSTOM_H */
