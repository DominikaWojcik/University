CC = gcc
CFLAGS = -std=gnu99 -Wall -Wextra

prog: prog.c helper
	$(CC) $(CFLAGS) prog.c -o prog

helper: helper.c
	$(CC) $(CFLAGS) helper.c -o helper

clean:
	rm -f *.o prog helper
