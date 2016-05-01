#include <string>
#include "networking.h"

#ifndef _FILE_MANAGER_H_
#define _FILE_MANAGER_H_

void OpenFile(std::string name);
void WriteFrame(Frame& frame);
void CloseFile();

#endif //_FILE_MANAGER_H_
