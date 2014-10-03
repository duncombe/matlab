% Useful general routines
%
% Complex Arithmetic
%	complex.m -	help file for MATLAB complex arithmetic
%	c2m.m -		convert complex to ordered pair
%	m2c.m -		convert ordered pair to complex
%	Im.m -		imag()
%	Re.m - 		real()
% 	complexinfo.m	
%
% Matrix Manipulation
%	extract.m - 	extract the indexes from an array
% 	inrange.m - 	finds X within given limits
%	mchk.m -	tests multiplication of vectors
% 	samerows.m -	fills vector to length with value
%	sortstr.m -	sorts a string matrix
%	uniq.m - 	equivalent to unix uniq command on adjacent matrix rows
%
% Data Handling and Display
%	displays.m -	displays s,t,p data for hydro station
%	holdstn.m -	sets hold status of displays plot
%	isopycnal.m - 	draws isopycnal lines on the current axes 
%	mydens.m -	calculate seawater density using matrix
%	mydens0.m -	calculate density at the surface using matrix
%	mypden.m -	calculate seawater potential density using matrix
%	mygpa.m -	calculate geopotential anomaly using matrix
%	mysvel.m -	calculate seawater sound speed using matrix
%	showctd.m -	displays ctd data on three plots
%	overctd.m -	overlays ctd data on plot by showctd
%	showctdo.m -	displays ctdo data on three plots
%	overctdo.m -	overlays ctdo data on plot by showctd
%	oxysat.m - 	oxygen saturation value for seawater
%	stpaxis.m -	sets the axes on an s,t,p plot created by displays
%	tfromds.m -	Temperature from a density and salinity
%	sfromdt.m -	Salinity from a density and temperature
%	tsplot.m -	plots ts diagrams for marcel (gyppo!!)
%	stepts.m -	Steps station by station through CTD data output
%			from VIEWS87S
%	views87s.m -	use displays on all .s87 files in current directory
%	checkprs.m -	checks consistency of all .PRS files in current dir
%	calibdat.m -	discards outliers and returns linear regression
%	ctdref.m -	loads reference station CTD data from c138.mat
%	c138.mat -	reference station CTD data
%	presfilt.m -	removes pressure reversals and interpolate
%			to standard interval
%	lucorc.m -	plots LUCORC grid of stations on current figure
%	asttex.m -	plots ASTTEX grid of stations on current figure
%	shbml.m -	plots SHBML grid of stations on current figure
%	stp2mat.m -	converts STP matrix to [mxn] matrixes of S, T and P
%
% Physical Oceanography
%	envelope.m -	returns the T/S envelope of CTD data
%	enclosure.m -	analysis of the T/S envelope of CTD data
%	pycnoc.m -	estimate pycnocline from stp data
%	mld.m -		mixed layer detection
%	mixlayer.m -	mixed layer determination and characterisation
%	dragcoef.m -	testing around with surface wind drag coefficients
%	wmdefn.m -	water mass definitions
%	wmtest.m -	testing water mass definitions
% 	wmass.m - 	test whether water type firs into defined water mass
%	spice.m - 	calculate spiciness
% 	anomaly.m - 	calculates parameter average through a water column
% 	realdept.m - 	calculate depth by integrating density
% 
%	closest.m - 	finds closest station pairs in two station lists
%
% 
% L-DEO Data Handling
% 	s87load.m - 	loads salt, temp, press, data from s87 file
% 	s87loadn.m - 	new version of s87load (returns all data)
%	s87loads.m -	easiest s87load - just the s,t,p matrix
%	besttics.m -	tics best time series at one month intervals
%	ctdstats.m -	two layerstats on ctd data
%	loadies.m -	load inverted echosounder data
%	lineload.m -	loads s87 data from filename expression
% 	loadxbts.m - 	loads s87 data (see lineload ?)
% 	s87write.m - 	write data in s87 format (D. Byrne)
%
% SFRI Data Handling
%	ctpload.m -	load p,t,c data from mislabelled CTD data file
%	ctp2s87.m -	writes mislabelled CTD data to s87 file
%	pjcload.m -	load s,t,p data from pjc CTD file (v. rudimentry)
%	sfriload.m -	load s,t,p data from pjc CTD file (handles header)
%	sfri2s87.m -	writes pjc CTD file data to s87 file
%	tapeload.m -	load s,t,p data from CDS tape file
%	tape2s87.m -	writes CDS tape file data to s87 file
%	v080load.m -	load s,t,p data from ascii CTD data file
%	v0802s87.m -	writes ascii CTD file data to s87 file
%
% OceanSoft Data Handling
%	ascload.m -	loads data from oceansoft .asc file
%	prsload.m -	loads data from oceansoft .prs file
%	prs2s87.m -	write data from oceansoft .prs file to .s87 file
%
% SeaSoft Data Handling
%	seasoftn.m -	loads data from seasoft .cnv file, returns all data
%	seasofts.m -	loads s,t,p data from seasoft .cnv file 
%			(uses seasoftn.m)
%	cnv2s87.m - 	write data from seasoft .cnv file to .s87 file
%
% Service Data Format 
% 	srvread.m -  	read service data file
% 	srvread.m - 	display SERVICE format file
%
% NetCDF Data Format
% 	loadcdf.m - 	function to load a netcdf file into
% 			Matlab variables (D. Byrne)
%
% WOCE Data Format
% 	woceconvert.m - ? (D. Byrne)
% 	wocehdr.m - 	? (D. Byrne)
% 	woceload.m - 	loads data from WOCE format file
%
% Seward Johnson SJ9705 Cruise
%	sjctd.m -	loads CTD data from .asc file (SeaSoft CTD)
%	sjxbt.m -	loads XBT data from .edf file
%
% Satellite data
% 	jason.mat - 	TP/Jason track data (D. Byrne)
% 	tptrack.m - 	Plot TP/Jason groundtracks (D. Byrne)
% 	tplabel.m - 	Label TP/Jason groundtracks (D. Byrne)
% 	tpgetx.m - 	Get longitudes of TP/Jason data points (D. Byrne) 
% 	tpgety.m - 	Get latitudes of TP/Jason data points (D. Byrne) 
%
% Signal Processing
%	coslan.m -	cosine-lanczos filter
%	blockmean.m - 	reduces data by taking mean of blocks
%	ave.m - 	takes running mean of a vector
%	mfiltfilt.m -	filtfilt on matrix (filtfilt only works on vector)
% 	fourier.m - 	discrete fourier transform (real part) (D. Byrne)
%
% Statistics
% 	myboxplot.m - 	box-whisker plot of data
% 	stats.m - 	does columnwise simple stats on NaN-containing matrix 
%	ave.m - 	takes running mean of a vector
%	lottery.m - 	generates lottery numbers
%	minmax.m -	returns minimum and maximum of a matrix (D.Byrne)
%	maxi.m -	NaN insensitive max
%	mini.m -	NaN insensitive min
%	sumi.m -	Sum of elements, ignoring NaN
%	normaliz.m -	subtract mean and divide by std deviation (D.Byrne)
%	mdiff.m - 	difference from the mean
%	regress.m -	least squares linear regression with errors
%	iregress.m - 	iterative Model I least squares solution (D.Byrne)
%	regrplot.m -	plots linear regression on current plot
%	range.m -	returns columnwise range of data 
%	scale.m -	scale data to a range
%	cases.m -	count and stats of the number of cases in a dataset
%	weight.m -	weight stp data by numbers
% 	prctl05.m -	return nn'th percentile 
% 	prctl25.m -	return nn'th percentile 
% 	prctl75.m -	return nn'th percentile 
% 	prctl95.m -	return nn'th percentile 
% 	deming.m - 	Deming regression (lin.regr with errors in x and y).
% 	york_fit.m - 	does the same as Deming regression? (iterative technic)
% 
% Additions to CircStat Toolbox
% 	circ_prctile.m - returns P percentiles of circular data in X (radians)
%	d_circ_mean.m - circular percentiles in degrees
% ADCP Data Processing and Visualization
%	adcpvert.m -	
%	adcpview.m -	
%
% Graphics Functions
%	annotate.m -	write a multiple line annotation on a plot
% 	xaxis.m -	updates only the x axis
% 	yaxis.m - 	updates only the y axis
%	shfcolor.m -	rotates color map
%	geoplot.m -	plot ordered pairs (instead of columnwise)
%	coast.m -	plots a coastline on the current plot (requires GMT)
%	makeclip.m -	aids in generating a clip path
%	line2pt.m -	calculates and plots a line defined by two points
% 	mybox.m - 	draws a rectangle
% 	ecolorbar.m - 	adds a colorbar (T. Farrar)
% 	viewpnt.m - 	UI Controls to adjust graphic viewpoint (D. Byrne)
% 	mtit.m	- 	plot a main title for figure with subplots
% 	fig_publish.m -	prepare figure for publication, setting fonts and sizes
% 	yline.m -	plot lines on the current axes parallel to the absciss
%
% General
%	cformat.m -	help file for c format identifiers
%	cummean.m -	cummulative mean
% 	day2date.m -	returns year month day 
%	date.m -	fix for matlab/toolbox/elmat/date.m
% 	date2day.m -	returns day of year 
% 	datec.m -	returns year month day (obsolete)
%	disclaim.m -	function template. not executable
%	defaultc.m -	displays the default color order
%	dow.m -		returns day of week
%	edit.m -	starts an external editor
%	form.m -	builds a format specifier for sprintf
%	less.m -	starts an external file display program
%	man.m -		synonym for 'help'
%	parsepos.m -	parses a generic position (lat/long) string
%	scratch.m -	empty work area
%	timefrac.m -	time as a fraction of the year
%	varname.m -	extracts a MATLAB variable name from a pathstring
% 	yearday.m -	returns day of year (obsolete)
%	sscanf_.m -	substitute for sscanf built-in which is broken
%			on some OSs
%	dirlist.m -	parses an expression and returns a directory listing
% 	unwrapd.m -	unwraps phase angle (in degrees)
%	
% 	parsdate.m - 	determine date re;presented byy a string
%	findrow.m - 	finds a row in a matrix	
% 	sizeof.m - 	returns the size in bytes of the argument
% 	runstats.m - 	running mean and std deviation of a series
% 	gregorian.m - 	convert to gregorian date
% 	julian.m - 	convert to julian date
% 
%	num2cellstr - 	converts a number matrix to a cell matrix of strings
% 	cell2str.m -	returns strings from cell items
% 	cellmax.m -	returns the maxima of the cell argument
% 	cellmedian.m -	returns the median of the cell argument
% 	cellmin.m -	returns the minimum of the cell argument
% 
% 	showme.m - 	quick plots of the contents of structures
%
%	hints.m -	some hints and tips
%
% 	catenary.m - 	find depth of sensors assuming catenary
% 
% Trivial
%	second.m -	returns 1 (number of seconds per second)
%	minute.m -	returns 60 (number of seconds per minute)
%	hour.m -	returns 3600 (number of seconds per hour)
%	day.m -		returns 86400 (number of seconds per day)
% 	hms2h.m - 	convert hr, min, sec to decimal hours
% 	s2hms.m - 	convert seconds to hr, min, sec
% 
% Other
%	mygrid_sand.m -	reads an img data file, usu. Smith and Sandwell topog
%
% Not My Own Work
% ---------------
% A listing of programs placed here, but not written by me
%
% 	jason.mat - 	TP/Jason track data (D. Byrne)
% 	tptrack.m - 	Plot TP/Jason groundtracks (D. Byrne)
% 	tplabel.m - 	Label TP/Jason groundtracks (D. Byrne)
% 	tpgetx.m - 	Get longitudes of TP/Jason data points (D. Byrne) 
% 	tpgety.m - 	Get latitudes of TP/Jason data points (D. Byrne) 
% 	s87write.m - 	write data in s87 format (D. Byrne)
%	normaliz.m -	subtract mean and divide by std deviation (D.Byrne)
%	minmax.m -	returns minimum and maximum of a matrix (D.Byrne)
%	iregress.m - 	iterative Model I least squares solution (D.Byrne)
% 	fourier.m - 	discrete fourier transform (real part) (D. Byrne)
% 	ecolorbar.m - 	adds a colorbar (T. Farrar)
% 	loadcdf.m - 	function to load a netcdf file into Matlab 
% 			variables (D. Byrne)
% 	viewpnt.m - 	UI Controls to adjust graphic viewpoint (D. Byrne)
% 	polargeo.m - 	polar plot with 0 to the north (Mathworks)
% 	suplabel.m - 	plot figure labels for figures with several subplots
% 	suplabel_test.m test for suplabel
% 	mtit.m	- 	plot a main title for figure with subplots
% 	unfold.m - 	display contents of a structure 
% 
% Uncertain (origin and function!)
% ---------
% 
%	vectint.m -	interpolates between two (complex) vectors
% 	apriori.m - 	error estimate (?)
% 	apriorierr.m - 	error estimate (?)
% 

% NB Things To Do - remove mld1.m from master version

% PROGRAM - 	MATLAB code (mostly) by c.m.duncombe rae
%
% PROG MODS -	
%
%
%     These programs are free software except where individually
% noted in the files: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published
% by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
% 
%     The programs are distributed in the hope that they will be
% useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public
% License along with this program.  If not, see
% <http://www.gnu.org/licenses/>.
% 
% See accompanying script gpl-3.0.m
% 
%
% 

%
%  USEFUL Routines V1.2a
%  USEFUL Toolbox originally begun at L-DEO during 1994/1995. 
%  Author:	Chris Duncombe Rae
%  Address:	SFRI, PBag X2, Roggebaai 8012, SOUTH AFRICA
%  Previously at:	SMS, U. Maine, Orono, Me., USA
%  Now at:	WHOI, Mass., USA
%
%  Update Record:
%	96-09-04: Add showctd.m and overctd.m
%		  Remove L.m and W.m
%	96-08-27: Add pjcload.m and sfriload.m
%		  cchk.m deleted - seems to be a copy of mchk
%  		  disclaimer added to all routines
%	97-05-06: Add seasoft routines and other changes made on 
%		  Fridtjof Nansen cruise
%	97-10-17: Add CTD and XBT routines from Seward Johnson cruise
%	98-09-28: Add sfri2s87 routine; improvements to sfriload
%	98-10-16: Add views87s routine
% 	98-10-22: Add ctpload.m, ctp2s87.m
%	98-10-25: Add presfilt.m
%	98-11-09: Add v080load.m and v0802s87.m
%	98-11-11: Add timefrac.m, some cosmetics
%	99-02-15: Add prsload.m for oceansoft .prs files
%	99-02-23: Add prs2s87.m for oceansoft .prs files
%	99-05-06: Include mygrid_sand.m for img topog files
%	99-05-06: Add pycnoc.m
%	99-07-13: Add parsepos.m
%	00-01-14: Add isopycnal.m
%	00-03-24: A number of conversion functions added and fix for date
%	00-05-05: Add coast.m
%	?
%	01-01-29: Trivial functions minute hour and day
%	01-08-30: Trivial functions second, ctdref
%	          Add ssccanf_.m substitute for sscanf built-in
%	01-10-17: Mixed layer functions, split out dirlist from views87s
%	02-03-31: line2pt
%	02-06-11: Up to date the Contents file: Adding stepts and cases
%	02-12-06: Up to date the Contents file: Adding tfromds and sortstr
%	2003-09-04: Adding sfromdt.m
%	2003-10-16: Adding lucorc.m
%	2004-03-18: Catching up: behind on lots of stuff. Added several.
%	2005-03-29: Contents up to date: adding several.
% 	2008-03-14: Adding mdiff
% 	2008-09-08: Uptodate Contents.m file, throwing out some trash
%	2009/03/12: Uptodate Contents file 
% 	2010/10/08: Add GPL (license info)
% 	2010/10/09: Update Contents.m
% 	2010/10/19: Add num2cellstr.m 
% 	2010/10/21: add unwrapd 
% 	2010/11/12: move publish.m to fig_publish.m (conflict with Matlab function)
% 	2010/11/19: regressions for data with errors in X and Y
% 	2010/12/01: circular percentiles functions 
% 



