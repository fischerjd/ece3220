#
#  fmt.mk
#
#  Support for the C/C++ {fmt} formatting library.  {fmt} is an open-source
#  formatting library providing a fast and safe alternative to C stdio and
#  C++ iostreams. See also, https://github.com/fmtlib/fmt
#
#  2022-05-22 Jim Fischer <fischerjd@missouri.edu>
#

ifndef FMT.MK
FMT.MK := 1

LDLIBS   := -lfmt
# NB: If shared object (.so) and archive (.a) libraries are both available,
# and you want to statically link with the archive library, use instead:
# LDLIBS   := -l:libfmt.a

endif # FMT.MK

