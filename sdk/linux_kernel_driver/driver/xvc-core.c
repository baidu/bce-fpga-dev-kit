#include <linux/ioctl.h>
#include <linux/types.h>
#include "xdma-ioctl.h"
#include "xdma-core.h"
#include "xdma-sgm.h"
#include "xbar_sys_parameters.h"
#include "xvc-pcie-driver.h"
#include "xvc-pcie-user-config.h"

#ifdef INCLUDE_CUSTOM_MMCONFIG
#include "xvc-mmconfig.h"
#endif

long setup_xvc_algo(struct xdma_dev *lro)
{
    int status = -EINVAL;
    int bar_index = user_config.bar_index;

    // initialize algo selection if not already selected
    if (!lro->xvc_char.xvc_algo.type) {
        struct xil_xvc_char *xvc_char = &lro->xvc_char;
        struct xvc_algo_t *algo = &xvc_char->xvc_algo;

        // try to find the cfg capability if CONFIG or AUTO was specified by user
        if ((user_config.config_space == CONFIG) || (user_config.config_space == AUTO)) {
            status = xil_xvc_get_offset(xvc_char->pci_dev, &algo->offset.cfg);
            if (status == 0) {
                // found the capability so use CFG space;
                algo->type = XVC_ALGO_CFG;
                return status;
            }
        }
        // try to use BAR space if selected, or fall through for AUTO
        if ((user_config.config_space == BAR) || (user_config.config_space == AUTO)) {
            resource_size_t bar_start;
            resource_size_t bar_len;
            resource_size_t map_len;

            if ((!pci_resource_flags(xvc_char->pci_dev, bar_index)) & IORESOURCE_MEM) {
                printk(KERN_ERR LOG_PREFIX "Incorrect BAR configuration\n");
                return -ENODEV;
            }

            bar_start = pci_resource_start(xvc_char->pci_dev, bar_index);
            bar_len = pci_resource_len(xvc_char->pci_dev, bar_index);
            map_len = bar_len;

            if (!bar_len) {
                printk(KERN_WARNING LOG_PREFIX "BAR #%d is not present.\n", bar_index);
            } else {
                // XXX: add user specified BAR offset to base address of mapping,
                // modify it accordingly
                algo->offset.bar = lro->bar[user_config.bar_index] + user_config.bar_offset;
                /*
                 *algo->offset.bar =
                 *        pci_iomap(xvc_char->pci_dev, bar_index, map_len) + user_config.bar_offset;
                 */

                if (!(algo->offset.bar)) {
                    printk(KERN_ERR LOG_PREFIX "Could not map BAR %d\n", bar_index);
                    return -ENODEV;
                } else {
                    algo->type = XVC_ALGO_BAR;
                    printk(KERN_INFO LOG_PREFIX
                            "BAR%d at 0x%llx mapped at 0x%p, length=%llu(/%llu)\n",
                            bar_index, (u64)bar_start, algo->offset.bar,
                            (u64)map_len, (u64)bar_len);
                    status = 0;
                }
            }
        }
    }

    return status;
}

static long xvc_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg) {
    /*int device_index = iminor(file_p->f_path.dentry->d_inode) - MINOR(xvc_ioc_dev_region);*/
    int device_index = 0;
    int status = 0;
    /*unsigned long pci_config_lock_flags = 0;*/
    struct xdma_char *xvc_char_dev = file_p->private_data;
    struct xdma_dev *lro = xvc_char_dev->lro;
    struct xil_xvc_char *xvc_char = &lro->xvc_char;

    if (lro->pci_dev == NULL) {
        printk(KERN_ERR LOG_PREFIX "Could not find device_index %d\n", device_index);
        return -EFAULT;
    }

    spin_lock(&file_p->f_path.dentry->d_inode->i_lock);
    /*spin_lock_irqsave(&file_p->f_path.dentry->d_inode->i_lock, pci_config_lock_flags);*/

    switch (cmd)
    {
        case XDMA_IOCXVC:
            status = xil_xvc_ioctl(lro->pci_dev, &xvc_char->xvc_algo, (void __user *)arg);
            break;
        default:
            status = -ENOIOCTLCMD;
            break;
    }

    mmiowb();
    spin_unlock(&file_p->f_path.dentry->d_inode->i_lock);
    /*spin_unlock_irqrestore(&file_p->f_path.dentry->d_inode->i_lock, pci_config_lock_flags);*/

    return status;
}

static int xvc_open(struct inode *inode, struct file *file)
{
    struct xdma_char *lro_char;

    /* pointer to containing structure of the character device inode */
    lro_char = container_of(inode->i_cdev, struct xdma_char, cdev);
    BUG_ON(lro_char->magic != MAGIC_CHAR);
    /* create a reference to our char device in the opened file */
    file->private_data = lro_char;

    return 0;
}

struct file_operations xil_xvc_ioc_ops = {
    .owner = THIS_MODULE,
    .open = xvc_open,
    .unlocked_ioctl = xvc_ioctl,
};
