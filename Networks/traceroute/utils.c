#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "utils.h"


u_int16_t compute_icmp_checksum (const void *buff, int length)
{
	u_int32_t sum;
	const u_int16_t* ptr = buff;
	assert (length % 2 == 0);
	for (sum = 0; length > 0; length -= 2)
		sum += *ptr++;
	sum = (sum >> 16) + (sum & 0xffff);
	return (u_int16_t)(~(sum + (sum >> 16)));
}

int ProcessInput(char* input)
{
	int dots=0,digits=0,num=0;
	for(unsigned int i = 0; input[i] != '\0'; i++)
	{
		if(input[i] >= '0' && input[i] <= '9')
		{
			digits++;
			num *= 10;
			num += (int)(input[i] - '0');
			if(digits > 3 || num  >= 256)
			{
				fprintf(stderr, "Invalid IP address.\n");
				return -1;
			}
		}
		else if(input[i] == '.')
		{
			if(digits == 0)
			{
				fprintf(stderr, "Invalid IP address.\n");
				return -1;
			}
			dots++;
			digits = 0;
			num = 0;
		}
		else 
		{
			fprintf(stderr, "Invalid IP address.\n");
			return -1;
		}
	}

	if(dots < 3)
	{
		fprintf(stderr, "Invalid IP address.\n");
		return -1;
	}

	return 0;
}
