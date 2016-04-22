#include <string>
#include <vector>
#include <cstdio>

using namespace std;

#ifndef _UTILS_H_
#define _UTILS_H_

#define DEBUG 0
#define debug(fmt, ...)	if(DEBUG) printf(fmt, __VA_ARGS__)

bool ValidAddress(string ip, unsigned int netmask);

unsigned int IpToUInt(string ip);

string UIntToIp(unsigned int ip);

string ComputeBroadcastAddress(string address, unsigned int netmask);

string ComputeNetworkAddress(string address, unsigned int netmask);


#endif // _UTILS_H_
