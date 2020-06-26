
CFLAGS=-O0 -g -fPIC -Wall -Wextra -Werror
LDFLAGS=-shared

TARGET=libname
OBJECTS=name.o

all: static shared
static:	$(TARGET).a
shared: $(TARGET).so

$(TARGET).a: $(OBJECTS)
	$(AR) rcs $(TARGET).a $(OBJECTS)

$(TARGET).so: $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET).so

clean:
	$(RM) *.o $(TARGET).a $(TARGET).so

