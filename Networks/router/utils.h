#include <string>
#include <vector>

using namespace std;

#ifndef _UTILS_H_
#define _UTILS_H_

bool ValidAddress(string ip, unsigned int netmask);

unsigned int IpToUInt(string ip);

string UIntToIp(unsigned int ip);

string ComputeBroadcastAddress(string address, unsigned int netmask);

string ComputeNetworkAddress(string address, unsigned int netmask);


#endif // _UTILS_H_
