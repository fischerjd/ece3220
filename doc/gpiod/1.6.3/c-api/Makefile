
GPIOD_LIBRARY := libgpiod

GPIOD_VERSION := 1.6.3

BUILD_TARGETS := \
	refman.pdf \
	html/index.html

.PHONY: all
all: $(BUILD_TARGETS)

refman.pdf: latex/refman.pdf
	$(MAKE) -C latex
	cp latex/refman.pdf .

latex/refman.pdf: | latex

html/index.html: | html

latex html:
	( cat Doxyfile; echo "PROJECT_NAME = $(GPIOD_LIBRARY)"; echo "PROJECT_NUMBER = $(GPIOD_VERSION)" ) | doxygen -

.PHONY: mostly-clean
mostly-clean:
	rm -fr latex

.PHONY: clean
clean: mostly-clean
	rm -fr html refman.pdf

