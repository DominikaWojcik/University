#ifndef __LIBMALLOC_H__
#define __LIBMALLOC_H__

void* malloc(size_t size);

void* calloc(size_t count, size_t size);

void* realloc(void *ptr, size_t size);

void free(void *ptr);

void printMemoryState()

#endif
