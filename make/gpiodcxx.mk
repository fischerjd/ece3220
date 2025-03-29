#
# gpiodcxx.mk
#
# This makefile assumes Makefile variable RPIFS expands to a canonical path
# string that identifies a folder on your Linux desktop onto which the
# Raspberry Pi's file system is already mounted.  The default value for
# RPIFS is '${HOME}/rpifs/'.
#
# HINT: Use the command `mount.rpifs' to mount the Raspberry Pi's file
# system onto folder ${HOME}/rpifs/.
#
# The header files and library files for the gpiodcxx library are installed
# on the Raspberry Pi's file system; they are not available on the desktop
# computer:
#	gpiodcxx header files  > $(RPIFS)/usr/include/gpiodcxx.{h,hpp}
#	gpiodcxx library files > $(RPIFS)/usr/lib/aarch64-linux-gnu/
#
# When cross compiling, your makefile must add these paths to the
# preprocessor's header file search path, and to the linker's library file
# search path.
#
# 2025-03-27 Jim Fischer <fischerjd@missouri.edu>
# Copyright 2025 James D. Fischer
#

ifndef GPIODCXX.MK
GPIODCXX.MK = 1

# The C++ compiler dialect must be C++ 17
CXXFLAGS.dialect := c++17

# To use the gpiodcxx software that's installed in folder /opt/gpiodcxx/x.y.z/, 
# where `x.y.z` is the software version number, create in this makefile a
# variable named GPIODCXX__VERSION whose value is the gpiodcxx version 
# number you want to use, e.g.,
#	
#		GPIODCXX__VERSION := 1.2.3
# 
#GPIODCXX__VERSION := x.y.z

# Cross toolchain configuration
GPIODCXX__BUILD_CPU_ARCH := $(shell lscpu | grep 'Architecture:' | sed 's/Architecture:[[:blank:]]*//')
ifeq (,$(filter $(GPIODCXX__BUILD_CPU_ARCH), armv7l aarch64))
# The build CPU's architecture is not 'armv7l' (32-bit) or 'aarch64'
# (64-bit).  So, assume we're cross compiling on a desktop computer
# AND the root folder '/' of the Raspberry Pi's filesystem is mounted
# onto this folder on the desktop computer: $HOME/rpifs/
GPIODCXX__RPIFS_BASEDIR ?= $(HOME)/rpifs
GPIODCXX__DEFINE_PATH_FLAGS := true
endif

ifdef GPIODCXX__VERSION
GPIODCXX__INCLUDEDIR := $(GPIODCXX__RPIFS_BASEDIR)/opt/gpiodcxx/$(GPIODCXX__VERSION)/usr/include
GPIODCXX__LIBDIR := $(GPIODCXX__RPIFS_BASEDIR)/opt/gpiodcxx/$(GPIODCXX__VERSION)/lib
GPIODCXX__DEFINE_PATH_FLAGS := true
else
GPIODCXX__INCLUDEDIR := $(GPIODCXX__RPIFS_BASEDIR)/usr/include
GPIODCXX__LIBDIR := $(GPIODCXX__RPIFS_BASEDIR)/usr/lib/aarch64-linux-gnu
endif

ifdef GPIODCXX__DEFINE_PATH_FLAGS
CPPFLAGS += -I$(GPIODCXX__INCLUDEDIR)
LDFLAGS += -L$(GPIODCXX__LIBDIR)
endif

## GCC linker/loader (ld) options
# Your program must be linked with this shared object library:
#   * libgpiodcxx.so
#
# This is accomplished via GCC's command line option `-l LIBNAME' (or,
# `-lLIBNAME') where LIBNAME identifies the shared object library file you
# want to link your program with:
#  * libLIBNAME.so
#       ^^^^^^^
#  * libgpiodcxx.so
#       ^^^^^^^^ ----> -lgpiodcxx
#
LDLIBS += -lgpiodcxx

endif # GPIODCXX.MK

