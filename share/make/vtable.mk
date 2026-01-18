#
#  vtable.mk
#
#  Produces an output file in folder BUILDDIR that contains a dump of the
#  translation unit's class hierarchy information, including information
#  about each class's virtual function lookup table (vtable).
#
#  2025-04-04 Jim Fischer <fischerjd@missouri.edu>
#  Copyright 2024,2025 James D. Fischer
#

ifndef VTABLE.MK
VTABLE.MK := 1

CXXFLAGS += -fdump-lang-class

.PHONY: clean
clean:: ; @rm -fv "$(BUILDDIR)"*.class

endif # VTABLE.MK

