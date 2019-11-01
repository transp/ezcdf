# ezcdf

![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/transp/ezcdf?include_prereleases)

## About

EZcdf, Easy Interface to netCDF Routine Calls

## Contact

transp_support@pppl.gov


## History

Feb 1999   - Created  
April 2000 - A. Pletzer: Added R4  
May 2000   - C. Ludescher-Furth: Simplified by adding module ezcdf  
May 2001   - A. Pletzer: Added C8 and C16  
Oct 2002   - S. Hirshman: added LOG and reworked interface  
Sept 2019  - Moved to github

*** EZCDF is targeted for deprecation as of 2019/09 ***


## Contents

Makefile:      GNU make should be used  
Makefile.def   Definitions for the Makefile

USERGUIDE:     Detailed User Guide

Sources to build libezcdf.a or libezcdf.so and f90 modules:  
   ezcdf.f90         ezcdf_genget.f90  ezcdf_inqvar.f90  
   ezcdf_attrib.f90  ezcdf_genput.f90  ezcdf_opncls.f90  
   handle_err.f90

Test programs:  
   eztest.f90 and its sample output EZsample.nc  
   eztest2.cc, ezcdf.hh: This is an example how to call ezcdf from a C++ program.


## Build

NOTE:  For linking the netCDF library is required.

The location of netCDF Fortran library should be specified with NETCDF_DIR. See the example bash configuration file used at PPPL (pppl-bashrc) and the Makefile.def file.

make             -- will build libezcdf.a and the test programs  
make debug       -- will build a debug version of libezcdf.a  
make shared      -- will build a shared library, libezcdf.so  
make clean       -- will remove the compiled objects and modules  
make clobber     -- will run clean and remove the libs and test programs

The Makefile.def is set-up for compiling with the GNU, Intel, and Portland group compilers.


## Test

./eztest
eztest will write and re-read a simple netCDF file EZtest.nc and write/re-read a large file, bigFile.nc and check for errors. The contents of EZtest.nc should be the same as of EZsample.nc, which is included in the distribution.

./eztest2
C++ version of eztest


## Install

Final installation will be put in a location specified by the PREFIX environment variable. The directory './build/' will be used if not specified. Installation done with:

make install     -- will install the code in $PREFIX  
make uninstall   -- to delete the installation

You can specify the PREFIX with the make command:

make PREFIX=/path/to/location install  
make PREFIX=/path/to/location uninstall
