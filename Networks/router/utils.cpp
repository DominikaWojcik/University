#include "utils.h"
#include <signal.h>
#include <unistd.h>
#include <cstdio>
using namespace std;


bool ValidAddress(string ip, unsigned int netmask)
{
	if(netmask > 32)
	{
		return false;
	}

	int dots=0,digits=0,num=0;

	for(unsigned int i = 0; i < ip.size(); i++)
	{
		if(ip[i] >= '0' && ip[i] <= '9')
		{
			digits++;
			num *= 10;
			num += (int)(ip[i] - '0');
			if(digits > 3 || num  >= 256)
			{
				return false;
			}
		}
		else if(ip[i] == '.')
		{
			if(digits == 0)
			{
				return false;
			}
			dots++;
			digits = 0;
			num = 0;
		}
		else 
		{
			return false;
		}
	}

	if(dots < 3)
	{
		return false;
	}

	return true;
}

unsigned int IpToUInt(string ip)
{
	unsigned short a,b,c,d;
	sscanf(ip.c_str(), "%hu.%hu.%hu.%hu", &a, &b, &c, &d);
	unsigned int addr = (unsigned int) d;
	addr |= ((unsigned int) c) << 8;
	addr |= ((unsigned int) b) << 16;
	addr |= ((unsigned int) a) << 24;

	return addr;
}

string UIntToIp(unsigned int ip)
{
	unsigned int a,b,c,d;
	a = ip >> 24;
	b = (ip << 8) >> 24;
	c = (ip << 16) >> 24;
	d = (ip << 24) >> 24;

	return to_string(a) + "." + to_string(b) + "." + to_string(c) + "." + to_string(d);
}

string ComputeBroadcastAddress(string address, unsigned int netmask)
{
	unsigned int addr = IpToUInt(address);
	unsigned int mask = ((unsigned int) -1) >> netmask;
	return UIntToIp(addr | mask);
}

string ComputeNetworkAddress(string address, unsigned int netmask)
{
	unsigned int addr = IpToUInt(address);
	unsigned int mask = ((unsigned int) -1) << (32 - netmask);
	return UIntToIp(addr & mask);
}
