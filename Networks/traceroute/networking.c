#include "networking.h"
#include "utils.h"
#include <netinet/ip_icmp.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <assert.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#define WAITING_TIME 1
#define MAX_TTL 30
#define PACKETS_TO_SEND 3
#define IP_ADDRESS_LENGTH 20
#define MICROSEC_TO_MILLISEC 1000
#define ICMP_EXC_LENGTH 8

#define DEBUG 0
#define debug(...) if(DEBUG) fprintf(stderr, __VA_ARGS__)

typedef struct
{
	struct timeval sendTime, receiveTime;
	char ipAddr[IP_ADDRESS_LENGTH];
} ttlPacket;

ttlPacket packetInfo[MAX_TTL + 1][PACKETS_TO_SEND];
char* recipientAddress;
int mySocket;
int responseFromTarget;
pid_t myPid;

int Initialization(char* address)
{
	debug("Init\n");
	mySocket = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
	if(mySocket < 0)
	{
		perror("Create Socket.\n");
		return -1;
	}

	recipientAddress = address;
	responseFromTarget = 0;
	myPid = getpid();

	debug("Init end\n");
	return 0;
}

int SendPacket(int ttl, int id)
{
	debug("SendPacket ttl %d id %d\n", ttl, id);

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

	setsockopt(mySocket, IPPROTO_IP, IP_TTL, &ttl, sizeof(int));

	ssize_t bytesSent = sendto(mySocket, &icmpHeader, sizeof(icmpHeader),
						MSG_DONTWAIT, (struct sockaddr*)&recipient, sizeof(recipient));
	if(bytesSent < 0)
	{
		fprintf(stderr, "Error while sending packet ttl = %d, id = %d\n", ttl, id);
		perror("sendto error\n");
		return -1;
	}

	if(gettimeofday(&packetInfo[ttl][id - 3*ttl].sendTime, NULL) < 0)
	{
		perror("Get time of day failed.\n");
		return -1;
	}
	debug("Send time ttl %d id %d = %ld, %ld\n", ttl, id - 3*ttl, packetInfo[ttl][id - 3*ttl].sendTime.tv_sec, packetInfo[ttl][id - 3*ttl].sendTime.tv_usec);

	debug("SendPacket end ttl %d id %d\n", ttl, id);
	return 0;
}

int ReceivePackets(int ttl)
{	
	debug("Receive Packets ttl %d\n", ttl);
	ssize_t packetLength = 0;
	time_t secondsElapsed = 0;
	struct timeval startTime, currentTime, difference;

	if(gettimeofday(&startTime, NULL) < 0)
	{
		perror("Get time of day failed.\n");
		return -1;
	}	

	do
	{
		if(gettimeofday(&currentTime, NULL) < 0)
		{
			perror("Get time of day failed.\n");
			return -1;
		}

		timersub(&currentTime, &startTime, &difference);
		secondsElapsed = difference.tv_sec;	

		struct sockaddr_in sender;
		socklen_t senderLength = sizeof(sender);
		u_int8_t buffer[IP_MAXPACKET+1];

		packetLength = recvfrom (
				mySocket,
				buffer,
				IP_MAXPACKET,
				MSG_DONTWAIT,
				(struct sockaddr*)&sender,
				&senderLength
				);
		if(packetLength < 0)
		{
			if(errno != EAGAIN && errno != EWOULDBLOCK)
			{
				fprintf(stderr, "Error while receiving packets for ttl = %d\n", ttl);
				perror("Recvfrom error\n");
				return -1;
			}
			continue;
		}

		struct iphdr* ipHeader = (struct iphdr*) buffer;
		u_int8_t* icmpPacket = buffer + 4 * ipHeader->ihl; 
		struct icmphdr* icmpHeader = (struct icmphdr*) icmpPacket;
		struct icmphdr* oldIcmpHeader;


		if(icmpHeader->type == ICMP_TIME_EXCEEDED && icmpHeader->code == ICMP_EXC_TTL)
		{
			//Wyciągam stary nagłówek ICMP
			icmpPacket = ((u_int8_t*) icmpHeader) + ICMP_EXC_LENGTH;
			struct iphdr* oldIpHeader = (struct iphdr*) icmpPacket;
			icmpPacket = ((u_int8_t*) oldIpHeader) + 4 * oldIpHeader->ihl;
			oldIcmpHeader = (struct icmphdr*) icmpPacket;
			icmpHeader = oldIcmpHeader;
		}

		if(icmpHeader->un.echo.id != myPid || 
			icmpHeader->un.echo.sequence >= (ttl + 1) * PACKETS_TO_SEND || 
			icmpHeader->un.echo.sequence < ttl * PACKETS_TO_SEND)
		{
			continue;
		}

		if(icmpHeader->type == ICMP_ECHOREPLY)	
		{
			responseFromTarget = 1;
		}

		int id = icmpHeader->un.echo.sequence - 3*ttl;

		if(gettimeofday(&packetInfo[ttl][id].receiveTime, NULL) < 0)
		{
			perror("Get time of day failed.\n");
			return -1;
		}	

		debug("Receive time ttl %d id %d = %ld, %ld\n", ttl, id, packetInfo[ttl][id].receiveTime.tv_sec, packetInfo[ttl][id].receiveTime.tv_usec);

		if(inet_ntop(AF_INET, &sender.sin_addr, 
			packetInfo[ttl][id].ipAddr, IP_ADDRESS_LENGTH) == NULL)
		{
			perror("Inet_ntop error.\n");
			return -1;
		}

		if(gettimeofday(&currentTime, NULL) < 0)
		{
			perror("Get time of day failed.\n");
			return -1;
		}

		timersub(&currentTime, &startTime, &difference);
		secondsElapsed = difference.tv_sec;	
	}
	while(secondsElapsed < WAITING_TIME);

	debug("Receive Packets end ttl %d\n", ttl);
	return 0;
}

void PrintResults(int ttl)
{
	printf("%d. ", ttl);
	int receivedAnswers = 0;
	suseconds_t totalTime = 0;

	for(int i = 0; i < PACKETS_TO_SEND; i++)
	{
		time_t recvSeconds = packetInfo[ttl][i].receiveTime.tv_sec;
		suseconds_t recvMicroseconds = packetInfo[ttl][i].receiveTime.tv_usec;
		
		if(recvSeconds == 0 && recvMicroseconds == 0) continue;
		
		int repeatingAddress = 0;
		for(int j = i - 1; j >= 0; j--)
		{
			if(strcmp(packetInfo[ttl][i].ipAddr, packetInfo[ttl][j].ipAddr) == 0)
			{
				repeatingAddress = 1;
				break;
			}
		}

		if(!repeatingAddress)
		{
			printf("%s ", packetInfo[ttl][i].ipAddr);
		}

		receivedAnswers++;
		struct timeval difference;
		timersub(&packetInfo[ttl][i].receiveTime, &packetInfo[ttl][i].sendTime, &difference);	
		totalTime += difference.tv_usec;
	}

	if(receivedAnswers == 0) 
	{
		printf("*\n");
	}
	else if(receivedAnswers < PACKETS_TO_SEND) 
	{
		printf("\t???\n");
	}
	else
	{
		suseconds_t averageTime = totalTime / PACKETS_TO_SEND;
		printf("\t%ld.%ld ms\n", averageTime / MICROSEC_TO_MILLISEC, averageTime % MICROSEC_TO_MILLISEC);
	}
}

int TraceRoute(char* address)
{
	if(Initialization(address) < 0)
	{
		return -1;
	}
	
	printf("Traceroute to %s\n", address);

	for(int ttl = 1; ttl <= 30 && !responseFromTarget; ttl++)
	{
		for(int i = 0; i < PACKETS_TO_SEND; i++)
		{
			if(SendPacket(ttl, ttl * PACKETS_TO_SEND + i) < 0)
			{
				return -2;
			}
		}

		ReceivePackets(ttl);

		PrintResults(ttl);
	}



	return 0;
}
