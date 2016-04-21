CXX = g++
CXX_FLAGS = -std=c++11 -Wall -Wextra -g

router: router.o networking.o utils.o
	$(CXX) $(CXX_FLAGS) -o router router.o networking.o utils.o

router.o: router.cpp networking.h utils.h
	$(CXX) $(CXX_FLAGS) -c router.cpp -o router.o

networking.o: networking.cpp networking.h utils.h
	$(CXX) $(CXX_FLAGS) -c networking.cpp -o networking.o

utils.o: utils.cpp utils.h
	$(CXX) $(CXX_FLAGS) -c utils.cpp -o utils.o

clean:
	rm *.o

distclean: 
	rm *.o router
