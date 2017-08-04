#ifndef LLAPI_H
#define LLAPI_H

#include <pciaccess.h>

struct bce_fpga_device {
    bool present;
    struct pci_device pci_device;
};

#define NR_MAX_SLOTS (8)

extern struct bce_fpga_device g_bce_fpga_devices[NR_MAX_SLOTS];

int reg_read_32(int slot, uint64_t addr, uint32_t *value);
int reg_write_32(int slot, uint64_t addr, uint32_t value);

#endif
