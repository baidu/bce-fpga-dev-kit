/*********************************************************************
 * Copyright (c) 2016 Xilinx, Inc.  All rights reserved.
 *
 *                 XILINX CONFIDENTIAL PROPERTY
 * This   document  contains  proprietary information  which   is
 * protected by  copyright. All rights  are reserved. No  part of
 * this  document may be photocopied, reproduced or translated to
 * another  program  language  without  prior written  consent of
 * XILINX Inc., San Jose, CA. 95124
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 **********************************************************************/

/*
 * PCIe xvcserver
 *
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <assert.h>
#include "xvcserver.h"
#include "xvc_pcie_ioctl.h"
#include <unistd.h>


#ifndef _WINDOWS
// TODO: Windows build support
//    sys/ioctl.h is linux only header file
//    it is included for ioctl
# include <sys/ioctl.h>
# include <errno.h>
#endif

typedef struct {
    int fd; // open file descriptor
} pcie_reg_t;

int verbose = 0;

static int open_port(void *client_data, XvcClient *c)
{
    pcie_reg_t *pcie = (pcie_reg_t *)client_data;
    char dev_node[32] = "/dev/xil_xvc/cfg_ioc0";
    const char *env = getenv("DEVICE_NODE");

    env = getenv("VERBOSE");
    if (env) {
        verbose = 1;
    } else {
        printf ("Enable verbose by setting VERBOSE env var.\n");
    }

    printf("Opening %s.\n", dev_node);
    pcie->fd = open(dev_node, O_RDWR | O_SYNC);
    if (pcie->fd < 1) {
        fprintf(stderr, "Failed to Open Device\n");
        return (-1);
    }

    return (0);
}

static void close_port(void *client_data)
{
    pcie_reg_t *pcie = (pcie_reg_t *)client_data;
    if (pcie->fd >= 1) {
        close(pcie->fd);
    }
}

static void set_tck(void *client_data, unsigned long nsperiod, unsigned long *result)
{
    *result = nsperiod;
}

static void shift_tms_tdi(
        void *client_data,
        unsigned long bitcount,
        unsigned char *tms_buf,
        unsigned char *tdi_buf,
        unsigned char *tdo_buf)
{
    pcie_reg_t *pcie = (pcie_reg_t *)client_data;
    struct timeval stop, start;

    if (verbose) {
        gettimeofday(&start, NULL);
    }

    struct xil_xvc_ioc xvc_ioc;

    xvc_ioc.opcode = 0x01; // 0x01 for normal, 0x02 for bypass
    xvc_ioc.length = bitcount;
    xvc_ioc.tms_buf = tms_buf;
    xvc_ioc.tdi_buf = tdi_buf;
    xvc_ioc.tdo_buf = tdo_buf;

    int ret = ioctl(pcie->fd, XDMA_IOCXVC, &xvc_ioc);
    if (ret < 0) {
        int errsv = errno;
        printf("IOC Error %d\n", errsv);
    }

    if (verbose) {
        gettimeofday(&stop, NULL);
        printf("IOC shift internal took %lu u-seconds with %lu bits. Return value %d\n",
               stop.tv_usec - start.tv_usec, bitcount, ret);
    }
}

XvcServerHandlers handlers = {
    open_port,
    close_port,
    set_tck,
    shift_tms_tdi,
    NULL,
    NULL,
    NULL,
    NULL
};

int main(int argc, char **argv)
{
    const char *url = "tcp::10200";
    char dev_node [64];
    pcie_reg_t pcie_reg;
    int i = 1;

    while (i < argc && argv[i][0] == '-') {
        if (strcmp(argv[i], "-s") == 0) {
            if (i + 1 >= argc) {
                fprintf(stderr, "option -s requires an argument\n");
                return 1;
            }
            url = argv[++i];
        } else if (strcmp(argv[i], "-d") == 0) {
            if (i + 1 >= argc) {
                fprintf(stderr, "option -d requires an argument\n");
                return 1;
            }
            strcpy (dev_node, argv[++i]);
        } else {
            fprintf(stderr, "unknown option: %s\n", argv[i]);
            return 1;
        }
        i++;
    }

    return xvcserver_start(url, &pcie_reg, &handlers);
}

