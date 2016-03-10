CC = gcc
CFLAGS = -std=gnu99 -Wall -Wextra -g

traceroute: traceroute.o networking.o
	$(CC) $(CFLAGS) -o traceroute traceroute.o networking.o

traceroute.o: traceroute.c networking.h
	$(CC) $(CFLAGS) -c traceroute.c -o traceroute.o

networking.o: networking.c networking.h
	$(CC) $(CFLAGS) -c networking.c -o networking.o

clean:
	rm *.o

distclean: 
	rm *.o traceroute
