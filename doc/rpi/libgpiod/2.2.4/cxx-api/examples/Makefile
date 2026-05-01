# Makefile
# gpiod version 2.2
# C++ Program Examples
# © 2026 James D. Fischer

GPIOD_VERSION := 2.2

GPIOD_PREFIX := /opt/libgpiod/$(GPIOD_VERSION)
GPIOD_INCLUDEDIR := $(GPIOD_PREFIX)/include
GPIOD_LIBDIR := $(GPIOD_PREFIX)/lib

SOURCES := $(wildcard *.cpp)
PROGRAMS := $(SOURCES:%.cpp=%)

CPPFLAGS := -D_GNU_SOURCE -I$(GPIOD_INCLUDEDIR)
CXXFLAGS := -O0 -ggdb -std=c++17
LDFLAGS := -L$(GPIOD_LIBDIR)
LDLIBS := -lgpiodcxx

.PHONY: all
all: $(PROGRAMS)

%: %.cpp
	$(LINK.cpp) $^ $(LOADLIBES) $(LDLIBS) -o $@

.PHONY: clean
clean:
	rm -f *.o $(PROGRAMS)

