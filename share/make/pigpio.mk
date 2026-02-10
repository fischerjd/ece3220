#
# pigpio.mk
#
# This makefile assumes Makefile variable RPIFS expands to a canonical path
# string that identifies a folder on your Linux desktop onto which the
# Raspberry Pi's file system is already mounted.  The default value for
# RPIFS is '${HOME}/rpifs/'.
#
# HINT: Use the command `mount.rpifs' to mount the Raspberry Pi's file
# system onto folder ${HOME}/rpifs/.
#
# The pigpio library's header files and library files are installed on
# the Raspberry Pi's file system; they are not available on the desktop
# computer:
#	pigpio header files  > $(RPIFS)/usr/include/
#	pigpio library files > $(RPIFS)/usr/lib/
#
# When cross compiling, your makefile must add these paths to the
# preprocessor's header file search path, and to the linker's library file
# search path.
#
# Copyright 2024,2025 James D. Fischer
#

ifndef PIGPIO.MK
PIGPIO.MK := 1

PIGPIO__BUILD_CPU_ARCH := $(shell lscpu | grep 'Architecture:' | sed 's/Architecture:[[:blank:]]*//')
ifeq (,$(filter $(PIGPIO__BUILD_CPU_ARCH), armv7l aarch64))
# The build CPU's architecture is not 'armv7l'; therefore, assume we're
# cross compiling on a desktop computer, AND the root folder '/' of the
# Raspberry Pi's filesystem is mounted onto this folder: $HOME/rpifs/
PIGPIO__RPIFS ?= $(HOME)/rpifs
PIGPIO__DEFINE_PATH_FLAGS := true
endif

PIGPIO__INCLUDEDIR := $(PIGPIO__RPIFS_BASEDIR)/usr/include
PIGPIO__LIBDIR := $(PIGPIO__RPIFS_BASEDIR)/usr/lib/aarch64-linux-gnu

ifdef PIGPIO__DEFINE_PATH_FLAGS
CPPFLAGS += -I$(PIGPIO__INCLUDEDIR)
LDFLAGS += -L$(PIGPIO__LIBDIR)
endif

## GCC linker/loader (ld) options
# Your program must be linked with these shared object libraries:
#   * libpigpio.so
#   * librt.so
# (See: https://abyz.me.uk/rpi/pigpio/cif.html)
#
# This is accomplished via GCC's command line option `-l LIBNAME' (or,
# `-lLIBNAME') where LIBNAME identifies the shared object library file you
# want to link your program with:
#  * libLIBNAME.so
#       ^^^^^^^
#  * libpigpio.so
#       ^^^^^^ ----> -lpigpio
#  * librt.so
#       ^^---------> -lrt
#
LDLIBS += -lpigpio -lrt

# The pigpio library requires Linux pthreads support. Ensure makefile
# 'pthread.mk' is present in the same directory as this makefile.
ifeq (,$(wildcard pthread.mk))
$(error Required makefile 'pthread.mk' is missing.)
endif
include pthread.mk

endif # PIGPIO.MK

