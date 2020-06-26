
CFLAGS=-O0 -g -Wall -Wextra
CPPFLAGS=-O0 -g -Wall -Wextra -std=c++17
LDFLAGS=

TARGET=main
OBJECTS=

all: $(TARGET)

$(TARGET): main.cpp $(OBJECTS)
	$(CXX) $(LDFLAGS) main.cpp $(OBJECTS) -o $(TARGET)

clean:
	$(RM) *.o $(TARGET)

