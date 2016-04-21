#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <unistd.h>
#include <cstdio>
#include "networking.h"
#include "utils.h"
using namespace std;


DVEntry::DVEntry()  
{
}

DVEntry::DVEntry(const NetworkData& network) : 
	network(network.network), distance(network.distance), netmask(network.netmask)
{
	via = "";
	timeout = TIMEOUT;
}

PacketDVEntry::PacketDVEntry(const DVEntry& dventry)
{
	network = IpToUInt(dventry.network);
	netmask = dventry.netmask;
	distance = dventry.distance;
	via = IpToUInt(dventry.via);
}

//Lista sieci, w których się znajduję
vector<NetworkData> networks;

//Mapa adres sieci -> wpis w wektorze odległości
unordered_map<string, DVEntry> DV;

bool ProcessInput()
{
	int n;
	scanf("%d", &n);
	for(int i=0;i<n;i++)
	{
		char buffer[20];
		NetworkData newNeighbour;

		scanf("%s netmask /%u distance %u", 
			buffer, &newNeighbour.netmask, &newNeighbour.distance);
		newNeighbour.address = buffer;

		if(ValidAddress(newNeighbour.address, newNeighbour.netmask) == false)
		{
			return false;
		}

		networks.push_back(newNeighbour);
	}

	return true;
}

bool Initialize()
{
	for(auto& network : networks)
	{
		network.network = ComputeNetworkAddress(network.address, network.netmask);
		network.broadcast = ComputeBroadcastAddress(network.address, network.netmask);	

		if((network.socket = socket(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0)) < 0)
		{
			perror("Tworzenie gniazda: ");
			return false;
		}

		sockaddr_in addrInfo;
		addrInfo.sin_family = AF_INET;
		addrInfo.sin_port = htons(PORT);
		if(inet_pton(AF_INET, network.address.c_str(), &addrInfo.sin_addr.s_addr) < 0)
		{
			perror("Inet_pton: ");
			return false;
		}
		 
		if(bind(network.socket, (sockaddr*) &addrInfo, sizeof(addrInfo)) < 0)
		{
			perror("Bindowanie gniazda do adresu: ");
			return false;
		}

		DVEntry dventry(network);
		DV[network.network] = dventry;
	}

	return true;
}

void Cleanup()
{
	for(auto& network : networks)
	{
		close(network.socket);
	}
}

void PrintDV()
{
	printf("DISTANCE VECTOR\n");
	for(auto& pair : DV)
	{
		DVEntry& entry = pair.second;

		printf("%s/%u ", entry.network.c_str(), entry.netmask);
		if(entry.distance < UNREACHABLE)
		{
			printf("distance %d ", entry.distance);
			if(entry.via == "")
			{
				printf("connected directly\n");
			}
			else
			{
				printf("via %s\n", entry.via.c_str());
			}
		}
		else
		{
			printf("unreachable\n");
		}
	}
}

bool BroadcastDV()
{
	//Przygotowanie struktury do wysyłania		
	PacketDVEntry packet[DV.size()];

	int i=0;
	for(auto& pair : DV)
	{
		auto& entry = pair.second;
		packet[i] = PacketDVEntry(entry);
		i++;
	}

	//Rozsyłanie do wszystkich sieci, w których się znajduję
	//Uwzględnienie, że sendto() może się nie udać
	for(auto& network : networks)
	{
		if(sendto(network.socket, packet, sizeof(packet), &destination, sizeof(destination)) < 0)
		{
			//To jest do zmiany!!!!!!
			if(errno != EAGAIN && errno != EWOULDBLOCK)
			{
				perror("Sendto error: ");
				return false;
			}
		}
	}

	return true;
}

bool ReceiveDVs()
{
	uint8_t buf[512];
	//Dla każdej sieci, odbieraj z socketów wszystkie pakiety i każdy z osobna analizuj
	for(auto& network : networks)
	{
		int retVal;
		do
		{
			retVal = recvfrom(network.socket, buf, length, 0, (sockaddr*) &source, srclength);
			if(retVal < 0)
			{
				if(errno != EAGAIN && errno != EWOULDBLOCK)
				{
					perror("Recvfrom error: ");
					return false;
				}
				else 
				{
					break;
				}
			}

			//Przeanalizuj otrzymany wektor odl wraz z adresem otrzymanym
		} while(retVal >= 0);
	}

	return true;
}

void CheckTimeouts()
{
	//Przeglądnij wektor odległości w poszukiwaniu niespójności / wyczerpanych timeoutów
}
