#include "networking.h"
#include "fileManager.h"
#include "utils.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <memory>
#include <cstdio>
#include <iostream>
#include <sstream>
#include <string>
#include <string.h>
#include <deque>
#include <unistd.h>
#include <exception>

using namespace std;

const char* SERVER_ADDRESS = "aisd.ii.uni.wroc.pl";
const int MAX_FRAMES = 100;
const chrono::milliseconds TIMEOUT_MS(5);

const int ARGUMENTS = 4;
string outputFileName;

int serverPort;
int serverSocket;
sockaddr_in serverInfo;

const int RECVBUFFER_LENGTH = 1024;
uint8_t recvBuffer[RECVBUFFER_LENGTH];

int framesToDownload, lastFrameReceived;
int bytesToDownload, framesDownloaded;
int windowSize; 


//Ramka wypełniona może być kosztowna jeśli chodzi o przesuwanie. (Może zostać przesunięta aż 100 razy! kopiowanie struktury 1000 bajtowej może kosztować uzyjamey unique_pointera ?
//Moze lepiej deque
deque<unique_ptr<Frame>> window;

Frame::Frame()
{
	memset(data, 0, FRAME_LENGTH);
	initialized = false;
	received = false;		
}

Frame::Frame(int number, int length) : number(number), dataLength(length)
{
	memset(data, 0, FRAME_LENGTH);
	initialized = false;
	received = false;		
}

void ProcessInput(int argc, char* argv[])
{
	if(argc < ARGUMENTS) throw "Too few arguments. Provide port number, output file, number of bytes";
	else if(argc > ARGUMENTS) throw "Too many arguments. Provide port number, output file, number of bytes";

	serverPort = atoi(argv[1]);
	outputFileName = argv[2];
	bytesToDownload = atoi(argv[3]);

	if(!ValidPort(serverPort)) throw "Invalid server port";
}

void Initialize()
{
	OpenFile(outputFileName);
	
	if((serverSocket = socket(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0)) < 0)
	{
		throw string("Socket ") + strerror(errno);
	}

	addrinfo* result;
	addrinfo hints; 
	
	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family = AF_INET;
	hints.ai_socktype = SOCK_DGRAM; //inaczej dostaniemy 3 struktury dla (stream, dgram, raw)
	hints.ai_flags = 0;
	hints.ai_protocol = 0;          /* Any protocol */


	int ret;
	if((ret = getaddrinfo(SERVER_ADDRESS, to_string(serverPort).c_str(),
						 &hints, &result)) != 0)
	{
		string error;
		switch(ret)
		{
			case EAI_ADDRFAMILY:
				error = "EAI_ADDRFAMILY";
				break;
			case EAI_AGAIN:
				error = "EAI_AGAIN";
				break;
			case EAI_BADFLAGS:
				error = "EAI_BADFLAGS";
				break;
			case EAI_NODATA:
				error = "EAI_NODATA";
				break;			
			default:
				error = "Other error";
		}
		throw string("Getaddrinfo ") + strerror(errno) + error;
	}
	
	sockaddr_in* resultAddr = (sockaddr_in*) result->ai_addr;
	serverInfo.sin_addr = resultAddr->sin_addr;
	serverInfo.sin_port = htons(serverPort);
	serverInfo.sin_family = AF_INET;
	freeaddrinfo(result);

	lastFrameReceived = -1;		
	framesToDownload = bytesToDownload / FRAME_LENGTH + (bytesToDownload % FRAME_LENGTH != 0 ? 1 : 0);
	framesDownloaded = 0;
	windowSize = min(framesToDownload, MAX_FRAMES);

	window.resize(windowSize);
	for(int i = 0; i < windowSize; i++)
	{
		int length = FRAME_LENGTH;
		if(i == framesToDownload - 1 && bytesToDownload % FRAME_LENGTH)
		{
			length = bytesToDownload % FRAME_LENGTH;
		}
		window[i] = unique_ptr<Frame>(new Frame(i, length));
	}
}

void SendFrameRequest(Frame& frame)
{
	char buffer[64];
	int length = sprintf(buffer, "GET %d %d\n", frame.number * FRAME_LENGTH, frame.dataLength);
	int retVal = sendto(serverSocket, buffer, length, 0, 
						(sockaddr*) &serverInfo, sizeof(serverInfo));
	if(retVal < 0 && errno != EAGAIN && errno != EWOULDBLOCK)
	{
		throw string("SendTo ") + strerror(errno);
	}
}

void SendRequests()
{
	for(auto& frame : window)
	{
		if(!frame->received)
		{
			auto interval = chrono::steady_clock::now() - frame->lastRequest;
			auto elapsedTime = chrono::duration_cast<chrono::milliseconds>(interval);	
			if(!frame->initialized || elapsedTime >= TIMEOUT_MS)
			{
				SendFrameRequest(*frame);
				if(!frame->initialized) frame->initialized = true;
				frame->lastRequest = chrono::steady_clock::now();
			}
		}
	}
}

void ReceiveFrame(uint8_t* buf, int bufLength)
{
	int offset, length;
	istringstream iss(string((char*)buf, bufLength));

	string DATA;
	iss >> DATA >> offset >> length;
	char newline[2];
	iss.read(newline, 1);

	int number = offset / FRAME_LENGTH;
	if(number > lastFrameReceived && number < lastFrameReceived + windowSize + 1)
	{
		auto& frame = *window[number - lastFrameReceived - 1];
		if(!frame.received)
		{
			//To ma za zadanie przelać length bajtow z buf zaraz po naglowku do ramki
			iss.read((char*)frame.data, length);
			frame.received = true;
			framesDownloaded++;
		}
	}
}

void ReceiveData()
{
	int retVal;
	do
	{
		sockaddr_in senderInfo;
		socklen_t addrlen = sizeof(senderInfo);

		memset(recvBuffer, 0, RECVBUFFER_LENGTH);
		retVal = recvfrom(serverSocket, recvBuffer, RECVBUFFER_LENGTH, 
							0, (sockaddr*) &senderInfo, &addrlen);
		if(retVal < 0)
		{
			if(errno != EAGAIN && errno != EWOULDBLOCK)
			{
				throw string("Recvfrom ") + strerror(errno);
			}
			break;
		}

		//filtrujemy te nie od servera zgadza sie z serwerem
		if(senderInfo.sin_addr.s_addr != serverInfo.sin_addr.s_addr) break;
		ReceiveFrame(recvBuffer, retVal);		
	}
	while(retVal >= 0);

	//Akutalizujemy okno
	int newFramesToAdd = 0;

	while(!window.empty() && window.front()->received)
	{
		WriteFrame(*window.front());
		newFramesToAdd++;
		window.pop_front();
	}

	lastFrameReceived += newFramesToAdd;
	int numberToAdd = window.empty() ? lastFrameReceived : window.back()->number;
	for(int i = 1; i <= newFramesToAdd && numberToAdd + i < framesToDownload; i++)
	{
		int length = FRAME_LENGTH;
		if(numberToAdd + i == framesToDownload - 1 && bytesToDownload % FRAME_LENGTH)
		{
			length = bytesToDownload % FRAME_LENGTH;
		}
		window.push_back(unique_ptr<Frame>(new Frame(numberToAdd + i, length)));
	}
}

void Cleanup()
{
	close(serverSocket);
	window.clear();
	CloseFile();
}

bool FileDownloaded()
{
	return lastFrameReceived == framesToDownload - 1;
}

int lastProgress = -1;
void PrintProgress()
{
	if(lastProgress < framesDownloaded)
	{
		cout << "PROGRESS: " << framesDownloaded << "/" << framesToDownload 
			<< " LFR: " << lastFrameReceived << " WINDOW: " << window.size() << "\n";
		lastProgress = framesDownloaded;

	}
}
