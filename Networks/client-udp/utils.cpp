#include "utils.h"
using namespace std;

bool ValidPort(int port)
{
	return port >= 0 && port < (1<<16);
}

