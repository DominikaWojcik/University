#include <stddef.h>
#ifndef __LIBMALLOC_H__
#define __LIBMALLOC_H__ 1

extern void* malloc(size_t size);

extern void* calloc(size_t count, size_t size);

extern void* realloc(void *ptr, size_t size);

extern void free(void *ptr);

extern void printMemoryState();

#endif
