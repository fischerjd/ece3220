#
# wiringPi.mk
#
# When building with a cross toolchain, the toolchain requires access to
# the wiringPi header files and library files which are installed on the
# RPI's filesystem. The easiest way to manage this is to mount the root
# directory '/' of the RPI's filesystem onto any convenient folder within
# the local computer's filesystem--e.g., ${HOME}/rpifs/--prior to invoking
# `make'. Define a makefile variable `WIRINGPI__RPIFS_BASEDIR' whose value
# is the path to the folder on the local filesystem where you've mounted
# the RPS's filesystem (the "mount point").
#
# Depending on how the wiringPi software was installed, the wiringPi header
# files and library files are (typically) located in one of two locations:
#
# 	/usr/include
# 	/usr/lib
#
# 	OR
#
# 	/usr/local/include
# 	/usr/local/lib
#
# If the wiringPi header files and libraries are found in folders
# /usr/local/include and /usr/local/lib, respectively, this makefile uses
# those headers/libraries (PREFIX:=/usr/local); otherwise, this makefile
# uses the header files and libraries found in folders /usr/include and
# /usr/lib (PREFIX:=/usr).
#
# Within this Makefile, prepend the variable WIRINGPI__RPIFS_BASEDIR onto
# any path string that defines the path to a folder within the RPI's
# filesystem that contains the wiringPi header files or library files:
#
#	wiringPi header files  > $(WIRINGPI__RPIFS_BASEDIR)$(PREFIX)/include/
#	wiringPi library files > $(WIRINGPI__RPIFS_BASEDIR)$(PREFIX)/lib/
#
# where PREFIX is either '/usr/local' or '/usr', as described above. Note
# that when building with the RPI's native toolchain, the variable
# WIRINGPI__RPIFS_BASEDIR must be undefined so that it expands to the empty
# string:
#
# BUILDING WITH A CROSS C/C++             BUILDING WITH THE NATIVE C/C++
# TOOLCHAIN ON A DESKTOP COMPUTER         TOOLCHAIN ON THE RASPBERRY PI
# WIRINGPI__RPIFS_BASEDIR:=${HOME}/ripfs  WIRINGPI__RPIFS_BASEDIR:=
# ===================================     ===================
# ${HOME}/rpifs$(PREFIX)/include          $(PREFIX)/include
# ${HOME}/rpifs$(PREFIX)/lib              $(PREFIX)/lib
#
# Copyright 2019-2025 James D. Fischer
#

ifndef WIRINGPI.MK
WIRINGPI.MK := 1

WIRINGPI__BUILD_CPU_ARCH := $(shell lscpu | grep 'Architecture:' | sed 's/Architecture:[[:blank:]]*//')
ifneq ($(WIRINGPI__BUILD_CPU_ARCH),armv7l)
	# The build CPU's architecture is not 'armv7l'; therefore, assume we're
	# cross compiling on a desktop computer, AND the root folder '/' of the
	# Raspberry Pi's filesystem is mounted onto this folder: $HOME/rpifs/
	WIRINGPI__RPIFS_BASEDIR ?= $(HOME)/rpifs
	WIRINGPI__DEFINE_PATH_FLAGS := true
endif

# Search for `wiringPi.h'. (NB: Assume library file `libwiringPi.so' is
# installed in the same directory tree as `wiringPi.h'.)
ifneq (,$(wildcard $(WIRINGPI__RPIFS_BASEDIR)/usr/include/wiringPi.h))
WIRINGPI__INCLUDEDIR += $(WIRINGPI__RPIFS_BASEDIR)/usr/include
WIRINGPI__LIBDIR += $(WIRINGPI__RPIFS_BASEDIR)/usr/lib
else ifneq (,$(wildcard $(WIRINGPI__RPIFS_BASEDIR)/usr/local/include/wiringPi.h))
WIRINGPI__INCLUDEDIR += $(WIRINGPI__RPIFS_BASEDIR)/usr/local/include
WIRINGPI__LIBDIR += $(WIRINGPI__RPIFS_BASEDIR)/usr/local/lib
WIRINGPI__DEFINE_PATH_FLAGS := true
else
$(error Failed to find header file `wiringPi.h')
endif
endif

ifdef WIRINGPI__DEFINE_PATH_FLAGS
CPPFLAGS += -I$(WIRINGPI__INCLUDEDIR)
LDFLAGS += -L$(WIRINGPI__LIBDIR)
endif

# GCC linker/loader (ld) options
# Your program must be linked with this shared object library:
#   * libwiringpi.so
#
# This is accomplished via GCC's command line option `-l LIBNAME' (or,
# `-lLIBNAME') where LIBNAME identifies the shared object library file you
# want to link your program with:
#  * libLIBNAME.so
#       ^^^^^^^
#  * libwiringpi.so
#       ^^^^^ ----> -lwiringpi
#
LDLIBS += -lwiringPi

# The wiringPi library requires Linux pthreads support.  Ensure makefile
# 'pthread.mk' is present in this folder.
ifneq (,$(wildcard pthread.mk))
include pthread.mk
endif

endif # WIRINGPI.MK

