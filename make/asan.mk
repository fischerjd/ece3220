#
# asan.mk
#
# [Note 1:  The setup shown below uses static linking when linking the asan
# library with your program. This is being done because it solves some
# problems that sometimes occur when using dynamic linking. If you want to
# use dynamic linking instead of static linking, remove the GCC flag
# `-static-libasan`.  You might also need to define and use the environment
# variable LD_PRELOAD to manually load the asan library before other
# libraries are loaded, e.g., 
#   $ LD_PRELOAD=/lib/arm-linux-gnueabihf/libasan.so.6 ./demo
# or
# 	$ export LD_PRELOAD=/lib/arm-linux-gnueabihf/libasan.so.6
# 	$ ./demo
# See also: https://github.com/google/sanitizers/issues/679
# --end note]
#
# Copyright 2025 James D. Fischer
#

ifndef ADDRESS_SANITIZER.MK
ADDRESS_SANITIZER.MK := 1

# References:
# [1] https://youtu.be/tEbV21aPSKw
# [2] https://github.com/google/sanitizers/issues/679

CFLAGS := -fsanitize=address
CXXFLAGS := -fsanitize=address
LDFLAGS := -fsanitize=address -static-libasan

endif # ADDRESS_SANITIZER.MK

