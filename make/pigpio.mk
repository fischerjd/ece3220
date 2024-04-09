# pigpio.mk
# Copyright 2024 James D. Fischer
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

ifndef PIGPIO.MK
PIGPIO.MK = 1

PIGPIO__BUILD_CPU_ARCH := $(shell lscpu | grep 'Architecture:' | sed 's/Architecture:[[:blank:]]*//')
ifneq ($(PIGPIO__BUILD_CPU_ARCH),armv7l)
	# The build CPU's architecture is not 'armv7l'; therefore, assume we're
	# cross compiling on a desktop computer, AND the root folder '/' of the
	# Raspberry Pi's filesystem is mounted onto this folder: $HOME/rpifs/
	RPIFS ?= $(HOME)/rpifs

	# The path(s) to the pigpio library's header files on the Raspberry
	# Pi's file system.  See also the compiler option `-pthread'.
	CPPFLAGS += -I$(RPIFS)/usr/include

	# The path(s) to the pigpio library's library files on the Raspberry
	# Pi's file system.
	LDFLAGS += -L$(RPIFS)/usr/lib
endif

## GCC linker/loader (ld) options
# Your program must be linked with these shared object libraries:
#   * /usr/lib/libpigpio.so
#   * /usr/lib/librt.so
# (See: https://abyz.me.uk/rpi/pigpio/cif.html)
#
# This is accomplished via GCC's command line option `-l LIBNAME' (or,
# `-lLIBNAME') where LIBNAME identifies the shared object library file you
# want to link your program with:
#  * /usr/lib/libLIBNAME.so
#                 ^^^^^^^
#  * /usr/lib/libpigpio.so
#                ^^^^^^ ----> -lpigpio
#  * /usr/lib/librt.so
#                ^^---------> -lrt
#
LDLIBS += -lpigpio -lrt

# The pigpio library requires Linux pthreads support. Ensure makefile
# 'pthread.mk' is present in the same directory as this makefile.
ifneq (,$(wildcard pthread.mk))
include pthread.mk
endif

endif # PIGPIO.MK

