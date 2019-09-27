# Simple makefile to build libezcdf.a or libezcdf.so

# Include compile options
include Makefile.def

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


.PHONY: checks clean clobber debug install shared

all:	checks $(LIBAR) eztest eztest2

$(LIBAR): $(OBJS)
	@ar r $@ $(OBJS)

eztest:
	$(FC) $(LDFLAGS) $(FFLAGS) $@.f90 -o $@ -L$(SRCDIR) -lezcdf $(FLIBS)

eztest2:
	$(CXX) $(CXXLDFLAGS) $(CXXFLAGS) $@.cc -o $@ $(CXXLIBS) -L$(SRCDIR) -lezcdf $(FLIBS)

checks:
ifndef NETCDFLIB
	$(error NETCDFLIB is undefined)
endif
ifndef NETCDFINC
	$(error NETCDFINC is undefined)
endif

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
shared:        LDFLAGS += $(SLDFLAGS)
shared:	$(OBJS)
	$(FC) $(LDFLAGS) -o $(LIBSO) $(OBJS)

$(OBJS) :
#
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
