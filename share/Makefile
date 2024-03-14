# Makefile
# Copyright 2019-2021 James D. Fischer
#
# SYNOPSYS
#   make {all|release|debug}
#   make {clean|distclean|maintainer-clean}
#   make strip
#   make vars
#
# DESCRIPTION
#   The default build is `all' (a.k.a., `release').
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
# toolchain that Make uses--i.e., the build computer's native GCC
# toolchain, create within the current working directory a makefile named
# `toolchain.mk' and within it define (at a minimum) the variables AR, CC,
# CXX, and LD.
# For example,
#    AR  := /usr/local/mycross/bin/ar
#    CC  := /usr/local/mycross/bin/gcc
#    CXX := /usr/local/mycross/bin/g++
#    LD  := /usr/local/mycross/bin/ld
ifneq ($(wildcard toolchain.mk),)
include toolchain.mk
endif


# [Optional]  Create a makefile named `specs.mk' that provides
# program-specific specifications for this build--e.g., redefine
# PROGRAM_NAME with the desired program name; provide version
# information, build directory, dependency directory name and path, 
# and so on. 
ifneq ($(wildcard specs.mk),)
include specs.mk
endif


# The default name for the program to be created.
PROGRAM_NAME ?= demo


# Determine the build mode: release or debug.  The default build mode is
# 'release'.
# 
# Here are some methods for selecting the 'debug' build mode:
#
#   # Option 1.  One time debug build.
#   $ make debug
#
#   # Option 2.  One time debug build.
#   $ DEBUG=1 make
#
#   # Option 3.  Performs debug builds until the shell environment
#   #            variable DEBUG is unset.
#   $ export DEBUG=1
#   $ make
#
# Note that if the variable DEBUG is defined and set in the environment,
# invoking any make targets other than 'debug', 'clean', and
# 'maintainer-clean' yields undefined behavior.
#
ifeq ($(origin DEBUG),environment)
# See options 2 and 3 above
BUILD_TYPE := debug
else
BUILD_TYPE := release
endif


# BUILDDIR is the top-level target folder for all build products--e.g.,
# object code files, dependency files, the executable image file, etc.
#
BUILDDIR := build

# If BUILDDIR is defined, ensure BUILDDIR ends in '/'.
ifdef BUILDDIR
ifeq ($(findstring */,$(BUILDDIR)),)
BUILDDIR := $(BUILDDIR)/
endif
endif


# DEPDIR is the folder that contains the dependency files %.d for this
# directory's object files %.o. Each object file in the current working
# directory will have an associated dependency file within folder
# DEPDIR--e.g.,
#    foo.o -> $(DEPDIR)foo.d
# $(BUILDDIR)
#  `-- $(DEPDIR)
#
DEPDIR_NAME := deps
DEPDIR := $(BUILDDIR)$(DEPDIR_NAME)

# If DEPDIR is defined, ensure DEPDIR ends in '/'.
ifdef DEPDIR
ifeq ($(findstring */,$(DEPDIR)),)
DEPDIR := $(DEPDIR)/
endif
endif


# Use make's `wildcard' function to find all of the C source files (.c) in
# the current working directory. Next, use a substitution reference to
# generate the list of C object files (.o) to be created from the list of C
# source code files, as well as the list of dependency files (.d). Ditto
# for C++ source code files (.cc, .cpp). (See also make's `patsubst'
# function.)
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

# Visual Studio Code
DEPS.vscode := null.d

# Aggregate lists of C/C++ source files, object files, and dependency
# files.
SOURCES.c_plus_plus := $(SOURCES.cc) $(SOURCES.cpp) $(SOURCES.cxx)
SOURCES   := $(SOURCES.c) $(SOURCES.c_plus_plus)
OBJS      := $(OBJS.c) $(OBJS.cc) $(OBJS.cpp) $(OBJS.cxx)
DEPS      := $(DEPS.c) $(DEPS.cc) $(DEPS.cpp) $(DEPS.cxx) $(DEPS.vscode)

# Use make's wildcard function to retrieve the name of every header file in
# the current working directory.
HEADERS := $(wildcard *.h) $(wildcard *.hh) $(wildcard *.hpp) $(wildcard *.hxx) $(wildcard *.H)


# Use the preprocessor to generate files $(DEPDIR)%.d that contain
# makefile-compatible dependency rules for each %.o file.
#
# NB: Variable CPPFLAGS.d must be a recursively expanded variable because
# it contains references to other variables `$@' and `$*' whose values are
# unknown at this point. These variables must be evaluated later, wherever
# variable CPPFLAGS.d is expanded. So use `=' here and not `:='.
#
# -MT target
#       Specifies a custom target for the makefile rule.
# -MMD
#       List only user header files, not the system headers, in the
#       makefile rule's dependency list. (See also: -MD)
# -MF file
#       Specifies the output file to write the makefile dependency rule
#       into.
#
CPPFLAGS.d =
CPPFLAGS.d += -MT $@ -MMD -MF $(DEPDIR)$*.Td

# C/C++ preprocessor flags
# NB: DO NOT add CPPFLAGS.d to this variable.
# See also 'variables.mk' in this Makefile (e.g., for CPPFLAGS.custom)
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


# If the project has one or more C++ source code files, use the C++
# compiler to invoke the linking process; otherwise, use the C compiler to
# invoke the linking process [2].
# See also:
#   $ make -pnf /dev/null | grep 'LINK.o ='
#   $ make -pnf /dev/null | grep '$(LINK.o)'
# NB: GNU make's default recipe for invoking the link task is:
#   $(LINK.o) $^ $(LOADLIBS) $(LDLIBS) -o $@
#
ifeq ($(strip $(SOURCES.c_plus_plus)),)
# This is a C-only program; use the C compiler to invoke the linker.
LINK.o = $(CC) $(LDFLAGS) $(TARGET_ARCH)
else
# This is a C++ or C/C++ program; use the C++ compiler to invoke the
# linker.
LINK.o = $(CXX) $(LDFLAGS) $(TARGET_ARCH)
endif
# If the user's environment defines variable `STATIC_LINK' with a non-null
# value, use static linking; otherwise, use dynamic linking by default.
ifneq ($(STATIC_LINK),)
LINK.o += -static
endif


# Post-compile tasks
POSTCOMPILE = @mv -f $(DEPDIR)$*.Td $(DEPDIR)$*.d && touch $@


# [Optional]  Variable customizations for this build should be defined in a
# makefile named `variables.mk' located in the current working directory.
# Any variables defined thus far in this Makefile can be overridden or
# appended by (re)defining these variables within 'variables.mk'.
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
#
# :: wiringPi ::
# If you are building software for the Raspberry Pi, and that software uses
# the wiringPi library, store a copy of makefile `wiringPi.mk' in the
# current working directory. That makefile provides preprocessor (cpp),
# compiler (gcc/g++), and linker (ld) options to build and link your
# program with the wiringPi library.
ifneq ($(wildcard wiringPi.mk),)
include wiringPi.mk
# If cross compiling, ensure the Raspberry Pi's file system is mounted onto
# the folder specified by variable RPIFS. The wiringPi header files and
# libraries are installed on the Raspberry Pi, not on the desktop computer.
# (NB: The shell script `mount.rpifs' is provided with Jim Fischer's
# `rpiutils' software package.)
else ifeq ($(wildcard) $(WIRINGPI__INCLUDEDIR)/wiringPi.h,)
$(shell mount.rpifs -q || true)
endif
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
# named `fmt.mk' in the current working directory that contains the
# following variable assignments:
#   LDFLAGS  += -L/usr/local/lib64
#   LDLIBS   += -l:libfmt.a
ifneq ($(wildcard fmt.mk),)
include fmt.mk
endif


###########################################################################
#
#  The default target
#
###########################################################################
.PHONY: all
all : $(BUILD_TYPE)


# Builds a 'release' version of the program without debugging support.
#
# NOTE: As stated in the gcc manual, "If you use multiple -O options, with
# or without level numbers, the last such option is the one that is
# effective."
#
# It is recommended that you use either 'specs.mk' or 'variables.mk' as the
# means of defining the *.release_build variables (e.g., CFLAGS.release_build).
#
# See also "6.11 Target-specific Variable Values" in the GNU Make manual.
#
.PHONY: release
release : BUILD_MODE := release
release : DEBUG :=
release : DEBUG_TRACE_LEVEL :=
release : CPPFLAGS += -DRELEASE_BUILD=1
release : CPPFLAGS += $(CPPFLAGS.release_build)
release : CFLAGS += $(CFLAGS.release_build)
release : CXXFLAGS += $(CXXFLAGS.release_build)
release : build_program


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
debug : BUILD_MODE := debug
debug : DEBUG := 1
debug : DEBUG_TRACE_LEVEL ?= 5
debug : CPPFLAGS += -DDEBUG=1 -DDEBUG_BUILD=1
debug : CPPFLAGS += -DDEBUG_TRACE_LEVEL=$(DEBUG_TRACE_LEVEL)
debug : CPPFLAGS += $(CPPFLAGS.debug_build)
debug : CFLAGS += $(CFLAGS.debug_build)
debug : CXXFLAGS += $(CXXFLAGS.debug_build)
debug : build_program


# [Optional] If you need to perform miscellaneous tasks before the
# PROGRAM_NAME is built (e.g., building other libraries), create in the
# current working directory a makefile named `prebuild.mk'.  In that
# makefile define a make variable `PREBUILD' whose value is `prebuild'.
# Then define a .PHONY rule named `prebuild' whose last prerequisite is
# `$(PROGRAM_NAME)' and is prefixed by other prerequisites that must be
# satisfied before the PROGRAM_NAME is built, e.g.,
#
#       PREBUILD := prebuild
#       .PHONY: prebuild
#       prebuild : PREREQUISITE1 PREREQUISITE2 ... $(PROGRAM_NAME) 
#
PREBUILD_MAKEFILE := ./prebuild.mk
ifneq ($(wildcard $(PREBUILD_MAKEFILE)),)
include $(PREBUILD_MAKEFILE)
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
#       postbuild : $(PROGRAM_NAME) PREREQUISITE1 PREREQUISITE2 ...
#
POSTBUILD_MAKEFILE := ./postbuild.mk
ifneq ($(wildcard $(POSTBUILD_MAKEFILE)),)
include $(POSTBUILD_MAKEFILE)
endif


# Build the program
.PHONY: build_program
build_program : $(PREBUILD) $(PROGRAM_NAME) $(POSTBUILD)


# This rule performs the LINK task which links together all the object code
# files (.o) and any libraries, as specified via the LDLIBS variable, into
# an executable image whose name is specified via the PROGRAM_NAME
# variable.
$(PROGRAM_NAME) : $(OBJS)
	$(LINK.o) $^ $(LDLIBS) -o $@


# [Optional]  Additional rule customizations for this build should be
# defined in a makefile named `rules.mk' located in the current working
# directory.
ifneq ($(wildcard rules.mk),)
include rules.mk
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
%.o : %.c
$(BUILDDIR)%.o : %.c $(DEPDIR)%.d | $(BUILDDIR) $(DEPDIR)
	$(COMPILE.c) $(CPPFLAGS.d) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

%.o : %.cc
$(BUILDDIR)%.o : %.cc $(DEPDIR)%.d | $(BUILDDIR) $(DEPDIR)
	$(COMPILE.cc) $(CPPFLAGS.d) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

%.o : %.cpp
$(BUILDDIR)%.o : %.cpp $(DEPDIR)%.d | $(BUILDDIR) $(DEPDIR)
	$(COMPILE.cpp) $(CPPFLAGS.d) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)


# Create the build directory if it doesn't exist.
$(BUILDDIR) : ; @mkdir -p $@ >/dev/null


# Create the dependency directory if it doesn't exist.
$(DEPDIR) : ; @mkdir -p $@ >/dev/null


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
strip : ; $(STRIP) --strip-unneeded $(PROGRAM_NAME)


#
# Clean-up
#
.PHONY: clean
clean::
	-rm -f $(OBJS) $(DEPS) $(PROGRAM_NAME)
	-rm -f $(notdir $(OBJS:%.o=%))

.PHONY: distclean
distclean:: clean
	$(call remove_folder,$(DEPDIR))
	$(call remove_folder,$(BUILDDIR))

.PHONY: maintainer-clean
maintainer-clean:: distclean
	-@rm -f tags


# Prints the value of each environment variable and makefile variable
# (useful for debugging the makefile). These commands are also useful:
#    $ make -pn [target]      # Rules that are defined by your Makefile
#    $ make -pn -f /dev/null  # Make's default rules, ignores your Makefile
# NB: Make's '-n' option means "dry run"; it shows the actions make would
# perform without actually building anything.
# Example:  $ make vars 2>&1 | less
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
#       check : $(PROGRAM_NAME) PREREQUISITE1 PREREQUISITE2 ...
#
# To invoke this target type 'make check'.
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
