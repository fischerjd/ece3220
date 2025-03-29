#
#  pthread.mk
#
#  2025-03-29 Jim Fischer <fischerjd@missouri.edu>
#  Copyright 2019,2025 James D. Fischer
#

ifndef PTHREAD.MK
PTHREAD.MK := 1

# GNU C/C++'s `-pthread' option.  If compiling and linking are performed in
# separate steps, the `-pthread' option needs to be supplied via make's
# CFLAGS, CXXFLAGS, and LDFLAGS variables.
CFLAGS   += -pthread
CXXFLAGS += -pthread
LDFLAGS  += -pthread

endif # PTHREAD.MK

