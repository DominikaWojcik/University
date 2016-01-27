CC = gcc
CURRENT_DIR = '$(shell pwd)'
SHARED_LIB_FLAGS = -fPIC -shared
CFLAGS = -std=gnu99 -Wall -Wextra -g

all: libmalloc.so test
	
test: test.c libmalloc.so
	$(CC) $(CFLAGS) -pthread -L$(CURRENT_DIR) -o test test.c -lmalloc

libmalloc.so: libmalloc.o
	$(CC) $(CFLAGS) -shared -pthread -o libmalloc.so libmalloc.o

libmalloc.o: libmalloc.c libmalloc.h
	$(CC) -c $(CFLAGS) -fPIC -pthread -o libmalloc.o libmalloc.c


clean:
	rm *.o *.so test
