
CFLAGS=-fPIC -O0 -g -Wall -Wextra -Werror

TARGET=libname.a
OBJECTS=name.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(AR) rcs $(TARGET) $(OBJECTS)

clean:
	$(RM) *.o $(TARGET)

