ifndef ADDRESS_SANITIZER.MK
ADDRESS_SANITIZER.MK := 1

# References:
# [1] https://youtu.be/tEbV21aPSKw
# [2] https://github.com/google/sanitizers/issues/679

CFLAGS := -fsanitize=address
CXXFLAGS := -fsanitize=address
LDFLAGS := -fsanitize=address -static-libasan

endif # ADDRESS_SANITIZER.MK

