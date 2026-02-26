# $ECE3220_INSTRUCTOR/share/doxygen.mk
# © 2019 James D. Fischer
#
# SYNOPSYS
# 	make { doc | doc-all | doc-html | doc-pdf }
# 	make { doc-clean | clean | distclean | maintainer-clean }
#
# FILES
# 	.Doxyfile.template
# 		If this file is present, it will be used as the Doxyfile template
# 		file.  Otherwise, a default Doxyfile template file is created.
#

ifndef DOXYGEN_MK
DOXYGEN_MK := 1

#==========================================================================
#  Doxyfile configurations
#==========================================================================

ifdef SPECS__DOXYFILE_PROJECT_NAME
DOXYGEN__DOXYFILE_PROJECT_NAME := $(SPECS__DOXYFILE_PROJECT_NAME)
else
DOXYGEN__DOXYFILE_PROJECT_NAME := "demo"
endif

ifdef SPECS__DOXYFILE_PROJECT_BRIEF
DOXYGEN__DOXYFILE_PROJECT_BRIEF := $(SPECS__DOXYFILE_PROJECT_BRIEF)
else
DOXYGEN__DOXYFILE_PROJECT_BRIEF := ECE 3220 COURSEWORK
endif

ifdef SPECS__DOXYFILE__PROJECT_NUMBER
DOXYGEN__DOXYFILE_PROJECT_NUMBER := $(SPECS__DOXYFILE__PROJECT_NUMBER)
else
YEAR_MONTH := $(shell date +"%Y.%m")
DOXYGEN__DOXYFILE_PROJECT_NUMBER := R$(YEAR_MONTH)
endif

ifdef SPECS__DOXYFILE__OUTPUT_DIRECTORY
DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY := $(SPECS__DOXYFILE__OUTPUT_DIRECTORY)
else
DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY := ./doxygen/
endif

# If DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY is defined, ensure that path string
# ends with '/'.
ifdef DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY
DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY := $(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY:/=)/
endif

# The path to file Doxyfile
ifdef SPECS__DOXYFILE
DOXYGEN__DOXYFILE := $(SPECS__DOXYFILE)
else
DOXYGEN__DOXYFILE := Doxyfile
endif


#==========================================================================
#  Makefile stuff
#==========================================================================

DOXYGEN__BUILD_PREREQS := $(sort \
	$(DOXYGEN__DOXYFILE) \
	$(SOURCES) \
	$(HEADERS) \
	)

DOXYGEN__HTML_BUILD_DIR := $(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)html
DOXYGEN__HTML_BUILD_PREREQS := $(DOXYGEN__BUILD_PREREQS)
DOXYGEN__HTML_BUILD_TARGET := $(DOXYGEN__HTML_BUILD_DIR)/index.html

DOXYGEN__PDF_BUILD_DIR := $(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)latex
DOXYGEN__PDF_BUILD_PREREQS := $(sort \
	$(DOXYGEN__BUILD_PREREQS) \
	$(DOXYGEN__HTML_BUILD_TARGET) \
	)
DOXYGEN__PDF_BUILD_TARGET := $(DOXYGEN__PDF_BUILD_DIR)/refman.pdf

DOXYGEN__DOXYFILE_TEMPLATE := .Doxyfile.template


#==========================================================================
#  Make Targets
#==========================================================================

# Create the documentation in all output formats (html and pdf)
.PHONY: doc-all
doc-all: doc-html doc-pdf

# Create the documentation in HTML format
.PHONY: doc doc-html
doc doc-html: $(DOXYGEN__HTML_BUILD_TARGET)

$(DOXYGEN__HTML_BUILD_TARGET): $(DOXYGEN__HTML_BUILD_PREREQS)
	doxygen
	touch "$@"

# Create the documentation in PDF format
.PHONY: doc-pdf
doc-pdf: $(DOXYGEN__PDF_BUILD_TARGET)

$(DOXYGEN__PDF_BUILD_TARGET): $(DOXYGEN__PDF_BUILD_PREREQS)
	$(MAKE) -C "$(DOXYGEN__PDF_BUILD_DIR)" pdf

# Create file 'Doxyfile'
$(DOXYGEN__DOXYFILE): $(DOXYGEN__DOXYFILE_TEMPLATE)
	/usr/bin/cp -fv "$<" "$@"
	doxygen -u "$@"
	-@rm -f $@.bak
	sed -i \
		-e '/^[[:blank:]]*PROJECT_NAME[[:blank:]]*=/Ic\PROJECT_NAME = $(DOXYGEN__DOXYFILE_PROJECT_NAME)' \
		-e '/^[[:blank:]]*PROJECT_BRIEF[[:blank:]]*=/Ic\PROJECT_BRIEF = $(DOXYGEN__DOXYFILE_PROJECT_BRIEF)' \
		-e '/^[[:blank:]]*PROJECT_NUMBER[[:blank:]]*=/Ic\PROJECT_NUMBER = $(DOXYGEN__DOXYFILE_PROJECT_NUMBER)' \
		-e '/^[[:blank:]]*OUTPUT_DIRECTORY[[:blank:]]*=/Ic\OUTPUT_DIRECTORY = $(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)' \
		$@

$(DOXYGEN__DOXYFILE_TEMPLATE):
	doxygen -g "$@"

$(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY):
	if [ -n "$(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)" ] && [ "$(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)" != '.' ]; then \
		if /usr/bin/realpath $@ | /usr/bin/grep -q $$(/usr/bin/realpath .); then \
			/usr/bin/mkdir -p $(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY); \
		else \
			2>&1 echo ":: ERROR :: Document directory '$(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)' must reside within the current working directory."; \
			exit 1; \
		fi; \
	fi

# House cleaning
.PHONY: doc-clean
doc-clean::
	@rm -f Doxyfile.bak
	@$(call remove_folder,$(DOXYGEN__HTML_BUILD_DIR))
	@$(call remove_folder,$(DOXYGEN__PDF_BUILD_DIR))
	@if [ -d "$(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)" ]; then \
		$(call remove_folder,$(DOXYGEN__DOXYFILE_OUTPUT_DIRECTORY)); \
	fi

.PHONY: clean
clean:: doc-clean

.PHONY: distclean
distclean:: clean
	@rm -fv Doxyfile

.PHONY: maintainer-clean
maintainer-clean:: distclean

endif # DOXYGEN_MK

