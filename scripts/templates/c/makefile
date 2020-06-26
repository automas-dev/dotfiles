
CFLAGS=-O0 -g -Wall -Wextra

TARGET=main
OBJECTS=main.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(CFLAGS) $(OBJECTS) -o $(TARGET)

clean:
	$(RM) *.o $(TARGET)
