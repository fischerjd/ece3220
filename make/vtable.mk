#
#  vtable.mk
#
#  Produces an output file in folder BUILDDIR that contains a dump of the
#  translation unit's class hierarchy information, including information
#  about each class's virtual function lookup table (vtable).
#
#  2024-04-10 Jim Fischer <fischerjd@missouri.edu>
#

ifndef VTABLE.MK
VTABLE.MK := 1

CXXFLAGS += -fdump-lang-class

.PHONY: clean
clean:: ; -rm -f "$(BUILDDIR)"*.class

endif # VTABLE.MK

