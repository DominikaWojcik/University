#include <unordered_map>
#include <vector>
#include <string>
using namespace std;

#ifndef _NETWORKING_H_
#define _NETWORKING_H_

const int UNREACHABLE = 64; //Odleglosc traktowana jako nieskonczonosc
const int TURN = 10; //Czas trwania tury w sekundach
const int TIMEOUT = 4; //Ile tur do usunięcia z tablicy wektora odl
const int PORT = 9876; //Na którym porcie nasłuchujemy

struct NetworkData
{
	string address, broadcast, network;
	unsigned int netmask, distance;
	int socket;
};

struct DVEntry
{
	string network, via;	
	unsigned int distance, netmask,	timeout;

	DVEntry();
	DVEntry(const NetworkData& network);
};

struct PacketDVEntry
{
	unsigned int network, netmask, distance, via;

	PacketDVEntry(const DVEntry& dventry);
};

bool ProcessInput();

bool Initialize();

void Cleanup();

void PrintDV();

bool BroadcastDV();

bool ReceiveDVs();

void CheckTimeouts();

#endif // _NETWORKING_H_
