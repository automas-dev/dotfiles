# Makefile

CPP=g++
CPPFLAGS=-Wall -Weffc++ -O2 -std=c++17
NAME=main
OBJECTS=main.o

all: build

%.o: %.cpp
	$(CPP) -c $(CPPFLAGS) $< -o $@

build: $(OBJECTS)
	$(CPP) $(OBJECTS) -o $(NAME)

clean:
	rm -r *.o main
