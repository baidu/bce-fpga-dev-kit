#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define XDMA_IOC_MAGIC  'x'
#define IOCTL_AXI_SLAVE_DMA     _IOWR(XDMA_IOC_MAGIC, 1, int)

int main(int argc, char **argv) {
    int fd = open("/dev/xdma0_user", O_RDWR);
    if (fd < 0) {
        perror("open failed");
        return 1;
    }

    int a = 0;
    int rc = ioctl(fd, IOCTL_AXI_SLAVE_DMA, &a);
    if (rc == -1) {
        perror("ioctl failed");
        return 1;
    }

    return 0;
}

