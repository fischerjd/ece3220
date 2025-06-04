#
# save-gcc-temps.mk
#
# Copyright 2025 James D. Fischer
#

ifndef SAVE_GCC_TEMPS.MK
SAVE_GCC_TEMPS.MK := 1

GCC_TEMPS.c.i := $(SOURCES.c:%=$(BUILDDIR)%.i)
GCC_TEMPS.c.s := $(SOURCES.c:%=$(BUILDDIR)%.s)

GCC_TEMPS.cc.ii := $(SOURCES.cc:%=$(BUILDDIR)%.ii)
GCC_TEMPS.cc.s := $(SOURCES.cc:%=$(BUILDDIR)%.s)

GCC_TEMPS.cpp.ii := $(SOURCES.cpp:%=$(BUILDDIR)%.ii)
GCC_TEMPS.cpp.s := $(SOURCES.cpp:%=$(BUILDDIR)%.s)

GCC_TEMPS.cxx.ii := $(SOURCES.cxx:%=$(BUILDDIR)%.ii)
GCC_TEMPS.cxx.s := $(SOURCES.cxx:%=$(BUILDDIR)%.s)

GCC_TEMPS.i := $(GCC_TEMPS.c.i)
GCC_TEMPS.ii := $(GCC_TEMPS.cc.ii) $(GCC_TEMPS.cpp.ii) $(GCC_TEMPS.cxx.ii)
GCC_TEMPS.s := $(GCC_TEMPS.c.s) $(GCC_TEMPS.cc.s) $(GCC_TEMPS.cpp.s) $(GCC_TEMPS.cxx.s)
GCC_TEMPS := $(GCC_TEMPS.i) $(GCC_TEMPS.ii) $(GCC_TEMPS.s)

CFLAGS += -save-temps
CXXFLAGS += -save-temps

.PHONY: _basic_clean
_basic_clean::
	@rm -fv $(GCC_TEMPS)

endif # SAVE_GCC_TEMPS.MK

