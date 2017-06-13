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

#include <linux/pci.h>
/*#include <linux/init.h>*/
#include <linux/acpi.h>
#include <linux/bitmap.h>
#include <asm/e820.h>
#include <asm/pci_x86.h>

#include "xvc-mmconfig.h"

/* Static virtual mapping of the MMCONFIG aperture */
struct mmcfg_virt {
    struct acpi_mcfg_allocation *cfg;
    char __iomem *virt;
};

static struct mmcfg_virt *pci_mmcfg_virt;

static char __iomem *get_virt(unsigned int seg, unsigned bus)
{
    struct acpi_mcfg_allocation *cfg;
    int cfg_num;

    for (cfg_num = 0; cfg_num < pci_mmcfg_config_num; cfg_num++) {
        cfg = pci_mmcfg_virt[cfg_num].cfg;
        if ((cfg->pci_segment == seg) &&
                (cfg->start_bus_number <= bus) &&
                (cfg->end_bus_number >= bus))
            return pci_mmcfg_virt[cfg_num].virt;
    }

    /* Fall back to type 0 */
    return NULL;
}

static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus, unsigned int devfn)
{
    char __iomem *addr;

    addr = get_virt(seg, bus);
    if (!addr)
        return NULL;
    return addr + ((bus << 20) | (devfn << 12));
}

int pci_mmcfg_read(unsigned int seg, unsigned int bus,
        unsigned int devfn, int reg, int len, u32 *value)
{
    char __iomem *addr;

    /* Why do we have this when nobody checks it. How about a BUG()!? -AK */
    if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
err:
        *value = -1;
        return -EINVAL;
    }

    addr = pci_dev_base(seg, bus, devfn);
    if (!addr)
        goto err;

    switch (len) {
        case 1:
            *value = mmio_config_readb(addr + reg);
            break;
        case 2:
            *value = mmio_config_readw(addr + reg);
            break;
        case 4:
            *value = mmio_config_readl(addr + reg);
            break;
    }

    return 0;
}

int pci_mmcfg_write(unsigned int seg, unsigned int bus,
        unsigned int devfn, int reg, int len, u32 value)
{
    char __iomem *addr;

    /* Why do we have this when nobody checks it. How about a BUG()!? -AK */
    if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
        return -EINVAL;

    addr = pci_dev_base(seg, bus, devfn);
    if (!addr)
        return -EINVAL;

    switch (len) {
        case 1:
            mmio_config_writeb(addr + reg, value);
            break;
        case 2:
            mmio_config_writew(addr + reg, value);
            break;
        case 4:
            mmio_config_writel(addr + reg, value);
            break;
    }

    return 0;
}

static void __iomem * mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
{
    void __iomem *addr;
    u64 start, size;

    start = cfg->start_bus_number;
    start <<= 20;
    start += cfg->address;
    size = cfg->end_bus_number + 1 - cfg->start_bus_number;
    size <<= 20;
    addr = ioremap_nocache(start, size);
    if (addr) {
        addr -= cfg->start_bus_number << 20;
    }
    return addr;
}

static void arch_cleanup(void)
{
    int i;

    if (pci_mmcfg_virt == NULL)
        return;

    for (i = 0; i < pci_mmcfg_config_num; ++i) {
        if (pci_mmcfg_virt[i].virt) {
            iounmap(pci_mmcfg_virt[i].virt + (pci_mmcfg_virt[i].cfg->start_bus_number << 20));
            pci_mmcfg_virt[i].virt = NULL;
            pci_mmcfg_virt[i].cfg = NULL;
        }
    }

    kfree(pci_mmcfg_virt);
    pci_mmcfg_virt = NULL;
}

int __section(.text) pci_mmcfg_arch_init(void)
{
    int i;
    pci_mmcfg_virt = kzalloc(sizeof(*pci_mmcfg_virt) * pci_mmcfg_config_num, GFP_KERNEL);
    if (pci_mmcfg_virt == NULL) {
        printk(KERN_ERR LOG_PREFIX "Cannot allocate memory for mmconfig structures\n");
        return 0;
    }

    for (i = 0; i < pci_mmcfg_config_num; ++i) {
        pci_mmcfg_virt[i].cfg = &pci_mmcfg_config[i];
        pci_mmcfg_virt[i].virt = mcfg_ioremap(&pci_mmcfg_config[i]);
        if (!pci_mmcfg_virt[i].virt) {
            printk(KERN_ERR LOG_PREFIX "Cannot map mmconfig aperture for segment %d\n",
                    pci_mmcfg_config[i].pci_segment);
            arch_cleanup();
            return 0;
        }
    }
    return 1;
}

void __section(.text) pci_mmcfg_arch_free(void)
{
    arch_cleanup();
}

