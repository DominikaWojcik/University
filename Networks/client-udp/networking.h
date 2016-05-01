#include <chrono>
#ifndef _NETWORKING_H_
#define _NETWORKING_H_

using namespace std;

const unsigned int FRAME_LENGTH = 1000;

struct Frame
{
	uint8_t data[FRAME_LENGTH];
	unsigned int number, dataLength;
	chrono::time_point<chrono::steady_clock> lastRequest;
	bool received, initialized;

	Frame();
	Frame(int number, int length);
};

void ProcessInput(int argc, char* argv[]);
void Initialize();
bool FileDownloaded();
void SendRequests();
void ReceiveData();
void Cleanup();
void PrintProgress();

#endif //_NETWORKING_H
