#ifndef _XIL_XVC_IOCALLS_POSIX_H_
#define _XIL_XVC_IOCALLS_POSIX_H_

#ifndef _WINDOWS
// TODO: Windows build support
# include <linux/ioctl.h>
#endif

#define XIL_XVC_MAGIC 0x58564344 // "XVCD"

struct xil_xvc_ioc {
    unsigned opcode;
    unsigned length;
    unsigned char *tms_buf;
    unsigned char *tdi_buf;
    unsigned char *tdo_buf;
};

#define XDMA_IOCXVC	_IOWR(XIL_XVC_MAGIC, 1, struct xil_xvc_ioc)

#endif // _XIL_XVC_IOCALLS_POSIX_H_

