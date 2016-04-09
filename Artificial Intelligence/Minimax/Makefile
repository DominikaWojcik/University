CXX = g++
CXX_FLAGS = -std=c++11 -Wall -Wreturn-type -pedantic-errors -g

prog: game.o state.o ai.o
	$(CXX) $(CXX_FLAGS) game.o state.o ai.o -o prog 

game.o: game.cpp state.h ai.h
	$(CXX) $(CXX_FLAGS) -c game.cpp -o game.o

ai.o: ai.cpp ai.h state.h
	$(CXX) $(CXX_FLAGS) -c ai.cpp -o ai.o

state.o: state.cpp state.h
	$(CXX) $(CXX_FLAGS) -c state.cpp -o state.o

clean:
	rm *.o

distclean:
	rm *.o prog
