# Makefile
# Uses Doxygen to create HTML and PDF documentation from libgpiod's header
# files.
# 2025-Dec-24
# Copyright 2025 James D. Fischer

# This included makefile defines values for these two variables:
#	GPIOD_LIBRARY_NAME
#	GPIOD_LIBRARY_VERSION
include library_version.mk

PDF_MANUAL := $(GPIOD_LIBRARY_NAME)-$(GPIOD_LIBRARY_VERSION).pdf

BUILD_TARGETS := \
	$(PDF_MANUAL) \
	html/index.html

.PHONY: all
all: $(BUILD_TARGETS)

$(PDF_MANUAL): latex/refman.pdf
	$(MAKE) -C latex
	cp latex/refman.pdf "$(PDF_MANUAL)"

latex/refman.pdf: | latex

html/index.html: | html

latex html:
	( cat Doxyfile; echo "PROJECT_NAME = $(GPIOD_LIBRARY_NAME)"; echo "PROJECT_NUMBER = $(GPIOD_LIBRARY_VERSION)" ) | doxygen -

.PHONY: mostly-clean
mostly-clean:
	rm -fr latex

.PHONY: clean
clean: mostly-clean
	rm -fr html "$(PDF_MANUAL)"

