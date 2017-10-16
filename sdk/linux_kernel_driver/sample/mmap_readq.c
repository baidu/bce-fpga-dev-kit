#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <errno.h>
#include <assert.h>

#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <path> <offset in decimal>\n", argv[0]);
        return 1;
    }

    const char *path_str = argv[1];
    const char *offset_str = argv[2];

    char *end_ptr = NULL;
    uint64_t offset = (uint64_t)strtoull(offset_str, &end_ptr, 10);
    if (*end_ptr != '\0') {
        fprintf(stderr, "Invalid offset, offset=%s\n", offset_str);
        return 1;
    }

    int fd = open(path_str, O_RDWR);
    if (fd < 0) {
        fprintf(stderr, "Can not open file %s, errno=%d\n", path_str, errno);
        return 1;
    }

    struct stat file_stat;
    int ret = fstat(fd, &file_stat);
    if (ret < 0) {
        fprintf(stderr, "Can not stat file %s, errno=%d\n", path_str, errno);
        return 1;
    }
    if (offset >= file_stat.st_size) {
        fprintf(stderr, "Invalid offset, offset=%" PRIu64 "\n", offset);
        return 1;
    }

    void *mmap_addr = mmap(NULL, file_stat.st_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (mmap_addr == MAP_FAILED) {
        fprintf(stderr, "Can not mmap file %s, errno=%d\n", path_str, errno);
        return 1;
    }

    uint64_t qword = *(uint64_t *)((uint64_t)mmap_addr + offset);
    printf("%" PRIx64 "\n", qword);

    munmap(mmap_addr, file_stat.st_size);
    close(fd);

    return 0;
}
