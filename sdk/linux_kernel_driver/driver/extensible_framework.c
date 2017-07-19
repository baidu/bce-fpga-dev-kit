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

#include <linux/module.h>
#include <linux/cdev.h>
#include <linux/delay.h>
#include <linux/uaccess.h>
#include <linux/fs.h>
#include <linux/io.h>
#include <linux/kernel.h>
#include <linux/firmware.h>
#include <linux/pci.h>
#include <linux/vmalloc.h>

#include "xdma-core.h"
#include "xdma-ioctl.h"
#include "xbar_sys_parameters.h"

/**************************************************************************************/
/*                               Define init/exit function here                       */
/**************************************************************************************/
void ext_init(struct xdma_dev *lro)
{
    dbg_ext("lro=%p, lro->instance=%d\n", lro, lro->instance);
    /* alloc resources that may be used in IRQ handler or user-defined IOCTL */
    return;
}

void ext_exit(struct xdma_dev *lro)
{
    dbg_ext("lro=%p, lro->instance=%d\n", lro, lro->instance);
    /* free resources alloc-ed in `ext_init()` */
    return;
}

/**************************************************************************************/
/*                               Define User IRQ handler here                         */
/**************************************************************************************/
static void user_irq_0_handler(struct xdma_irq *user_irq)
{
    struct xdma_dev *lro = user_irq->lro;
    dbg_ext("lro=%p, lro->instance=%d\n", lro, lro->instance);
    return;
}

const user_irq_handler ext_user_irq_handler_tbl[MAX_USER_IRQ] = {
    [0] = &user_irq_0_handler,
};

/**************************************************************************************/
/*                               Define IOCTL cmd here                                */
/*                                    Pls. refer to                                   */
/* https://github.com/torvalds/linux/blob/master/Documentation/ioctl/ioctl-number.txt */
/**************************************************************************************/
#define IOCTL_AXI_SLAVE_DMA                 _IOWR(XDMA_IOC_MAGIC, 1, int)

/**************************************************************************************/
/*                               Define IOCTL impl. here                              */
/**************************************************************************************/
static long do_axi_slave_dma(struct xdma_dev *lro)
{
    int rc = 0;
    unsigned long vaddr = 0;
    dma_addr_t paddr = 0;
    /* XXX: refer to https://github.com/Cwndmiao/bce-fpga-dev-kit/tree/master/sdk/doc#bar_layout */
    void *reg = lro->bar[lro->user_bar_idx] + (64 << 10);
    struct xdma_irq *user_irq = &lro->user_irq[0];
    unsigned long flags;
    static DEFINE_MUTEX(axi_slave_dma_mutex);

    mutex_lock(&axi_slave_dma_mutex);
    vaddr = __get_free_pages(GFP_KERNEL, 1);
    if (!vaddr) {
        goto free;
    }
    paddr = dma_map_single(&lro->pci_dev->dev, (void *)vaddr, PAGE_SIZE << 1, DMA_BIDIRECTIONAL);
    if (!paddr) {
        goto free;
    }

    /* axi slave dma write */
    dbg_ext("before write_register\n");
    write_register((u32)paddr, reg + 0x4);
    write_register((u32)(paddr >> 32), reg + 0x8);
    write_register(0, reg + 0xC);
    write_register(0, reg + 0x10);
    write_register(PAGE_SIZE, reg + 0x14);
    write_register(1, reg + 0x18);
    write_register(1, reg + 0x0);
    dbg_ext("after write_register\n");

    /* wait for interrupt */
    dbg_ext("before wait_event_interruptible\n");
    rc = wait_event_interruptible(user_irq->events_wq, user_irq->events_irq != 0);
    if (rc == -ERESTARTSYS) {
        goto free;
    }
    spin_lock_irqsave(&user_irq->events_lock, flags);
    user_irq->events_irq = 0;
    spin_unlock_irqrestore(&user_irq->events_lock, flags);
    dbg_ext("after wait_event_interruptible\n");

    /* axi slave dma read */
    dbg_ext("before write_register\n");
    write_register(0, reg + 0x4);
    write_register(0, reg + 0x8);
    write_register((u32)(paddr + PAGE_SIZE), reg + 0xC);
    write_register((u32)((paddr + PAGE_SIZE) >> 32), reg + 0x10);
    write_register(PAGE_SIZE, reg + 0x14);
    write_register(0, reg + 0x18);
    write_register(1, reg + 0x0);
    dbg_ext("after write_register\n");

    /* wait for interrupt */
    dbg_ext("before wait_event_interruptible\n");
    rc = wait_event_interruptible(user_irq->events_wq, user_irq->events_irq != 0);
    if (rc == -ERESTARTSYS) {
        goto free;
    }
    spin_lock_irqsave(&user_irq->events_lock, flags);
    user_irq->events_irq = 0;
    spin_unlock_irqrestore(&user_irq->events_lock, flags);
    dbg_ext("after wait_event_interruptible\n");

    if (memcmp((void *)vaddr, (void *)(vaddr + PAGE_SIZE), PAGE_SIZE)) {
        dbg_ext("data diff in dma read/write\n");
        rc = -EINVAL;
    }

free:
    if (paddr) {
        dma_unmap_single(&lro->pci_dev->dev, paddr, PAGE_SIZE << 1, DMA_BIDIRECTIONAL);
    }
    if (vaddr) {
        free_pages(vaddr, 1);
    }
    mutex_unlock(&axi_slave_dma_mutex);
    return rc;
}

long ext_user_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    struct xdma_dev *lro;
    struct xdma_char *lro_char = (struct xdma_char *)filp->private_data;
    long result = 0;

    BUG_ON(!lro_char);
    BUG_ON(lro_char->magic != MAGIC_CHAR);
    lro = lro_char->lro;
    BUG_ON(!lro);
    BUG_ON(lro->magic != MAGIC_DEVICE);

    if (lro_char != lro->user_char_dev) {
        return -ENOTTY;
    }

    if (_IOC_TYPE(cmd) != XDMA_IOC_MAGIC) {
        return -ENOTTY;
    }

    if (_IOC_DIR(cmd) & _IOC_READ) {
        result = !access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
    } else if (_IOC_DIR(cmd) & _IOC_WRITE) {
        result = !access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
    }
    if (result) {
        return -EFAULT;
    }

    /**************************************************************************************/
    /*                               Dispatch via IOCTL cmd here                          */
    /**************************************************************************************/
    switch (cmd) {
    case IOCTL_AXI_SLAVE_DMA:
        result = do_axi_slave_dma(lro);
        break;
    default:
        break;
    }

    return result;
}

