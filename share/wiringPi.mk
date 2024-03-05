# wiringPi.mk
# Copyright 2019-2021 James D. Fischer.  All rights reserved.
#
# This makefile assumes variable RPIFS expands to a path string that
# defines the folder onto which the Raspberry Pi's file system is already
# mounted.  The default value for RPIFS is '$(HOME)/rpifs'.
#
# The wiringPi library's header files and library files are installed on
# the Raspberry Pi's file system; they are not available on the desktop
# computer:
#	wiringPi header files  > $(RPIFS)/usr/include
#	wiringPi header files  > $(RPIFS)/usr/include/arm-linux-gnuabiehf
#	wiringPi library files > $(RPIFS)/usr/lib
#
# When cross compiling, this makefile must add these paths to the
# preprocessor's header file search path, and to the linker's library file
# search path.
#

ifndef WIRINGPI.MK
WIRINGPI.MK = 1

WIRINGPI__BUILD_CPU_ARCH := $(shell lscpu | grep 'Architecture:' | sed 's/Architecture:[[:blank:]]*//')
ifneq ($(WIRINGPI__BUILD_CPU_ARCH),armv7l)
	# The build CPU's architecture is not 'armv7l'; therefore, assume we're
	# cross compiling on a desktop computer, AND the root folder '/' of the
	# Raspberry Pi's filesystem is mounted onto this folder: $HOME/rpifs/
	RPIFS ?= $(HOME)/rpifs

	# The path(s) to the wiringPi library's header files on the Raspberry
	# Pi's file system.  See also the compiler option `-pthread'.
	CPPFLAGS += \
		-I$(RPIFS)/usr/include/arm-linux-gnueabihf \
		-I$(RPIFS)/usr/include \

	# The path(s) to the wiringPi library's library files on the Raspberry
	# Pi's file system.
	LDFLAGS += -L$(RPIFS)/usr/lib
endif

# GCC linker/loader (ld) options
# -l Specify the name of the library we want to link our program to.  The
#  wiringPi library's file name is `libwiringPi.so'; therefore, the
#  library's name is `wiringPi' (strip off the `lib' prefix and the `.so*'
#  suffix).
# See also the compiler option `-pthread'.
LDLIBS += -lwiringPi

# The wiringPi library requires Linux pthreads support
ifneq (,$(wildcard pthread.mk))
include pthread.mk
endif

endif # WIRINGPI.MK

