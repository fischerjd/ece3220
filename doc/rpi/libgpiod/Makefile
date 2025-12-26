# Makefile
# Builds the documentation in the specified version directories.
# 2025-Dec-24
# Copyright 2025 James D. Fischer

VERSIONS := \
	1.6.3 \
	2.2.1

.PHONY: all
all: $(VERSIONS)
	$(MAKE) mostly-clean

$(VERSIONS): FORCE
		$(MAKE) -C $@

.PHONY: clean mostly-clean
clean mostly-clean: $(VERSIONS)

.PHONY: FORCE
FORCE:

