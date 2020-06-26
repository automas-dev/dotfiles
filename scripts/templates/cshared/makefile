
CFLAGS=-fPIC -O0 -g -Wall -Wextra -Werror
LDFLAGS=-shared 

TARGET=libname.so
OBJECTS=name.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET) 

clean:
	$(RM) *.o $(TARGET)

