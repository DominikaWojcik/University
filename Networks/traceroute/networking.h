#ifndef __NETWORKING_H__
#define __NETWORKING_H__

int Initialization(char* address);

int SendPacket(int ttl, int id);

int ReceivePackets();

int TraceRoute(char* address);


#endif // __NETWORKING_H__
