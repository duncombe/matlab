
Matlab USEFUL
-------------

Description
-----------

Scripts by C M Duncombe Rae, supposedly serving some useful
purpose.

Background
----------

These scripts were begun in 1994, are under constant modification
and revision and suffer increasingly serious but often erratic
attempts at documentation and portability. Now at last under RCS
revision control.

The scripts address various perceived deficiencies in the
provided matlab scripts and provide some shortcuts for often used
sequences of code. Since the scripts were begun created back in
1994 (Matlab v3.2), some of these deficiencies (such as dealing
with matrices containing NaNs) have been corrected by Matlab as
newer versions are released. The scripts fall somewhat loosely
into groups, see Contents.m for more details.

There are some standards, one of which is the use of LDEO
originated s87 format (see s87.doc), another is the use of an stp
matrix (data is manipulated in an (m x 3) matrix, stp, where
stp(:,1) is salinity, stp(:,2) is temperature, and stp(:,3) is
pressure. Occasionally this is extended and stp is (m x 4) and
the fourth column is oxygen. 

Requirements
------------

Some of the scripts require GMT to be installed. Others expect
mexcdf (or mexnc). Some expect to find the seawater library
(CSIRO).

Matrix Manipulation
-------------------

These are matrix manipulations and simple shortcuts (such as 
Re.m, for real.m, and Im.m, for imag.m, and scripts with real
functionality such as extract.m and samerows.m). 

Data Handling and Display
-------------------------

For displaying oceanographic data, the most frequently used one
being views87s.m for reading and displaying data in s87 files.
There is also isopycnal.m  which draws isopycnal lines on the
current (TS) axes, and the my(seawater module) scripts (eg
mydens.m equivalent to sw_dens.m) which do the expected
calculation on a STP matrix, when seawater expects separate S, T
and P matrices. 

Physical Oceanography
---------------------

Scripts attempt some analysis of ocena data (eg envelope.m  and
enclosure.m analyse and return the T/S envelope of stp data;
mld.m and mixlayer.m determine and characterise mixed layers and
stads in stp data).  There is also a script to calculate
spiciness (spice.m) which is not in seawater scripts.  closest.m
finds the closest station pairs in two station lists (or lists of
positions), useful for sorting a cruise that occupies a repeat
station line.

Data reading and handling 
-------------------------

Various data formats can be read, loaded, and written (check
individual scripts for full capabilities): LDEO (s87 format),
SFRI (several iterations of data format were toyed with before
the seabird equipment was available),  SeaSoft Data files,
Service Data Format (seemingly a favorite of hydrology and
geophysics laboratories),  NetCDF Data Format (relies on mexcdf
beinbg available), WOCE Data Format, data from the Seward Johnson
SJ9705 Cruise, 

The satellite data scrcipts are from Deirdre Byrne (jason.mat,
tptrack.m, tplabel.m, tpgetx.m, tpgety.m)

Statistics
----------

There are some scripts to calculate statistics (eg. myboxplot.m
from before Matlab distributed a boxplotting script; and stats.m
which does columnwise simple stats).  One of the more frequently
used is normaliz.m which subtracts the mean and divides by the
std deviation (originally by D. Byrne).

General
-------

Some general date and time scripts and shortcuts such as starting
a xterm with an editor in it.  Some of the more useful are form.m
which builds a format specifier for sprintf, and parsepos.m which
parses  a generic position (lat/long) string (including the forms
eg, 32:12:24W and 32W12:24 for 32 degress 12 minutes and 24
seconds, returning -32.2067). 


Updated: 2009/03/13 CMDR





