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

#include <linux/pagemap.h>
#include <linux/scatterlist.h>

/* describes a mapping from a virtual memory user buffer to scatterlist */
struct sg_mapping_t {
    /* scatter gather list used to map in the relevant user pages */
    struct scatterlist *sgl;
    /* pointer to array of page pointers */
    struct page **pages;
    /* maximum amount of pages in the scatterlist and page array */
    int max_pages;
    /* current amount of mapped pages in the scatterlist and page array */
    int mapped_pages;
};

struct sg_mapping_t *sg_create_mapper(unsigned long max_len);
void sg_destroy_mapper(struct sg_mapping_t *sgm);

int sgm_get_user_pages(struct sg_mapping_t *sgm, const char *start, size_t count, int to_user);
int sgm_put_user_pages(struct sg_mapping_t *sgm, int dirtied);
void sgm_dirty_pages(struct sg_mapping_t *sgm);

int sgm_kernel_pages(struct sg_mapping_t *sgm, const char *start, size_t count, int to_user);

