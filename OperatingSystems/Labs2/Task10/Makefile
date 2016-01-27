CC = gcc
CFLAGS = -std=gnu99 -Wall -Wextra

all: server client

server: server.c
	$(CC) $(CFLAGS) server.c -o server
client: client.c
	$(CC) $(CFLAGS) client.c -o client
clean:
	rm server client
