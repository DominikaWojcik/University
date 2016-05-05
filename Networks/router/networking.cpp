#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <unistd.h>
#include <algorithm>
#include <cstdio>
#include "networking.h"
#include "utils.h"
using namespace std;

const unsigned int RECV_BUF_LENGTH = 512;

DVEntry::DVEntry()  
{
}

DVEntry::DVEntry(const NetworkData& network) : 
	network(network.network), distance(network.distance), netmask(network.netmask)
{
	via = "";
	timeout = TIMEOUT;
}

PacketDVEntry::PacketDVEntry()
{
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

		int broadcast = 1;
		if(setsockopt(network.socket, SOL_SOCKET, 
			SO_BROADCAST, &broadcast, sizeof(broadcast)) < 0)
		{
			perror("Setsockopt SO_BROADCAST: ");
			return false;
		}

		sockaddr_in addrInfo;
		addrInfo.sin_family = AF_INET;
		addrInfo.sin_port = htons(PORT);
		//if(inet_pton(AF_INET, network.address.c_str(), &addrInfo.sin_addr.s_addr) < 0)
		if(inet_pton(AF_INET, network.broadcast.c_str(), &addrInfo.sin_addr.s_addr) < 0)
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
				printf("connected directly");
			}
			else
			{
				printf("via %s", entry.via.c_str());
			}
		}
		else
		{
			printf("unreachable");
		}
		printf(" timeout %u", entry.timeout);
		printf("\n");
	}
	printf("\n");
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
		sockaddr_in destination;
		destination.sin_family = AF_INET;
		destination.sin_port = htons(PORT);
		if(inet_pton(AF_INET, network.broadcast.c_str(), 
					&destination.sin_addr.s_addr) < 0)
		{
			perror("Inet_pton in BroadcastDV: ");
			return false;
		}

		if(sendto(network.socket, packet, sizeof(packet), 0,
			(sockaddr*) &destination, sizeof(destination)) < 0)
		{
			//TODO jest do zmiany!!!!!!
			if(errno != EAGAIN && errno != EWOULDBLOCK)
			{
				fprintf(stderr, "Broadcasting to %s/%u ", 
						network.network.c_str(), network.netmask);
				perror("Sendto error: ");
				//Czas zaznaczyć, że sieć jest nieosiągalna
				if(DV[network.network].distance != UNREACHABLE)
				{
					DV[network.network].distance = UNREACHABLE;
					DV[network.network].timeout = TIMEOUT;
				}
			}
		}
		else
		{
			//Skoro przeysłanie sie powiodło, to w takim wypadku mogę podtrzymać timeout
			auto it = DV.find(network.network);
			if(it != DV.end())
			{
				//Aktualizujemy timeout etc
				auto& entry = it->second;
				if(entry.distance >= network.distance)
				{
					entry.distance = network.distance;
					entry.timeout = TIMEOUT;
					entry.via = "";
				}
			}
			else
			{
				//Musimy dodać info do DV o bezposrednim poloczeniu
				DVEntry entry;
				entry.network = network.network;
				entry.netmask = network.netmask;
				entry.distance = network.distance;
				entry.via = "";
				entry.timeout = TIMEOUT;
			}
			DV[network.network].timeout = TIMEOUT;
		}
	}

	return true;
}

void UpdateDV(NetworkData& network, string senderAddress, 
			PacketDVEntry* entry, size_t entriesCount)
{
	for(unsigned int i = 0; i < entriesCount; i++, entry++)
	{
		string networkAddress = UIntToIp(entry->network);
		unsigned int netmask = entry->netmask;
		unsigned int distance = entry->distance;
		//unsigned int via = entry->via;

		auto it = DV.find(networkAddress);
		if(it != DV.end())
		{
			auto& dventry = it->second;
			if(senderAddress == dventry.via  
				|| distance + network.distance < dventry.distance)	
			{
				dventry.distance = min(distance + network.distance, UNREACHABLE);
				dventry.via = dventry.distance < UNREACHABLE ? senderAddress : "";
				dventry.timeout = TIMEOUT;
			}
		}
		else if(distance != UNREACHABLE)
		{
			DVEntry dventry;
			dventry.network = networkAddress;
			dventry.distance = distance + network.distance;
			dventry.netmask = netmask;
			dventry.via = networkAddress == network.network ? "" : senderAddress;
			dventry.timeout = TIMEOUT;
			DV[networkAddress] = dventry;
		}
	}

	//TODO niepodtrzymuje timeoutow od innych komputerow z wlasnej sieci
	DV[network.network].timeout = TIMEOUT;
}

bool ReceiveDVs()
{
	uint8_t buf[RECV_BUF_LENGTH];
	size_t packetLength;
	socklen_t srclength;
	sockaddr_in source;
	//Dla każdej sieci, odbieraj z socketów wszystkie pakiety i każdy z osobna analizuj
	for(auto& network : networks)
	{
		int retVal;
		do
		{
			srclength = sizeof(source);
			retVal = recvfrom(network.socket, buf, RECV_BUF_LENGTH, 0, 
							(sockaddr*) &source, &srclength);
			if(retVal < 0)
			{
				if(errno != EAGAIN && errno != EWOULDBLOCK)
				{
					perror("Recvfrom error: ");
				}
				break;
			}

			packetLength = retVal;

			//Przeanalizuj otrzymany wektor odl wraz z adresem otrzymanym
			char str[32];
			inet_ntop(AF_INET, &source.sin_addr.s_addr, str, sizeof(str));
			string senderAddress = str;

			//Jesli dostalem od siebie samego, to ignoruje
			if(senderAddress == network.address)
			{
				continue;
			}

			size_t entriesCount = packetLength / sizeof(PacketDVEntry);

			PacketDVEntry* entry = (PacketDVEntry*) buf;

			debug("Odebrałem wektor odległości od adresu %s w sieci %s/%u\n", 
						senderAddress.c_str(), network.network.c_str(), network.netmask);

			UpdateDV(network, senderAddress, entry, entriesCount);

		} while(retVal >= 0);
	}

	return true;
}

void CheckTimeouts()
{
	//Przeglądnij wektor odległości w poszukiwaniu niespójności / wyczerpanych timeoutów
	for(auto it = DV.begin(); it != DV.end();)
	{
		DVEntry& entry = it->second;
		
		if(entry.timeout == 0)
		{
			if(entry.distance == UNREACHABLE)
			{
				//Czas usunąć z wektora odleglosci it to nastepny iterator
				it = DV.erase(it);
			}
			else 
			{
				//Dawno nie dostalismy pakietu
				entry.distance = UNREACHABLE;
				entry.timeout = TIMEOUT;
				entry.via = "";
				it++;
			}
		}
		else
		{
			it++;
		}
	}

	for(auto& pair : DV)
	{
		pair.second.timeout--;
	}
}
