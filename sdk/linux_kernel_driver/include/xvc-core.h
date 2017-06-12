#include <linux/ioctl.h>
#include <linux/types.h>
#include "xvc-pcie-driver.h"
#include "xvc-pcie-user-config.h"

#ifdef INCLUDE_CUSTOM_MMCONFIG
#include "xvc-mmconfig.h"
#endif

long setup_xvc_algo(struct xdma_dev *lro);

extern struct file_operations xil_xvc_ioc_ops;
