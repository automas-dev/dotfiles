
CFLAGS=-O0 -g -Wall -Wextra
CPPFLAGS=-O0 -g -Wall -Wextra -std=c++17
LDFLAGS=

TARGET=main
OBJECTS=main.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

clean:
	$(RM) *.o $(TARGET)

