
CFLAGS=-O0 -g -Wall -Wextra -Werror
CPPFLAGS=-O0 -g -Wall -Wextra -Werror -std=c++17
LDFLAGS=

TARGET=main
OBJECTS=

all: $(TARGET)

$(TARGET): main.cpp $(OBJECTS)
	$(CXX) $(LDFLAGS) main.cpp $(OBJECTS) -o $(TARGET)

clean:
	$(RM) *.o $(TARGET)

