# Simple makefile to build libezcdf.a or libezcdf.so

SHELL:=/bin/bash

FLIBS =
FINCL =

ifneq (,$(shell which nf-config))
        NETCDF_FORTRAN_HOME = `nf-config --prefix`
        NETCDF_FLAGS = -D_NETCDF `nf-config --fflags`
        FINCL += -I`nf-config --includedir`
        FLIBS += `nf-config --flibs`
endif

ifneq (,$(findstring icc, $(CC)))
        COMPILER=icc
        FFLAGS = -cpp -O2 -stand f08 -real-size 64 -auto-scalar $(NETCDF_FLAGS)
        LDFLAGS = -cpp
        DFFLAGS = -g -traceback -check all -warn all
        SFFLAGS = -fpic
        SLDFLAGS = -shared
        CXXFLAGS = -O2 -std=c++11 $(NETCDF_FLAGS)
        CXXLIBS = -lifcore

else ifeq ($(COMPILER),pgcc-llvm)
        FFLAGS = -cpp -fast -r8 $(NETCDF_FLAGS) -D_PGC
        LDFLAGS = -cpp
        DFFLAGS = -g -traceback -Mbounds
        SFFLAGS = -fpic
        SLDFLAGS = -shared
        CXXFLAGS = -O2 -mp -std=c++11 $(NETCDF_FLAGS)
        CXXLIBS = -lstdc++ -lgfortran
        CXXLDFLAGS =

else
        COMPILER=gfortran
        FFLAGS = -cpp -dM -O2 -std=f2008 -fdefault-real-8 -ffpe-trap=invalid,zero,overflow $(NETCDF_FLAGS)
        LDFLAGS = -cpp
        DFFLAGS = -Og -Wall
        SFFLAGS = -fpic
        SLDFLAGS = -shared
        CXXFLAGS = -O2 -std=c++11 $(NETCDF_FLAGS)
        CXXLIBS = -lstdc++ -lgfortran
endif

# Define directories and library names
SRCDIR := $(shell pwd)

PREFIX := $(or $(PREFIX),$(SRCDIR)/build)
LIBDIR := $(PREFIX)/lib
INCDIR := $(PREFIX)/include
TESTDR := $(PREFIX)/test

LIBAR := libezcdf.a
LIBSO := libezcdf.so

EXEF90 := eztest
EXECXX := eztest2

# Define the objects
SRCS :=	ezcdf_inqvar.f90 \
	ezcdf_opncls.f90 \
	ezcdf_attrib.f90 \
	ezcdf_genget.f90 \
	ezcdf_genput.f90 \
	ezcdf.f90 \
	handle_err.f90
OBJS :=	$(SRCS:.f90=.o)


.PHONY: clean clobber debug shared install uninstall

all:	$(LIBAR) eztest eztest2

$(LIBAR): $(OBJS)
	@ar r $@ $(OBJS)

eztest:
	$(FC) $(LDFLAGS) $(FFLAGS) $@.f90 -o $@ -L$(SRCDIR) -lezcdf $(FLIBS)

eztest2:
	$(CXX) $(CXXLDFLAGS) $(CXXFLAGS) $@.cc -o $@ $(CXXLIBS) -L$(SRCDIR) -lezcdf $(FLIBS)

install:
	@test -d $(LIBDIR) || mkdir -p $(LIBDIR)
	@test -d $(INCDIR) || mkdir -p $(INCDIR)
	@test -d $(TESTDR) || mkdir -p $(TESTDR)
	@cp *.mod $(INCDIR)
	@cp ezcdf.hh $(INCDIR)
	@test ! -f $(LIBAR) || cp $(LIBAR) $(LIBDIR)
	@test ! -f $(LIBSO) || cp $(LIBSO) $(LIBDIR)
	@cp EZsample.nc $(TESTDR)
	@test ! -f $(EXEF90) || cp $(EXEF90) $(TESTDR)
	@test ! -f $(EXECXX) || cp $(EXECXX) $(TESTDR)

debug:	FFLAGS += $(DFFLAGS)
debug:	$(LIBAR)
debug:	eztest
debug:	eztest2

shared:	FFLAGS += $(SFFLAGS)
shared: LDFLAGS += $(SLDFLAGS)
shared:	$(OBJS)
	$(FC) $(LDFLAGS) -o $(LIBSO) $(OBJS)

$(OBJS) :

%.o: %.f90
	$(FC) -c $(FFLAGS) $< -o $@ $(FLIBS) $(FINCL)

uninstall:
	@rm -rf $(PREFIX)

clean:
	@rm -f *~
	@rm -f $(OBJS) *.mod

clobber: clean
	@rm -f $(LIBAR) $(LIBSO)
	@rm -f $(EXEF90) $(EXECXX)
