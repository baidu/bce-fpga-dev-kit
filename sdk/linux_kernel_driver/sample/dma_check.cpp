/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "fpga_cloud.h"
#include <assert.h>

using namespace fpga::cloud::api;

bool g_failed = false;

struct thread_input_t {
    int i;
    size_t dma_size;
    uint64_t ddr_addr;
    uint64_t iteration;
};

void *thread_func(void *p)
{
    struct thread_input_t *pargs = static_cast<struct thread_input_t *>(p);
    int i = pargs->i;
    size_t dma_size = pargs->dma_size;
    uint64_t ddr_addr = pargs->ddr_addr;
    uint64_t iteration = pargs->iteration;
    unsigned char *to_fpga = new unsigned char[dma_size];
    unsigned char *from_fpga = new unsigned char[dma_size];
    int rc = 0;

    if (!to_fpga || !from_fpga) {
        g_failed = true;
        fprintf(stderr, "no memory\n");
        return NULL;
    }

    for (uint64_t i = 0; i < iteration; ++i) {
        to_fpga[0] = (unsigned char)i;
        to_fpga[dma_size - 1] = (unsigned char)(i + 1);

        rc = fpga_memcpy(0, ddr_addr,
                         reinterpret_cast<uint64_t>(to_fpga),
                         dma_size, 1);
        if (rc) {
            g_failed = true;
            fprintf(stderr, "fpga_memcpy failed, copy to fpga\n");
            return NULL;
        }

        rc = fpga_memcpy(0, reinterpret_cast<uint64_t>(from_fpga),
                         ddr_addr,
                         dma_size, 0);
        if (rc) {
            g_failed = true;
            fprintf(stderr, "fpga_memcpy failed, copy from fpga\n");
            return NULL;
        }

        if (memcmp(to_fpga, from_fpga, dma_size)) {
            g_failed = true;
            fprintf(stderr, "thread %d data diff\n", i);
            return NULL;
        }
    }

    delete [] to_fpga;
    delete [] from_fpga;
    return NULL;
}

int main(int argc, char **argv)
{
    int ret = 0;

    if (argc != 4) {
        fprintf(stderr, "Usage: %s <nthreads> <dma_size> <iteration>\n", argv[0]);
        return 1;
    }

    char *eof;
    int nthreads = atoi(argv[1]);
    if (nthreads < 1) {
        fprintf(stderr, "invalid nthreads\n");
        return 1;
    }
    uint64_t dma_size = strtoull(argv[2], &eof, 10);
    if (*eof != '\0') {
        fprintf(stderr, "invalid dma_size\n");
        return 1;
    }
    uint64_t iteration = strtoull(argv[3], &eof, 10);
    if (*eof != '\0') {
        fprintf(stderr, "invalid iteration\n");
        return 1;
    }

    pthread_t threads[nthreads];
    struct thread_input_t threads_input[nthreads];
    for (int i = 0; i < nthreads; ++i) {
        threads_input[i].i = i;
        threads_input[i].dma_size = dma_size;
        threads_input[i].ddr_addr = (2 << 20)/* HUGE_PAGE_SIZE 2MB */ * i;
        threads_input[i].iteration = iteration;

        pthread_create(&threads[i], NULL, &thread_func, &threads_input[i]);
    }

    for (int i = 0; i < nthreads; ++i) {
        pthread_join(threads[i], NULL);
    }

    if (g_failed) {
        fprintf(stderr, "dma_check FAILED\n");
        return 1;
    } else {
        fprintf(stderr, "dma_check OK\n");
        return 0;
    }
}

