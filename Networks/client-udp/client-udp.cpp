#include "networking.h"
#include "utils.h"
#include <iostream>
#include <exception>
using namespace std;


int main(int argc, char* argv[])
{
	try
	{
		ProcessInput(argc, argv);
		Initialize();

		while(!FileDownloaded())
		{
			SendRequests();
			ReceiveData();
			PrintProgress();
		}

		Cleanup();
	}
	catch(exception& e)
	{
		cout << "Exception: " << e.what() << "\n";
		return 1;
	}
	catch(const char* message)
	{
		cout << "Exception: " << message << "\n";
	}
	catch(string& message)
	{
		cout << "Exception: " << message << "\n";
	}

	return 0;
}
