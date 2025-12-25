# bindings-dirs.mk
# Builds the documentation in the supported language binding folders.
# 2025-Dec-24
# Copyright 2025 James D. Fischer

BINDING_DIRS := \
	c-api \
	cxx-api

.PHONY: all
all: $(BINDING_DIRS)

$(BINDING_DIRS): FORCE
		$(MAKE) -C "$@"

.PHONY: clean mostly-clean
clean mostly-clean:
	for dir in $(BINDING_DIRS); do $(MAKE) -C "$$dir" $@; done

.PHONY: FORCE
FORCE:

