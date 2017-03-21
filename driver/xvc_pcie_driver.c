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

#include <linux/pci.h>
#include <linux/mod_devicetable.h>

#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/slab.h>

#include <asm/uaccess.h>

#include <linux/spinlock.h>
#include <linux/platform_device.h>
#include <linux/list.h>

#ifdef INCLUDE_CUSTOM_MMCONFIG
#include "mmconfig.h"
#endif

#include "xvc_pcie_driver.h"

static const size_t XVC_VSEC_ID = 0x0008;

#define VALID_OFFSET(a) (a < 0x1000 && a >= 0x100)

struct xvc_offsets {
	size_t debug_id_reg_offset;
	size_t length_reg_offset;
	size_t tms_reg_offset;
	size_t tdi_reg_offset;
	size_t tdo_reg_offset;
	size_t control_reg_offset;
};

static const struct xvc_offsets xvc_offsets[] = {
	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00}, // XVC_ALGO_NULL
	{0x08, 0x0C, 0x10, 0x14, 0x14, 0x18}, // XVC_ALGO_CFG
	{0x00, 0x00, 0x04, 0x08, 0x0C, 0x10}  // XVC_ALGO_BAR
};

#define DEBUG_ID_REG_OFFSET (xvc_offsets[algo->type].debug_id_reg_offset)
#define LENGTH_REG_OFFSET   (xvc_offsets[algo->type].length_reg_offset)
#define TMS_REG_OFFSET      (xvc_offsets[algo->type].tms_reg_offset)
#define TDI_REG_OFFSET      (xvc_offsets[algo->type].tdi_reg_offset)
#define TDO_REG_OFFSET      (xvc_offsets[algo->type].tdo_reg_offset)
#define CONTROL_REG_OFFSET  (xvc_offsets[algo->type].control_reg_offset)

int pci_read32(struct pci_dev *dev, struct xvc_algo_t *algo, int offset, u32 *value) {

	switch(algo->type)
	{
	case XVC_ALGO_BAR:
		*value = ioread32(algo->offset.bar + offset);
		return 0;
	case XVC_ALGO_CFG:
#ifndef INCLUDE_CUSTOM_MMCONFIG
		// Use this function for use with 32-bit systems	
		return pci_read_config_dword(dev, algo->offset.cfg + offset, value);
#else
		// Use this function for use with 64-bit systems
		return pci_mmcfg_read(pci_domain_nr(dev->bus), dev->bus->number, dev->devfn, algo->offset.cfg + offset, 4, value);
#endif
	default:;
	}

	return -1;
}

int pci_write32(struct pci_dev *dev, struct xvc_algo_t *algo, int offset, u32 value) {

	switch(algo->type)
	{
	case XVC_ALGO_BAR:
		iowrite32(value, algo->offset.bar + offset);
		return (0);
	case XVC_ALGO_CFG:		
#ifndef INCLUDE_CUSTOM_MMCONFIG
		// Use this function for use with 32-bit systems
		return pci_write_config_dword(dev, algo->offset.cfg + offset, value);
#else	
		// Use this function for use with 64-bit systems
		return pci_mmcfg_write(pci_domain_nr(dev->bus), dev->bus->number, dev->devfn, algo->offset.cfg + offset, 4, value);
#endif
	default:;
	}

	return -1;
}

static int xil_xvc_shift_bits(struct pci_dev *pci_dev, struct xvc_algo_t *algo, u32 tms_bits, u32 tdi_bits, u32 *tdo_bits) {
	int status;
	u32 control_reg_data;
	int count = 100;

	// Set tms bits
	status = pci_write32(pci_dev, algo, TMS_REG_OFFSET, tms_bits);
	if (status != 0) {
		return status;
	}

	// Set tdi bits and shift data out
	status = pci_write32(pci_dev, algo, TDI_REG_OFFSET, tdi_bits);
	if (status != 0) {
		return status;
	}

	// poll status to wait for completion
	if (algo->type == XVC_ALGO_BAR)	{
		// Enable shift operation
		status = pci_write32(pci_dev, algo, CONTROL_REG_OFFSET, 0x01);
		if (status != 0) {
			return status;
		}

		while (count) {
			// Read control reg to check shift operation completion
			status = pci_read32(pci_dev, algo, CONTROL_REG_OFFSET, &control_reg_data);
			if (status != 0) {
				return status;
			}
			if ((control_reg_data & 0x01) == 0)	{
				break;
			}
			count--;
		}
		if (count == 0)	{
			printk(KERN_ERR LOG_PREFIX "XVC bar transaction timed out (%0X)\n", control_reg_data);
			return -ETIMEDOUT;
		}
	}

	// Read tdo bits back out
	status = pci_read32(pci_dev, algo, TDO_REG_OFFSET, tdo_bits);

	return status;
}

ssize_t xil_xvc_ioctl(struct pci_dev *pci_dev, struct xvc_algo_t *algo, const char __user *arg) {
	struct xil_xvc_ioc xvc_obj;
	u32 operation_code;
	u32 num_bits;
	int num_bytes;
	char *tms_buf_temp = NULL;
	char *tdi_buf_temp = NULL;
	char *tdo_buf_temp = NULL;
	int current_bit;
	u32 bypass_status;
	int status = 0;

	if (pci_dev == NULL || algo == NULL || algo->type == XVC_ALGO_NULL) {
        printk(KERN_ERR  "bingo cwndmiao1, pci_dev %p, algo %p, algo->type %d\n",
                pci_dev, algo, algo->type);
		return -EINVAL;
	}

	if ((status = copy_from_user((void *)&xvc_obj, arg, sizeof(struct xil_xvc_ioc)))) {
		goto cleanup;
	}

	operation_code = xvc_obj.opcode;

	// Invalid operation type, no operation performed
	if (operation_code != 0x01 && operation_code != 0x02) {
		return 0;
	}

	num_bits = xvc_obj.length;
	num_bytes = (num_bits + 7) / 8;

	// Allocate and copy data into temporary buffers
	tms_buf_temp = (char*) kmalloc(num_bytes, GFP_KERNEL);
	if (tms_buf_temp == NULL) {
		status = -ENOMEM;
		goto cleanup;
	}
	if ((status = copy_from_user((void *)tms_buf_temp, xvc_obj.tms_buf, num_bytes))) {
		goto cleanup;
	}

	tdi_buf_temp = (char*) kmalloc(num_bytes, GFP_KERNEL);
	if (tdi_buf_temp == NULL) {
		status = -ENOMEM;
		goto cleanup;
	}
	if ((status = copy_from_user((void *)tdi_buf_temp, xvc_obj.tdi_buf, num_bytes))) {
		goto cleanup;
	}

	// Allocate TDO buffer
	tdo_buf_temp = (char*) kmalloc(num_bytes, GFP_KERNEL);
	if (tdo_buf_temp == NULL) {
		status = -ENOMEM;
		goto cleanup;
	}


	if (operation_code == 0x2) {
		bypass_status = 0x2;
	} else {
		bypass_status = 0x0;
	}

	if (algo->type == XVC_ALGO_CFG) {
		status = pci_write32(pci_dev, algo, CONTROL_REG_OFFSET, bypass_status);
		if (status) {
			goto cleanup;
		}
	}

	// Set length register to 32 initially if more than one word-transaction is to be done
	if (num_bits >= 32) {
		status = pci_write32(pci_dev, algo, LENGTH_REG_OFFSET, 0x20);
		if (status) {
			goto cleanup;
		}
	}

	current_bit = 0;
	while (current_bit < num_bits) {
		int shift_num_bytes;
		int shift_num_bits = 32;

		u32 tms_store = 0;
		u32 tdi_store = 0;
		u32 tdo_store = 0;

		if (num_bits - current_bit < shift_num_bits) {
			shift_num_bits = num_bits - current_bit;
			// do LENGTH_REG_OFFSET here
			// Set number of bits to shift out
			status = pci_write32(pci_dev, algo, LENGTH_REG_OFFSET, shift_num_bits);
			if (status != 0) {
				goto cleanup;
			}
		}

		// Copy only the remaining number of bytes out of user-space
		shift_num_bytes = (shift_num_bits + 7) / 8;
		
		memcpy(&tms_store, tms_buf_temp + (current_bit / 8), shift_num_bytes);
		memcpy(&tdi_store, tdi_buf_temp + (current_bit / 8), shift_num_bytes);

		// Shift data out and copy to output buffer
		status = xil_xvc_shift_bits(pci_dev, algo, tms_store, tdi_store, &tdo_store);
		if (status) {
			goto cleanup;
		}

		memcpy(tdo_buf_temp + (current_bit / 8), &tdo_store, shift_num_bytes);

		current_bit += shift_num_bits;
	}

	// if testing bar access swap tdi and tdo bufferes to "loopback"
	if (bypass_status && algo->type == XVC_ALGO_BAR) {
		char *buf_temp = tdo_buf_temp;
		tdo_buf_temp = tdi_buf_temp;
		tdi_buf_temp = buf_temp;
	}

	if (copy_to_user((void *)xvc_obj.tdo_buf, tdo_buf_temp, num_bytes)) {
		status = -EFAULT;
		goto cleanup;
	}

cleanup:
	if (tms_buf_temp) kfree(tms_buf_temp);
	if (tdi_buf_temp) kfree(tdi_buf_temp);
	if (tdo_buf_temp) kfree(tdo_buf_temp);
	return status;
}

int xil_xvc_get_offset(struct pci_dev *pci_dev, size_t *offset) {
	int status;
	size_t i = 0x100; // starting offset for extended capability regisers
	struct xvc_algo_t algo = {
		.type = XVC_ALGO_CFG, 
		.offset.cfg = 0
	};

	while (VALID_OFFSET(i))
	{
		unsigned word = 0x0;
		unsigned id;

		// read vendor-specific header
		status = pci_read32(pci_dev, &algo, i + 4, &word);
		if (status != 0) {
			return status;
		}

		id = word & 0xFF;

		if (id == XVC_VSEC_ID)
		{
			break;
		}

		// read next offset
		status = pci_read32(pci_dev, &algo, i, &word);
		if (status != 0) {
			return status;
		}

		i = word >> 20;
	}

	if (VALID_OFFSET(i))
	{
		// found capability
		if (offset) *offset = i;
	}
	else
	{
		status = -ENXIO;
	}

	return status;
}
