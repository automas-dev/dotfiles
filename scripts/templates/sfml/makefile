
SFML:=`pkg-config --cflags sfml-all`
CFLAGS=-O0 -g $(SFML)
CPPFLAGS=-O0 -g -std=c++17 $(SFML)
LDFLAGS=`pkg-config --libs sfml-all gl`

TARGET=main
OBJECTS=main.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $(TARGET)

clean:
	$(RM) *.o $(TARGET)

