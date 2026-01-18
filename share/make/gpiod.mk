#
# gpiod.mk
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
# 2026-01-04 Jim Fischer <fischerjd@missouri.edu>
# © 2025 James D. Fischer
#

ifndef GPIOD.MK
GPIOD.MK = 1

# The C compiler dialect must be C 17
CFLAGS.dialect := c17

# To use the gpiod software that's installed in folder /opt/gpiod/x.y.z/, 
# where `x.y.z` is the software version number, create in this makefile a
# variable named GPIOD__VERSION whose value is the gpiodcxx version 
# number you want to use, e.g.,
#
#		GPIOD__VERSION := x.y.z
# 
#GPIOD__VERSION := x.y.z
#GPIOD__VERSION := 1.6.3
GPIOD__VERSION := 2.2.2


# Cross toolchain configuration
GPIOD__BUILD_CPU_ARCH := $(shell lscpu | grep 'Architecture:' | sed 's/Architecture:[[:blank:]]*//')
ifeq (,$(filter $(GPIOD__BUILD_CPU_ARCH), armv7l aarch64))
# The build CPU's architecture is not 'armv7l' (32-bit) or 'aarch64'
# (64-bit).  So, assume we're cross compiling on a desktop computer
# AND the root folder '/' of the Raspberry Pi's filesystem is mounted
# onto this folder on the desktop computer: $HOME/rpifs/
GPIOD__RPIFS_BASEDIR ?= $(HOME)/rpifs
GPIOD__DEFINE_PATH_FLAGS := true
endif

# Default paths
GPIOD__INCLUDEDIR := $(GPIOD__RPIFS_BASEDIR)/usr/include
GPIOD__LIBDIR := $(GPIOD__RPIFS_BASEDIR)/usr/lib/aarch64-linux-gnu

# Version-specific paths
ifdef GPIOD__VERSION
GPIOD__VERSION_DIR := $(GPIOD__RPIFS_BASEDIR)/opt/gpiod/$(GPIOD__VERSION)
ifneq ($(wildcard $(GPIOD__VERSION_DIR)/.),)
GPIOD__INCLUDEDIR := $(GPIOD__VERSION_DIR)/include
GPIOD__LIBDIR := $(GPIOD__VERSION_DIR)/lib
GPIOD__DEFINE_PATH_FLAGS := true
endif
endif

ifdef GPIOD__DEFINE_PATH_FLAGS
CPPFLAGS += -isystem $(GPIOD__INCLUDEDIR)
LDFLAGS += -L$(GPIOD__LIBDIR)
endif

## GCC linker/loader (ld) options
# Your program must be linked with this shared object library:
#   * libgpiod.so
#
# This is accomplished via GCC's command line option `-l LIBNAME' (or,
# `-lLIBNAME') where LIBNAME identifies the shared object library file you
# want to link your program with:
#  * libLIBNAME.so
#       ^^^^^^^
#  * libgpiod.so
#       ^^^^^ ----> -lgpiod
#
LDLIBS.custom += -lgpiod

endif # GPIOD.MK

