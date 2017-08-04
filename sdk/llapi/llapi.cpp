#include "llapi.h"

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Concatenate numbers in c/c++ macros.
#ifndef BAIDU_CONCAT
# define BAIDU_CONCAT(a, b) BAIDU_CONCAT_HELPER(a, b)
# define BAIDU_CONCAT_HELPER(a, b) a##b
#endif

// Put following code somewhere global to run it before main():
//
//   BAIDU_GLOBAL_INIT()
//   {
//       ... your code ...
//   }
//
// Your can:
//   * Write any code and access global variables.
//   * Use ASSERT_*.
//   * Have multiple BAIDU_GLOBAL_INIT() in one scope.
//
// Since the code run in global scope, quit with exit() or similar functions.
#ifndef BAIDU_GLOBAL_INIT
#if defined(__cplusplus)
# define BAIDU_GLOBAL_INIT                                      \
namespace {  /*anonymous namespace */                           \
    struct BAIDU_CONCAT(BaiduGlobalInit, __LINE__) {            \
        BAIDU_CONCAT(BaiduGlobalInit, __LINE__)() { init(); }   \
        void init();                                            \
    } BAIDU_CONCAT(baidu_global_init_dummy_, __LINE__);         \
}  /* anonymous namespace */                                    \
    void BAIDU_CONCAT(BaiduGlobalInit, __LINE__)::init
#else
# define BAIDU_GLOBAL_INIT                      \
    static void __attribute__((constructor))    \
    BAIDU_CONCAT(baidu_global_init_, __LINE__)
#endif  // __cplusplus
#endif

#ifndef BAIDU_GLOBAL_DESTROY
#if defined(__cplusplus)
# define BAIDU_GLOBAL_DESTROY                                        \
namespace {  /*anonymous namespace */                                \
    struct BAIDU_CONCAT(BaiduGlobalDestroy, __LINE__) {              \
        ~BAIDU_CONCAT(BaiduGlobalDestroy, __LINE__)() { destroy(); } \
        void destroy();                                              \
    } BAIDU_CONCAT(baidu_global_destroy_dummy_, __LINE__);           \
}  /* anonymous namespace */                                         \
    void BAIDU_CONCAT(BaiduGlobalDestroy, __LINE__)::destroy
#else
# define BAIDU_GLOBAL_DESTROY                                        \
    static void __attribute__((destructor))                          \
    BAIDU_CONCAT(baidu_global_destroy_, __LINE__)
#endif  // __cplusplus
#endif

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

struct bce_fpga_device g_bce_fpga_devices[NR_MAX_SLOTS];

int reg_read_32(int slot, uint64_t addr, uint32_t *value)
{
    if ((slot < 0) || (slot >= NR_MAX_SLOTS)) {
        return -1;
    }
    if (!g_bce_fpga_devices[slot].present) {
        return -1;
    }
    if (!g_bce_fpga_devices[slot].pci_device.regions[0].memory) {
        return -1;
    }

    *value = *(uint32_t *)((uint64_t)g_bce_fpga_devices[slot].pci_device.regions[0].memory + addr);
    return 0;
}

int reg_write_32(int slot, uint64_t addr, uint32_t value)
{
    if ((slot < 0) || (slot >= NR_MAX_SLOTS)) {
        return -1;
    }
    if (!g_bce_fpga_devices[slot].present) {
        return -1;
    }
    if (!g_bce_fpga_devices[slot].pci_device.regions[0].memory) {
        return -1;
    }

    *(uint32_t *)((uint64_t)g_bce_fpga_devices[slot].pci_device.regions[0].memory + addr) = value;
    return 0;
}

static int probe_all_slots()
{
    int ret = 0;
    struct pci_device_iterator *it = NULL;
    struct pci_device *dev = NULL;

    ret = pci_system_init();
    if (ret) {
        //LOG(WARNING) << "Error calling pci_system_init";
        return -1;
    }

    struct pci_id_match xilinx_match = {
        0x10ee,          /* vendor_id */
        PCI_MATCH_ANY,   /* device_id */
        PCI_MATCH_ANY,   /* subvendor_id */
        PCI_MATCH_ANY,   /* subdevice_id */
    };
    int slot = 0;

    memset(&g_bce_fpga_devices, 0, sizeof(g_bce_fpga_devices));
    it = pci_id_match_iterator_create(&xilinx_match);
    if (!it) {
        //LOG(WARNING) << "Error calling pci_id_match_iterator_create";
        ret = -1;
        goto err;
    }
    for (; slot < NR_MAX_SLOTS;) {
        dev = pci_device_next(it);
        if (!dev) {
            /* End of iteration */
            goto err_it;
        }

        /**
         * pci_enable_device - Initialize device before it's used by a driver.
         * @dev: PCI device to be initialized
         *
         *  Initialize device before it's used by a driver. Ask low-level code
         *  to enable I/O and memory. Wake up the device if it was suspended.
         *  Beware, this function can fail.
         *
         *  Note we don't actually enable the device many times if we call
         *  this function repeatedly (we just increment the count).
         */
        /* equalvalent with `echo 1 > /sys/bus/pci/devices/.../enable` */
        pci_device_enable(dev);

        /* Probes a PCI device to learn various information about the device. Before calling this
         * function, the only public fields in the pci_device structure that have valid values are
         * pci_device::domain, pci_device::bus, pci_device::dev, and pci_device::func. */
        ret = pci_device_probe(dev);
        if (ret) {
            //LOG(WARNING) << "Error calling pci_device_probe";
            ret = -1;
            goto err_it;
        }

        /* mmap BAR0 */
        ret = pci_device_map_range(dev, dev->regions[0].base_addr, dev->regions[0].size,
                                   PCI_DEV_MAP_FLAG_WRITABLE, &dev->regions[0].memory);
        if (ret) {
            //LOG(WARNING) << "Error calling pci_device_map_range";
            ret = -1;
            goto err_it;
        }

        g_bce_fpga_devices[slot].present = true;
        g_bce_fpga_devices[slot].pci_device = *dev;
        ++slot;
    }

err_it:
    pci_iterator_destroy(it);
err:
    /* XXX: pci_system_cleanup() would munmap all PCI BARs... */
    //pci_system_cleanup();
    return ret;
}

BAIDU_GLOBAL_INIT()
{
    int ret = probe_all_slots();
    assert(ret == 0);
}

BAIDU_GLOBAL_DESTROY()
{
    pci_system_cleanup();
}

