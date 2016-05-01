#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <string>
#include <string.h>
#include "fileManager.h"

using namespace std;

int fileDescriptor;
string fileName;

void OpenFile(string name)
{
	fileName = name;
	fileDescriptor = creat(fileName.c_str(), S_IRUSR | S_IWUSR); 
	if(fileDescriptor < 0) throw string("Creat ") + strerror(errno);
}

void WriteFrame(Frame& frame)
{
	auto bytesWritten = write(fileDescriptor, frame.data, frame.dataLength);
	if(bytesWritten < 0) throw string("Write ") + strerror(errno);
}

void CloseFile()
{
	if(close(fileDescriptor) < 0) throw string("Close ") + strerror(errno);
}
