# $ECE3220_INSTRUCTOR/share/pthread.mk
# © 2025 James D. Fischer

ifndef MAKEFILE__PTHREAD.MK
MAKEFILE__PTHREAD.MK := 1

# GNU C/C++'s `-pthread' option.  If compiling and linking are performed in
# separate steps, the `-pthread' option needs to be supplied via make's
# CFLAGS, CXXFLAGS, and LDFLAGS variables.
CFLAGS   += -pthread
CXXFLAGS += -pthread
LDFLAGS  += -pthread

endif # MAKEFILE__PTHREAD.MK

