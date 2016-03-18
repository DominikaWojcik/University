CC = gcc
CFLAGS = -std=gnu99 -Wall -Wextra -g

traceroute: traceroute.o networking.o utils.o
	$(CC) $(CFLAGS) -o traceroute traceroute.o networking.o utils.o

traceroute.o: traceroute.c networking.h utils.h
	$(CC) $(CFLAGS) -c traceroute.c -o traceroute.o

networking.o: networking.c networking.h utils.h
	$(CC) $(CFLAGS) -c networking.c -o networking.o

utils.o: utils.c utils.h
	$(CC) $(CFLAGS) -c utils.c -o utils.o

clean:
	rm *.o

distclean: 
	rm *.o traceroute
