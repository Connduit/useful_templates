ifndef CFG
CFG := Debug
endif

ifeq (${CFG}, Debug)
CPPFLAGS += -g -D_DEBUG
LDFLAGS += -g
else ifeq (${CFG}, Release)
CPPFLAGS += -O -DNDEBUG
LDFLAGS += -O
else
$(error Invalid CFG specified: ${CFG})
endif
$(info Using CFG: ${CFG})

# Compile with GCC v6.1.0
# COMPILER_GCC_610 := /ray/links/apps/gcc/versions/6.1.0/g++
# COMPILER_GCC_610 := /usr/local/gcc-6.1.0/bin/g++
# CXX := ${COMPILER_GCC_610}
# LD_LIBRARY_PATH := /usr/local/gcc-6.1.0/lib64:${LD_LIBRARY_PATH}

###############################################################################
DSTDIR := ${CFG}

CXXFLAGS += -Wall

.PHONY: default all clean cleanall test

default: all

# This contains all the paths and executables we want to build?
all: ${DSTDIR} ${DSTDIR}/hello

clean:
  @echo
  @echo "Cleaning ..."
  ${RM} -r ${DSTDIR}

cleanall: clean
  @echo
  @echo "Cleaning ALL ..."
  ${RM} *~ testFile.dat
  ${RM} -r rpt

# Delete this... it's not needed?
test: default
  @echo
  @echo "Testing ..."
  printenv LD_LIBRARY_PATH
  ${DSTDIR}/hello
  ls -l testFile.dat
  hexdump -C testFile.dat

${DSTDIR}/%.o: %.cpp
  @echo
  @echo "Compiling $@ ..."
  ${CXX} ${CXXFLAGS} ${CPPFLAGS} -c $< -o $@

# Get list of all CPPs in current directory
CPPS := $(wildcard *.cpp)
$(info CPPS: ${CPPS})
# Compute the list of OBJS from the list of CPPS
OBJS := ${patsubst %.cpp, ${DSTDIR}/%.o, ${CPPS}}
$(info OBJS: ${OBJS})

# Delete this?
${DSTDIR}/MyMsg.o : MyMsg.cpp MyMsg.h
${DSTDIR}/main.o : main.cpp MyMsg.h MyFileUtils.h
${DSTDIR}/MyFileUtils.o : MyFileUtils.cpp MyFileUtils.h

# Hello is some executable... make multiple of these if there's multiple executatbles?
${DSTDIR}/hello : ${OBJS}
  @echo
  @echo "Linking $@ ..."
  $(CXX) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@

${DSTDIR} :
  @echo
  @echo "mkdir $@ ..."
  mkdir $@

