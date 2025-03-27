# gpiodcxx.mk
# Copyright 2025 James D. Fischer
#
# This makefile assumes Makefile variable RPIFS expands to a canonical path
# string that identifies a folder on your Linux desktop onto which the
# Raspberry Pi's file system is already mounted.  The default value for
# RPIFS is '${HOME}/rpifs/'.
#
# HINT: Use the command `mount.rpifs' to mount the Raspberry Pi's file
# system onto folder ${HOME}/rpifs/.
#
# The header files and library files for the gpiod library are installed on
# the Raspberry Pi's file system; they are not available on the desktop
# computer:
#	gpiod header files  > $(RPIFS)/usr/include/gpiod.{h,hpp}
#	gpiod library files > $(RPIFS)/usr/lib/aarch64-linux-gnu/
#
# When cross compiling, your makefile must add these paths to the
# preprocessor's header file search path, and to the linker's library file
# search path.
#

ifndef GPIODCXX.MK
GPIODCXX.MK = 1

# The C++ compiler dialect must be C++ 17
CXXFLAGS.dialect := c++17

GPIOD__INCLUDEDIR := /usr/include
GPIOD__LIBDIR := /usr/lib/aarch64-linux-gnu

# Cross toolchain configuration
GPIOD__BUILD_CPU_ARCH := $(shell lscpu | grep 'Architecture:' | sed 's/Architecture:[[:blank:]]*//')
ifeq (,$(filter $(GPIOD__BUILD_CPU_ARCH), armv7l aarch64))
	# The build CPU's architecture is not 'armv7l' (32-bit) or 'aarch64'
	# (64-bit).  So, assume we're cross compiling on a desktop computer
	# AND the root folder '/' of the Raspberry Pi's filesystem is mounted
	# onto this folder: $HOME/rpifs/
	RPIFS ?= $(HOME)/rpifs

	# The path(s) to the gpiod library's header files on the Raspberry
	# Pi's file system.
	GPIOD__INCLUDEDIR := $(RPIFS)$(GPIOD__INCLUDEDIR)
	CPPFLAGS += -I$(GPIOD__INCLUDEDIR)

	# The path(s) to the gpiod library's library files on the Raspberry
	# Pi's file system.
	GPIOD__LIBDIR := $(RPIFS)$(GPIOD__LIBDIR)
	LDFLAGS += -L$(GPIOD__LIBDIR)
endif

## GCC linker/loader (ld) options
# Your program must be linked with this shared object library:
#   * /usr/lib/aarch64-linux-gnu/libgpiod.so
#
# This is accomplished via GCC's command line option `-l LIBNAME' (or,
# `-lLIBNAME') where LIBNAME identifies the shared object library file you
# want to link your program with:
#  * /usr/lib/libLIBNAME.so
#                ^^^^^^^
#  * /usr/lib/aarch64-linux-gnu/libgpiod.so
#                                  ^^^^^ ----> -lgpiod
#
LDLIBS += -lgpiodcxx

endif # GPIODCXX.MK

