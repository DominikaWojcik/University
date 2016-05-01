CXX = g++
CXX_FLAGS = -std=c++11 -Wall -Wextra -g

client-udp: client-udp.o networking.o utils.o fileManager.o
	$(CXX) $(CXX_FLAGS) -o client-udp client-udp.o networking.o utils.o fileManager.o

client-udp.o: client-udp.cpp networking.h utils.h
	$(CXX) $(CXX_FLAGS) -c client-udp.cpp -o client-udp.o

fileManager.o: fileManager.cpp fileManager.h networking.h
	$(CXX) $(CXX_FLAGS) -c fileManager.cpp -o fileManager.o

networking.o: networking.cpp networking.h utils.h fileManager.h
	$(CXX) $(CXX_FLAGS) -c networking.cpp -o networking.o

utils.o: utils.cpp utils.h
	$(CXX) $(CXX_FLAGS) -c utils.cpp -o utils.o

clean:
	rm *.o

distclean: 
	rm *.o client-udp
