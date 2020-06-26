
CFLAGS=-O0 -g -Wall -Wextra -Werror

TARGET=testmain
OBJECTS=testmain.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(CFLAGS) $(OBJECTS) -o $(TARGET)

testmain.o: testmain.c test.h

clean:
	$(RM) *.o $(TARGET)
