# Makefile

CPP=g++
CPPFLAGS=-Wall -std=c++17 -O0 -g -Igtest/googletest/include -I../include/
TARGET=test_main
OBJECTS=TestsMain.o
LIBS=-Lgtest/lib/ -lgtest -lpthread -L../lib/

SRCDIR=src
OBJDIR=obj

all: build

directories:
	@mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CPP) -c $(CPPFLAGS) $< -o $@

build: directories $(addprefix obj/,$(OBJECTS))
	$(CPP) -o $(TARGET) $(addprefix obj/,$(OBJECTS)) $(LIBS)

clean:
	$(RM) -r $(OBJDIR)/*
	$(RM) $(TARGET)
