# d52cbaca0ef8cf4fd3d6354deb5066970fb6511d02d18d15835e6014ed847fb0
obj-m += xdma.o
#xdma-objs := xdma-core.o xdma-sgm.o xdma-ioctl.o xdma-bit.o xvc_pcie_driver_base.o xvc_pcie_driver.o mmconfig-shared.o mmconfig_64.o
xdma-objs := xdma-core.o xdma-sgm.o xdma-ioctl.o xdma-bit.o xvc_pcie_driver.o mmconfig-shared.o mmconfig_64.o

KERNELDIR ?= /home/work/svn447/sys/sat/tags/linux2-6-32/linux2-6-32_1-12-0-0_PD_BL

PWD       := $(shell pwd)

ROOT := $(dir $(M))
XILINXINCLUDE := -I$(ROOT)../include -I$(ROOT)/include

GCCVERSION = $(shell gcc -dumpversion | sed -e 's/\.\([0-9][0-9]\)/\1/g' -e 's/\.\([0-9]\)/0\1/g' -e 's/^[0-9]\{3,4\}$$/&00/')

GCC49 := $(shell expr $(GCCVERSION) \>= 40900)

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

install: all
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install
	depmod -a
	install -m 644 10-xcldma.rules /etc/udev/rules.d

clean:
	rm -rf *.o *.o.d *~ core .depend .*.cmd *.ko *.ko.unsigned *.mod.c .tmp_versions *.symvers .#* *.save *.bak Modules.* modules.order Module.markers *.bin

CFLAGS_xdma-core.o := -Wall -DDEBUG $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG

ifeq ($(GCC49),1)
	CFLAGS_xdma-core.o += -Wno-error=date-time
endif

CFLAGS_xdma-sgm.o := $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG
CFLAGS_xdma-bit.o := $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG
CFLAGS_xdma-ioctl.o := $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG
#CFLAGS_xvc_pcie_driver_base.o := $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG
CFLAGS_xvc_pcie_driver.o := $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG
CFLAGS_mmconfig-shared.o := $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG
CFLAGS_mmconfig_64.o := $(XILINXINCLUDE) -DLOG_PREFIX=\"xdma\" -DINCLUDE_CUSTOM_MMCONFIG
