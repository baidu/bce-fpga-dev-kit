# d52cbaca0ef8cf4fd3d6354deb5066970fb6511d02d18d15835e6014ed847fb0
obj-m += xdma_xvc.o
xdma_xvc-objs := xdma-core.o xdma-sgm.o xdma-ioctl.o xdma-bit.o xvc-pcie-driver.o xvc-core.o

KERNELDIR ?= /home/work/svn447/sys/sat/tags/linux2-6-32/linux2-6-32_1-12-0-0_PD_BL
PWD := $(shell pwd)
ROOT := $(dir $(M))

XILINXINCLUDE := -I$(ROOT)../include -I$(ROOT)/include

GCCVERSION = $(shell gcc -dumpversion | sed -e 's/\.\([0-9][0-9]\)/\1/g' -e 's/\.\([0-9]\)/0\1/g' -e 's/^[0-9]\{3,4\}$$/&00/')

GCC49 := $(shell expr $(GCCVERSION) \>= 40900)

EXTRA_CFLAGS := -Wall -DLOG_PREFIX=\"xdma_xvc\" -DDEBUG

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

install: all
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install
	depmod -a
	install -m 644 60-xdma.rules /etc/udev/rules.d

clean:
	rm -rf *.o *.o.d *~ core .depend .*.cmd *.ko *.ko.unsigned *.mod.c .tmp_versions *.symvers modules.order

CFLAGS_xdma-core.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)

ifeq ($(GCC49),1)
	CFLAGS_xdma-core.o += -Wno-error=date-time
endif

CFLAGS_xdma-sgm.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)
CFLAGS_xdma-bit.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)
CFLAGS_xdma-ioctl.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)
CFLAGS_xvc-pcie-driver.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)
CFLAGS_xvc-mmconfig-shared.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)
CFLAGS_xvc-mmconfig_64.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)
CFLAGS_xvc-core.o := $(XILINXINCLUDE) $(EXTRA_CFLAGS)
