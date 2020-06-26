
CFLAGS=-O0 -g -Wall -Wextra
CPPFLAGS=-O0 -g -Wall -Wextra

TARGET=testmain
OBJECTS=testmain.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(CFLAGS) $(OBJECTS) -o $(TARGET)

testmain.o: testmain.cpp test.h

clean:
	$(RM) *.o $(TARGET)
