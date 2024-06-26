# Makefile
# Copyright 2019-2024 James D. Fischer
#
# SYNOPSYS
#   make {all|debug}
#   make release
#   make {clean|distclean|mostly-clean|maintainer-clean}
#   make strip
#   make vars
#
# DESCRIPTION
#   This Makeifle creates an executable program named `demo'. See also the
#   variable `PROGRAM_NAME' at various places in this Makefile.
#
#   The default build goal is the target `all'.  By default, the `all'
#   target performs `make debug' which produces an executable program that
#   contains instrumentation code that facilitates debugging when using the
#   GNU debugger (gdb). See also "16.6 Standard Targets for Users" in the
#   GNU Make manual which states, "By default, the Make rules should
#   compile and link with '-g', so that executable programs have debugging
#   symbols." (NB: This Makefile compiles and links with '-ggdb'.)
#   https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html
#

# The default C/C++ compilers.
# NB: This makefile assumes the build is performed using (a) the GNU
# Compiler Collection (GCC) or (b) a toolchain that is a drop-in
# replacement for GCC.
# Examples: gcc/g++, or clang/clang++, etc.
# NB: Variable `CPP' is defined later in this makefile.
CC    := gcc
CXX   := g++
STRIP := strip


# [Optional]  To build this project with a toolchain other than the default
# toolchain that Make uses, create within the current working directory a
# makefile named `toolchain.mk' and within it define (at a minimum) the
# variables AR, CC, CXX, and LD.
# For example,
#    AR  := /opt/cross/gcc-10.2.1/arm-linux-gnueabihf/bin/ar
#    CC  := /opt/cross/gcc-10.2.1/arm-linux-gnueabihf/bin/gcc
#    CXX := /opt/cross/gcc-10.2.1/arm-linux-gnueabihf/bin/g++
#    LD  := /opt/cross/gcc-10.2.1/arm-linux-gnueabihf/bin/ld
ifneq ($(wildcard toolchain.mk),)
include toolchain.mk
endif


# [Optional]  Create a makefile named `specs.mk' that provides
# program-specific specifications for this build--e.g., define
# SPECS__PROGRAM_NAME with the desired program name; provide version
# information, build directory, dependency directory name and path, 
# and so on. 
ifneq ($(wildcard specs.mk),)
include specs.mk
endif


# Specify the file name for the program to be created.
ifeq (,$(PROGRAM_NAME))
ifneq (,$(SPECS__PROGRAM_NAME))
PROGRAM_NAME := $(SPECS__PROGRAM_NAME)
else
PROGRAM_NAME ?= demo
endif
endif


# Two build modes are available: debug and release.  The default build mode
# is 'debug'.
# 
# Here are some options for selecting the 'release' build mode:
#
#   # Option 1.  One time release build.
#   $ make release
#
#   # Option 2.  One time release build.
#   $ RELEASE=1 make
#
#   # Option 3.  Performs release builds until the shell environment
#   #            variable RELEASE is unset.
#   $ export RELEASE=1
#   $ make
#
# Note that if the variable RELEASE is defined and set in the command shell
# environment, invoking any make goals other than 'release' or the various
# "clean" goals yields undefined behavior.
#
ifeq ($(origin RELEASE),environment)
# See options 2 and 3 above
BUILD_TYPE := release
else
BUILD_TYPE := debug
endif


# [Optional]  Create a makefile named 'override.mk' that provides
# alternate definitions for the variables in this makefile that are defined
# via deferred conditional assignment, e.g.,
# 	BUILDDIR := xyz
ifneq ($(wildcard override.mk),)
include override.mk
endif


# BUILDDIR is the destination folder for all build products--e.g., object
# code files (%.o), dependency files (%.Td, %.d), precompiled headers
# (%.gch), etc.
#
BUILDDIR ?= build

# If BUILDDIR is defined, ensure BUILDDIR's path string ends with '/'.
ifdef BUILDDIR
BUILDDIR := $(BUILDDIR:/=)/
endif


# DEPDIR is the folder that contains the automatically-generated dependency
# files (%.Td, %.d). Each object file (%.o) has an associated dependency
# file within folder DEPDIR--e.g.,
#    foo.o -> $(DEPDIR)foo.d
# By default, DEPDIR is a subdirectory within BUILDDIR:
# $(BUILDDIR)
#  `-- $(DEPDIR)
#
DEPDIR_NAME ?= deps
DEPDIR := $(BUILDDIR)$(DEPDIR_NAME)

# If DEPDIR is defined, ensure DEPDIR's path string ends with '/'.
ifdef DEPDIR
DEPDIR := $(DEPDIR:/=)/
endif


# Use make's `$(wildcard ...)' function to find all C source files (%.c) in
# the current working directory.  Next, use a substitution reference to
# generate the list of C object files (%.o) to be created from the list of
# C source code files, as well as the list of dependency files (%.d). Ditto
# for C++ source code files: %.cc, %.cpp, %.cxx, etc.. (See also make's
# `patsubst' function.)
#
SOURCES.c := $(wildcard *.c)
OBJS.c    := $(SOURCES.c:%.c=$(BUILDDIR)%.o)
DEPS.c    := $(SOURCES.c:%.c=$(DEPDIR)%.d)

SOURCES.cc := $(wildcard *.cc)
OBJS.cc   := $(SOURCES.cc:%.cc=$(BUILDDIR)%.o)
DEPS.cc   := $(SOURCES.cc:%.cc=$(DEPDIR)%.d)

SOURCES.cpp := $(wildcard *.cpp)
OBJS.cpp  := $(SOURCES.cpp:%.cpp=$(BUILDDIR)%.o)
DEPS.cpp  := $(SOURCES.cpp:%.cpp=$(DEPDIR)%.d)

SOURCES.cxx := $(wildcard *.cxx)
OBJS.cxx  := $(SOURCES.cxx:%.cxx=$(BUILDDIR)%.o)
DEPS.cxx  := $(SOURCES.cxx:%.cxx=$(DEPDIR)%.d)

# Dependency file created by Microsoft Visual Studio Code
DEPS.vscode := null.d

# Aggregate lists of C/C++ source files, object files, and dependency
# files.
SOURCES.c_plus_plus := $(SOURCES.cc) $(SOURCES.cpp) $(SOURCES.cxx)
SOURCES   := $(SOURCES.c) $(SOURCES.c_plus_plus)
OBJS      := $(OBJS.c) $(OBJS.cc) $(OBJS.cpp) $(OBJS.cxx)
DEPS      := $(DEPS.c) $(DEPS.cc) $(DEPS.cpp) $(DEPS.cxx) $(DEPS.vscode)

# Use make's wildcard function to retrieve the name of every header file in
# the current working directory.
HEADERS := \
	$(wildcard *.h) \
	$(wildcard *.hh) \
	$(wildcard *.hpp) \
	$(wildcard *.hxx) \
	$(wildcard *.H)


# Use the C preprocessor to generate dependency files $(DEPDIR)%.d that
# contain makefile-compatible dependency rules that list the set of build
# prerequisites (dependencies) for each object code (%.o) file. For
# example: consider a translation unit consisting of files x.c, a.h, and
# b.h, that produces an object code file named x.o.  We want to command the
# C preprocessor to automatically create a file named $(DEPDOR)x.d that
# contains/provides a dependency rule for object code file $(BUILDDIR)x.o:
#
#	$(BUILDDIR)x.o: x.c a.h b.h
#
# where '$(BUILDDIR)x.o' is the rule's target (the object code file we want
# to create), and files x.c, a.h, and b.h are the rule's prerequisite
# (a.k.a., dependency) files.
#
# [Note 1:  Variable CPPFLAGS.d provides the command line flags that compel
# the C preprocessor to create the desired dependency files ($(DEPDIR)%.d).
#
#   -MT target
#         Specifies a custom name for the makefile rule's target, which in
#         this case is $(BUILDDIR)%.o.
#   -MMD
#         List only user header files, not system headers, in the rule's
#         file dependency list. (See also: -MD)
#   -MF file
#         Stores the automatically-generated dependency rule in the
#         specified file, which in this case is $(DEPDIR)%.d.
#
# See also: man 1 cpp
# --end note]
#
# [Note 2:  Variable CPPFLAGS.d must be a recursively expanded variable
# because it contains references to other variables `$@' and `$*' whose
# values are unknown at this point in the makefile.  These variables must
# be evaluated later in this makefile, at each point variable CPPFLAGS.d is
# expanded.  So use `=' here (deferred evaluation) and not `:=' (immediate
# evaluation). --end note]
#
CPPFLAGS.d =
CPPFLAGS.d += -MT $@ -MMD -MF $(DEPDIR)$*.Td

# C/C++ preprocessor flags
# NOTES
# * DO NOT add CPPFLAGS.d to this variable.
# * See also 'variables.mk' in this Makefile (e.g., for CPPFLAGS.custom)
CPPFLAGS += $(CPPFLAGS.custom) -DPROGRAM_NAME=$(PROGRAM_NAME)


# C compiler command line options (a.k.a., command line "flags")
# NOTES
# * Use this command to determine which C/C++ dialects your GCC supports:
#       gcc -v --help |& grep 'std='
# * See also 'variables.mk' in this Makefile (e.g., for CFLAGS.custom)
CFLAGS.dialect ?= c17
CFLAGS.default ?= -Wall
CFLAGS.release_build ?= -O3
CFLAGS.debug_build   ?= -O0 -ggdb
CFLAGS = -std=$(CFLAGS.dialect) $(CFLAGS.default) $(CFLAGS.custom)


# C++ compiler command line options (a.k.a., command line "flags")
# NOTES
# * Use this command to determine which C/C++ dialects your GCC supports:
#       g++ -v --help |& grep 'std='
# * See also 'variables.mk' in this Makefile (e.g., for CXXFLAGS.custom)
# * For teaching purposes it is sometimes helpful to add the GCC option
#   '-fno-elide-constructors' to CXXFLAGS.release_build.
CXXFLAGS.dialect ?= c++17
CXXFLAGS.default ?= -Wall
CXXFLAGS.release_build ?= -O3
CXXFLAGS.debug_build   ?= -O0 -ggdb
CXXFLAGS = -std=$(CXXFLAGS.dialect) $(CXXFLAGS.default) $(CXXFLAGS.custom)


# Linker flags and libraries
# NOTES
# * See also 'variables.mk' in this Makefile (e.g., for LDFLAGS.custom and
# LDLIBS.custom)
#
LDFLAGS = $(LDFLAGS.custom)
LDLIBS  = $(LDLIBS.custom)


# If this project has one or more C++ source code files, use the C++
# compiler to invoke the linking process; otherwise, use the C compiler to
# invoke the linking process [2].
# See also:
#   $ make -pnf /dev/null | grep 'LINK.o ='
#   $ make -pnf /dev/null | grep '$(LINK.o)'
# NB: GNU make's default recipe for invoking the link task is:
#   $(LINK.o) $^ $(LOADLIBS) $(LDLIBS) -o $@
#
ifeq ($(strip $(SOURCES.c_plus_plus)),)
# This project does not have C++ source files; so, use the C compiler to
# invoke the linker.
LINK.o = $(CC) $(LDFLAGS) $(TARGET_ARCH)
else
# This project has C++ source files; so, use the C++ compiler to invoke the
# linker.
LINK.o = $(CXX) $(LDFLAGS) $(TARGET_ARCH)
endif

# If the user's environment defines variable `STATIC_LINK' with a non-null
# value, use static linking; otherwise, use dynamic linking by default.
STATIC_LINK ?=
ifneq ($(STATIC_LINK),)
LINK.o += -static
endif


# Post-compile tasks
POSTCOMPILE = @mv -f $(DEPDIR)$*.Td $(DEPDIR)$*.d && touch $@


# [Optional]  Variable customizations for this build should be defined in a
# makefile named `variables.mk' located in the current working directory.
# Any variables defined thus far in this Makefile can be overridden or
# appended by (re)defining those variables within 'variables.mk'.
ifneq ($(wildcard variables.mk),)
include variables.mk
endif


## Raspberry Pi Libraries
# [Optional]
#
# You may optionally link your program against one of these libraries:
#  	* pigpio
#  	* wiringPi
#
# -------------------------------------------------------------------------
# :: pigpio ::
# If you are building software for the Raspberry Pi, and that software uses
# the pigpio library, store a copy of makefile `pigpio.mk' in the current
# working directory. That makefile provides preprocessor (cpp), compiler
# (gcc/g++), and linker (ld) options to build and link your program with
# the pigpio library.
ifneq ($(wildcard pigpio.mk),)
include pigpio.mk
# If cross compiling, ensure the Raspberry Pi's file system is mounted onto
# the folder specified by variable RPIFS. The pigpio header files and
# libraries are installed on the Raspberry Pi, not on the desktop computer.
# (NB: The shell script `mount.rpifs' is provided with Jim Fischer's
# `rpiutils' software package.)
ifeq ($(wildcard) $(WIRINGPI__INCLUDEDIR)/pigpio.h,)
$(shell mount.rpifs -q || true)
endif
# -------------------------------------------------------------------------
# :: wiringPi ::
# [Note 1:  This library is deprecated and should not be used in new
# projects. --end note]
#
# If you are building software for the Raspberry Pi, and that software uses
# the wiringPi library, store a copy of makefile `wiringPi.mk' in the
# current working directory. That makefile provides preprocessor (cpp),
# compiler (gcc/g++), and linker (ld) options to build and link your
# program with the wiringPi library.
else ifneq ($(wildcard wiringPi.mk),)
include wiringPi.mk
# If cross compiling, ensure the Raspberry Pi's file system is mounted onto
# the folder specified by variable RPIFS. The wiringPi header files and
# libraries are installed on the Raspberry Pi, not on the desktop computer.
# (NB: The shell script `mount.rpifs' is provided with Jim Fischer's
# `rpiutils' software package.)
ifeq ($(wildcard) $(WIRINGPI__INCLUDEDIR)/wiringPi.h,)
$(shell mount.rpifs -q || true)
endif
# -------------------------------------------------------------------------
endif


# [Optional]  If Linux pthread support is required, add a makefile named
# `pthread.mk' in the current working directory that contains the
# following variable assignments:
#   CFLAGS   += -pthread
#   CXXFLAGS += -pthread
#   LDFLAGS  += -pthread
ifneq ($(wildcard pthread.mk),)
include pthread.mk
endif


# [Optional]  If support for the {fmt} library is required, add a makefile
# named `fmt.mk' in the current working directory and ensure that makefile
# that provides the following variable definitions:
#   LDFLAGS  += -L/usr/local/lib64
#   LDLIBS   += -l:libfmt.a
ifneq ($(wildcard fmt.mk),)
include fmt.mk
endif


# [Optional]  If support for the Address Sanitizer (asan) library is
# desired, add a makefile named `asan.mk' in the current working directory
# and ensure that makefile provides the following variable definitions:
#   CFLAGS := -fsanitize=address
#   CXXFLAGS := -fsanitize=address
#   LDFLAGS := -fsanitize=address -static-libasan
#
# [Note 1:  The setup shown above uses static linking to when linking the
# asan library with your program. This is being done because it solves some
# problems that sometimes occur when using dynamic linking. If you want to
# use dynamic linking instead of static linking, you may need to use the
# environment variable LD_PRELOAD to manually load the asan library before
# other libraries are loaded, e.g., 
#   LD_PRELOAD=/lib/arm-linux-gnueabihf/libasan.so.6 ./demo
# See also: https://github.com/google/sanitizers/issues/679
# --end note]
#
ifneq ($(wildcard asan.mk),)
include asan.mk
endif


###########################################################################
#
#  This makefile's default goal is the target 'all'.
#
###########################################################################
.PHONY: all
all: $(BUILD_TYPE)


# Builds a 'release' version of the program without debugging support.
#
# NOTE: As stated in the gcc manual, "If you use multiple -O options, with
# or without level numbers, the last such option is the one that is
# effective."
#
# It is recommended that you use either 'specs.mk' or 'variables.mk' 
# as the means of defining the *.release_build variables (e.g.,
# CFLAGS.release_build).
#
# See also "6.11 Target-specific Variable Values" in the GNU Make manual.
#
.PHONY: release
release: BUILD_MODE := release
release: DEBUG :=
release: DEBUG_TRACE_LEVEL :=
release: CPPFLAGS += -DRELEASE_BUILD=1
release: CPPFLAGS += $(CPPFLAGS.release_build)
release: CFLAGS += $(CFLAGS.release_build)
release: CXXFLAGS += $(CXXFLAGS.release_build)
release: build_program


# Builds a 'debug' version of the program with debugging support.
#
# NOTE: As stated in the gcc manual, "If you use multiple -O options, with
# or without level numbers, the last such option is the one that is
# effective."
#
# It is recommended that you use either 'specs.mk' or 'variables.mk' as the
# means of defining the *.debug_build variables (e.g., CFLAGS.debug_build).
#
# See also "6.11 Target-specific Variable Values" in the GNU Make manual.
#
.PHONY: debug
debug: BUILD_MODE := debug
debug: DEBUG := 1
debug: DEBUG_TRACE_LEVEL ?= 5
debug: CPPFLAGS += -DDEBUG=1 -DDEBUG_BUILD=1
debug: CPPFLAGS += -DDEBUG_TRACE_LEVEL=$(DEBUG_TRACE_LEVEL)
debug: CPPFLAGS += $(CPPFLAGS.debug_build)
debug: CFLAGS += $(CFLAGS.debug_build)
debug: CXXFLAGS += $(CXXFLAGS.debug_build)
debug: build_program


# [Optional] If you need to perform miscellaneous tasks before the
# PROGRAM_NAME is built (e.g., building other libraries), create in the
# current working directory a makefile named `prebuild.mk'.  In that
# makefile define a simply expanded variable named `PREBUILD' whose value
# is `prebuild'.  Then define a .PHONY rule named `prebuild' whose last
# prerequisite is `$(PROGRAM_NAME)' and is prefixed by other prerequisites
# that must be satisfied before the PROGRAM_NAME is built, e.g.,
#
#       PREBUILD := prebuild
#       .PHONY: prebuild
#       prebuild: PREREQUISITE1 PREREQUISITE2 ... $(PROGRAM_NAME) 
#
PREBUILD_MAKEFILE := ./prebuild.mk
ifneq ($(wildcard $(PREBUILD_MAKEFILE)),)
include $(PREBUILD_MAKEFILE)
else
PREBUILD ?=
endif


# [Optional] If you need to perform miscellaneous tasks after the
# PROGRAM_NAME is built (e.g., stripping symbols from object code),
# create in the current working directory a makefile named `postbuild.mk'.
# In that makefile define a make variable `POSTBUILD' whose value is
# `postbuild'. Then define a .PHONY rule named `postbuild' whose first
# prerequisite is `$(PROGRAM_NAME)' followed by other prerequisites that
# must be satisfied after the PROGRAM_NAME is built, e.g.,
#
#       POSTBUILD := postbuild
#       .PHONY: postbuild
#       postbuild: $(PROGRAM_NAME) PREREQUISITE1 PREREQUISITE2 ...
#
POSTBUILD_MAKEFILE := ./postbuild.mk
ifneq ($(wildcard $(POSTBUILD_MAKEFILE)),)
include $(POSTBUILD_MAKEFILE)
else
POSTBUILD ?=
endif


# Build the program
.PHONY: build_program
build_program: $(PREBUILD) $(PROGRAM_NAME) $(POSTBUILD)


# This rule performs the LINK task which links together all the object code
# files (.o) and any libraries, as specified via the LDLIBS variable, into
# an executable image whose name is specified via the PROGRAM_NAME
# variable.
$(PROGRAM_NAME): $(OBJS)
	$(LINK.o) $^ $(LDLIBS) -o $@


# [Optional]  Additional rule customizations for this build should be
# defined in a makefile named `rules.mk' located in the current working
# directory.
ifneq ($(wildcard rules.mk),)
include rules.mk
endif


# [Optional]  If you want to produce an output file that shows class
# hierarchy information, including a breakdown of each class's virtual
# function lookup table (vtable), create a makefile named `vtable.mk' that
# contains the following:
#
#	CXXFLAGS += -fdump-lang-class
#	.PHONY: clean
#	clean:: ; -rm -f "$(BUILDDIR)"*.class
#
# This flag produces an output file that is stored in the $(BUILDDIR)
# folder.
#
ifneq ($(wildcard vtable.mk),)
include vtable.mk
endif


# Disable make's implicit rule for %.c -> %.o translation [3] and then
# define an implicit rule (a pattern rule) that performs %.c to %.o
# translation with file $(DEPDIR)%.d declared as a prerequisite. Ditto for
# %.cc and %.cpp to %.o translation.
#
# The %.d file is created as a side-effect of invoking the $(COMPILE.?)
# recipe, hence the need for an empty recipe rule for the %.d files
# (provided later in this makefile).  If the %.d file is missing, make will
# proceed "as if" the %.d file exists and is newer than the %.o target,
# thus triggering the invocation of the recipe lines that create the %.o
# target and, as a side effect, the %.d file.
#
# Declare the dependency folder $(DEPDIR) as an order-only prerequisite for
# these implicit/pattern rules, and define a rule that creates folder
# $(DEPDIR) if it does not exist.
#
# See reference [4] for $(OUTPUT_OPTION) == `-o $@'
# See reference [5] "Make ignoring Prerequisite that doesn't exist"
# See reference [6] "4.12.1 Syntax of Static Pattern Rules"
# See also "order-only prerequisites" in the GNU Make manual.
# See "Avoid Re-exec of make' in [1], and in particular this section is
# key:
#     Let's address the first problem above: the re-invocation of make. If
#     you think about it, this re-invocation is really not necessary. Since
#     we know some prerequisite of the target changed, we must rebuild the
#     [%.o] target; having a more up-to-date list won't affect that
#     decision. What we really need is to ensure that the prerequisite list
#     is up-to-date for the next invocation of make, when we need to decide
#     whether to update [the %.o target] again.
#
%.o: %.c
$(BUILDDIR)%.o: %.c $(DEPDIR)%.d | $(BUILDDIR) $(DEPDIR)
	$(COMPILE.c) $(CPPFLAGS.d) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

%.o: %.cc
$(BUILDDIR)%.o: %.cc $(DEPDIR)%.d | $(BUILDDIR) $(DEPDIR)
	$(COMPILE.cc) $(CPPFLAGS.d) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

%.o: %.cpp
$(BUILDDIR)%.o: %.cpp $(DEPDIR)%.d | $(BUILDDIR) $(DEPDIR)
	$(COMPILE.cpp) $(CPPFLAGS.d) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)


# Create the build directory if it doesn't exist.
$(BUILDDIR): ; @mkdir -p $@ >/dev/null


# Create the dependency directory if it doesn't exist.
$(DEPDIR): ; @mkdir -p $@ >/dev/null


#
# Empty recipe rule for the %.d dependency files
#
# If a make rule lists file X as as a dependency of target Y, and X is
# created as a side effect of creating Y, then an empty recipe rule is
# required for the dependency file X:
#
#  Y: X
#       recipe that creates Y and, as a side effect, also creates X
#
#  # Empty recipe rule for dependency X
#  X:
#
# For example, if a dependency file %.d is created by the same C/C++
# compiler invocation that creates an object code file %.o, 
#
#   $ gcc -MMD -c main.c
#   ; main.c -> (cpp)--> (gcc)--> main.o
#   ;                `-> main.d
#   $ cat main.d
#   main.o: main.c hello.h world.h
#
# and a make rule lists file %.d as a dependency of the target file %.o,
# then there must also be an empty recipe rule for the dependency file %.d:
#
#  main.o: main.c main.d
#       gcc -MMD -c $<
#
#  main.d:
#
# See also [7].
#
$(DEPS):


# Include the automatically-generated dependency rules from folder DEPDIR
include $(wildcard $(DEPS))


# doxygen documentation
ifneq ($(wildcard doxygen.mk),)
include doxygen.mk
endif


#
# Strip all unneeded symbols from PROGRAM_NAME to reduce its file size.
# This should only be done on a release build (don't strip a debug build).
#
.PHONY: strip
strip: ; $(STRIP) --strip-unneeded $(PROGRAM_NAME)

#
# Make a distribution tarball file
#
ifneq ($(wildcard dist.mk),)
include dist.mk
endif

#
# Clean-up
#

# Clean-up tasks that are common to goals `mostly-clean' and `clean'.
.PHONY: _basic_clean
_basic_clean::
	-rm -f $(DEPS)
	-rm -f $(OBJS)
	-rm -f $(notdir $(OBJS:%.o=%))

# Delete all build products *except* the program file.
.PHONY: mostly-clean
mostly-clean:: _basic_clean
	$(call remove_folder,$(DEPDIR))
	$(call remove_folder,$(BUILDDIR))

# Delete all build products that are files (do not delete directories).
.PHONY: clean
clean:: _basic_clean
	-rm -f $(PROGRAM_NAME)

# Delete all build products.
.PHONY: distclean
distclean:: clean
	$(call remove_folder,$(DEPDIR))
	$(call remove_folder,$(BUILDDIR))

# Delete all build products, and delete symbol cross-reference files.
.PHONY: maintainer-clean
maintainer-clean:: distclean
	-@rm -f cscope.out tags TAGS


# Prints the value of each environment variable and makefile variable
# (useful for debugging the makefile). These commands are also useful:
#    $ make -pn [goal]        # Make's default rules + the Makefile's rules
#    $ make -pn -f /dev/null  # Make's default rules, ignores your Makefile
# See also: the descriptions of options `-p' and `-n' in the make manual.
#
.PHONY: vars
vars :
	$(foreach V, $(sort $(.VARIABLES)), $(if $(filter-out default automatic, $(origin $V)), $(info $V=$($V) ($(value $V)))))


# Prints the preprocessor's include folder search path for C translations
.PHONY: show-cc-include-path
show-cc-include-path:
	$(CC) $(CPPFLAGS) -E -Wp,-v -xc /dev/null 2>&1

# Prints the preprocessor's include folder search path for C++ translations
.PHONY: show-cxx-include-path
show-cxx-include-path:
	$(CC) $(CPPFLAGS) -E -Wp,-v -xc++ /dev/null 2>&1

# Prints the linker's library search path
.PHONY: show-ld-lib-path
show-ld-lib-path:
	$(LD) --verbose $(LD_LIB_DIRS) | grep SEARCH_DIR | tr -s ' ;' \\012

# Prints the C compiler's information page
.PHONY: show-cc-info
show-cc-info:
	$(CC) -v

# Prints the C++ compiler's information page
.PHONY: show-cxx-info
show-cxx-info:
	$(CXX) -v


# [Optional] If you want to perform "check" tasks after the PROGRAM_NAME
# is built (e.g., unit testing), create in the current working directory a
# makefile named `check.mk'.  In that makefile define a .PHONY rule named
# `check' whose first prerequisite is `$(PROGRAM_NAME)' followed by any
# other prerequisites that must be satisfied to perform the check
# tests--e.g.,
#
#       .PHONY: check
#       check: $(PROGRAM_NAME) PREREQUISITE1 PREREQUISITE2 ...
#
# To invoke this goal type 'make check'.
#
CHECK_MAKEFILE := ./check.mk
ifneq ($(wildcard $(CHECK_MAKEFILE)),)
include $(CHECK_MAKEFILE)
endif


# Removes a folder only if it resides within the current working directory.
define remove_folder
	if [ -n "$(1)" -a -d "$(1)" ]; then \
	if realpath $(1) | grep -q `realpath .` ; then rm -fr $(1); fi; \
	fi
endef

# REFERENCES
# [1]  http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/
# [2]  https://stackoverflow.com/a/13375395
# [3]  https://www.gnu.org/software/make/manual/make.html#Match_002dAnything-Rules
# [4]  https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_10.html
# [5]  https://stackoverflow.com/a/34983297/5051940
# [6]  https://www.gnu.org/software/make/manual/html_node/Static-Usage.html#Static-Usage
# [7]  https://www.gnu.org/software/make/manual/html_node/Empty-Recipes.html
#
