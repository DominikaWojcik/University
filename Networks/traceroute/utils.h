#include <stdlib.h>
#ifndef __UTILS_H__
#define __UTILS_H__

u_int16_t compute_icmp_checksum (const void *buff, int length);

int ProcessInput(char* input);

#endif // __UTILS_H__
