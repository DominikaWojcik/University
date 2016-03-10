#include "networking.h"
#include <netinet/ip_icmp.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <assert.h>
#include <sys/socket.h>
#include <time.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#define WAITING_TIME 1
#define PACKETS_TO_SEND 3

char* recipientAddress;
int mySocket;
int responseFromTarget;
pid_t myPid;

int Initialization(char* address)
{
	mySocket = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
	if(mySocket < 0)
	{
		perror("Create Socket.\n");
		return -1;
	}

	recipientAddress = address;
	responseFromTarget = 0;
	myPid = getpid();

	return 0;
}


u_int16_t compute_icmp_checksum (const void *buff, int length)
{
	u_int32_t sum;
	const u_int16_t* ptr = buff;
	assert (length % 2 == 0);
	for (sum = 0; length > 0; length -= 2)
		sum += *ptr++;
	sum = (sum >> 16) + (sum & 0xffff);
	return (u_int16_t)(~(sum + (sum >> 16)));
}


int SendPacket(int ttl, int id)
{
	struct icmphdr icmpHeader;
	icmpHeader.type = ICMP_ECHO;
	icmpHeader.code = 0;
	icmpHeader.un.echo.id = myPid;
	icmpHeader.un.echo.sequence = id;
	icmpHeader.checksum = 0;
	icmpHeader.checksum = compute_icmp_checksum(
		(u_int16_t*)&icmpHeader, sizeof(icmpHeader));

	struct sockaddr_in recipient;
	bzero (&recipient, sizeof(recipient));
	recipient.sin_family = AF_INET;

	int retVal = inet_pton(AF_INET, recipientAddress, &recipient.sin_addr);
	if(retVal == 0)
	{
		fprintf(stderr, "Error in Send Packet - inet_pton ttl = %d, id = %d\n", ttl, id);
		fprintf(stderr, "Recipient contains invalid address.\n");
		return -1;
	}
	else if(retVal < 0)
	{
		fprintf(stderr, "Error in Send Packet - inet_pton ttl = %d, id = %d\n", ttl, id);
		perror("Send Packet - inet_pton\n");
		return -1;
	}

	setsockopt (mySocket, IPPROTO_IP, IP_TTL, &ttl, sizeof(int));

	ssize_t bytesSent = sendto (mySocket, &icmpHeader, sizeof(icmpHeader),
						0, (struct sockaddr*)&recipient, sizeof(recipient));
	if(bytesSent < 0)
	{
		fprintf(stderr, "Error while sending packet ttl = %d, id = %d\n", ttl, id);
		perror("Send Packet\n");
		return -1;
	}

	return 0;
}

int ReceivePackets()
{

}

void PrintResults()
{

}

int TraceRoute(char* address)
{
	if(Initialization(address) < 0)
	{
		return -1;
	}

	for(int ttl = 1; ttl <= 30 && !responseFromTarget; ttl++)
	{
		for(int i = 0; i < PACKETS_TO_SEND; i++)
		{
			if(SendPacket(ttl, ttl * PACKETS_TO_SEND + i) < 0)
			{
				return -2;
			}
		}

		sleep(WAITING_TIME);

		ReceivePackets();

		PrintResults();
	}



	return 0;
}
