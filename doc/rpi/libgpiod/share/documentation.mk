#
# documentation.mk
# 
# This makefile uses Doxygen to create HTML and PDF documentation for
# libraries 'libgpiod' (C language) and 'libgpiodcxx' (C++ language) from
# the C/C++ source code files in the libgpiod Git repository.
#
# If this makefile is invoked in a folder that contains the source code for
# library 'libgpiod' (the C library), it produces documentation for library
# 'libgpiod'.  Likewise, if this makefile is invoked in a folder that
# contains the source code for library 'libgpiodcxx' (the C++ library), it
# produces documentation for library 'libgpiodcxx'.
#
# 2025-Dec-26
#
# Copyright 2025 James D. Fischer
#

include library_name.mk
include ../library_version.mk

# The file name for the PDF user guide
PDF_USER_GUIDE := $(GPIOD_LIBRARY_NAME)-$(GPIOD_LIBRARY_VERSION).pdf

# This makefile's build targets
BUILD_TARGETS := \
	$(PDF_USER_GUIDE) \
	html/index.html

.PHONY: all
all: $(BUILD_TARGETS)

# If the PDF_USER_GUIDE file exists, assume it is up-to-date. Otherwise,
# create the PDF_USER_GUIDE.
ifeq ("$(wildcard $(PDF_USER_GUIDE))","$(PDF_USER_GUIDE)")
$(PDF_USER_GUIDE): ;
else
$(PDF_USER_GUIDE): latex/refman.pdf
	$(MAKE) -C latex
	cp latex/refman.pdf "$(PDF_USER_GUIDE)"
	$(MAKE) mostly-clean
endif

latex/refman.pdf: | latex

html/index.html: | html

latex html:
	( cat Doxyfile; echo "PROJECT_NAME = $(GPIOD_LIBRARY_NAME)"; echo "PROJECT_NUMBER = $(GPIOD_LIBRARY_VERSION)" ) | doxygen -

.PHONY: mostly-clean
mostly-clean:
	rm -fr latex

.PHONY: clean
clean: mostly-clean
	rm -fr html "$(PDF_USER_GUIDE)"

