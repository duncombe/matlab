function [vars,pos,date] = seasofth(str)
% SEASOFTH - 	parses header from seasoft file 
%
% USAGE - 	[ ] = s87loadh(str);
%
 
% EXPLANATION -	data:	matrix containing data
%		vars:	matrix containing lower-case variable names and order 
%			within data
%		pos:	position (complex, pos = longitude+sqrt(-1).*latitude ) 
%		header:	string matrix containing file headers
%		str:	filename of s87 file containing data
%
% PROGRAM - 	MATLAB code by c.m.duncombe rae, 97-04-14, sfri 
%		(on board "Dr Fridtjof Nansen")
%		
% Example -	to load data from a file 'test.s87' and put data into 
%		vectors named according to s87 format identifiers:
% 		
%			[D vars pos] = s87loadn('test.s87');
%			latitude = imag(pos); longitude = real(pos);
%			nvars=size(vars,1);
%			for ii = 1:nvars,
%				eval( [ vars(ii,:) '= D(:,ii);']);	
%			end;
%			plot(te,-pr);


%
%     This program is free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of
% the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be
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

% str		: string for s87 data file name
% fidd		: handle to str (s87 file containing data)
% te 		: temperature data (raw from datafile)
% pr		: pressure (raw from datafile)
% sa		: salinity (raw from datafile)
% de		: depth (raw from datafile)
% rec		: string record for data from s87 datafile
% nvars		: number of variables in s87 file
% vars		: variables in s87 file
% fspec		: format specification for data input from s87 file

% SEASOFT Data Format
% File consists of 
%	A series of * headers giving station data
%	A series of # headers giving info about data
%	A line with *END* indicating the beginning of the data
%
%
%	* Sea-Bird SBE 9 Raw Data File:
%	* FileName = C:\SEABIRD\DATA\STA0366.DAT
%	* Software Version 4.217
%	* Temperature SN = 1166
%	* Conductivity SN = 1149
%	* Number of Bytes Per Scan = 15
%	* Number of Voltage Words = 1
%	* System UpLoad Time = Mar 18 1997 18:57:13
%	* NMEA Latitude = 17 05.86 S
%	* NMEA Longitude = 011 43.29 E
%	* NMEA UpLoad Time = not available
%	* Store Lat/Lon Data = Add to Header Only
%	* SHIP:    14            
%	* Station:   0366        
%	* Echodepth:  25         
%	* Log:  439.45           
%	* Wind dir/force: 18 15  
%	* Air temp: 17           
%	* Weather Sky: 2 4       
%	* Sea: 3                 
%	# nquan = 13
%	# nvalues = 16                          
%	# units = metric
%	# name 0 = scan: scan number
%	# name 1 = pr: pressure [db]
%	# name 2 = t068: temperature, IPTS-68 [deg C]
%	# name 3 = c0S/m: conductivity [S/m]
%	# name 4 = oxT: oxygen, temperature [deg C]
%	# name 5 = oxC: oxygen, current [ÊA]
%	# name 6 = sal00: salinity, PSS-78 [PSU]
%	# name 7 = oxML/L: oxygen [ml/l]
%	# name 8 = svW: sound velocity, wilson [m/s]
%	# name 9 = sal00: salinity, PSS-78 [PSU]
%	# name 10 = oxML/L: oxygen [ml/l]
%	# name 11 = svW: sound velocity, wilson [m/s]
%	# name 12 = flag:  0.000e+00
%	# span 0 = -362, 954                    
%	# span 1 = 2.000, 17.000                
%	# span 2 = 17.2775, 17.7370             
%	# span 3 = 4.569231, 4.590291           
%	# span 4 = 18.59574, 18.79914           
%	# span 5 = 0.36476, 0.67541             
%	# span 6 = 35.0512, 35.6315             
%	# span 7 = 2.32657, 5.00444             
%	# span 8 = 1515.30, 1515.91             
%	# span 9 = 35.0513, 35.6267             
%	# span 10 = 2.38269, 4.97896            
%	# span 11 = 1515.29, 1515.91            
%	# span 12 = 0.000e+00, 0.000e+00        
%	# interval = decibars: 1                                
%	# start_time = Mar 18 1997 18:57:13
%	# bad_flag = -9.990e-29
%	# sensor 0 = Frequency  0  temperature, 1166, 17-Feb-96s
%	# sensor 1 = Frequency  1  conductivity, 1149, 16-Feb-96s, cpcor = -9.5700e-08
%	# sensor 2 = Frequency  2  pressure, 53966, 17.06.93
%	# sensor 3 = Extrnl Volt  0  oxygen, current, 130367, 18 november  1994
%	# sensor 4 = Extrnl Volt  1  oxygen, temperature, 130367, 18 november  1994
%	# datcnv_date = Apr 04 1997 09:23:56, 4.217
%	# datcnv_in = STA0366.DAT NANSEN.CON
%	# datcnv_skipover = 0
%	# wildedit_date = Apr 04 1997 09:24:03, 4.217
%	# wildedit_in = STA0366.CNV
%	# wildedit_pass1_nstd = 2.0
%	# wildedit_pass2_nstd = 20.0
%	# wildedit_npoint = 10
%	# wildedit_vars = pr t068 c0S/m oxT oxC sal00 oxML/L svW
%	# wildedit_excl_bad_scans = yes
%	# celltm_date = Apr 04 1997 09:24:07, 4.217
%	# celltm_in = STA0366.CNV
%	# celltm_alpha = 0.0300, 0.0000
%	# celltm_tau = 9.0000, 0.0000
%	# filter_date = Apr 04 1997 09:24:12, 4.217
%	# filter_in = STA0366.CNV
%	# filter_low_pass_tc_A = 0.030
%	# filter_low_pass_tc_B = 0.150
%	# filter_low_pass_A_vars = c0S/m
%	# filter_low_pass_B_vars = pr
%	# loopedit_date = Apr 04 1997 09:24:16, 4.217
%	# loopedit_in = STA0366.CNV
%	# loopedit_minVelocity = 0.100          
%	# loopedit_excl_bad_scans = yes
%	# derive_date = Apr 04 1997 09:24:21, 4.217
%	# derive_in = STA0366.CNV NANSEN.CON
%	# derive_time_window_docdt = seconds: 2
%	# binavg_date = Apr 04 1997 09:24:26, 4.217
%	# binavg_in = STA0366.CNV
%	# binavg_bintype = Pressure Bins
%	# binavg_binsize = 1.00
%	# binavg_excl_bad_scans = yes
%	# binavg_downcast_only = no
%	# binavg_skipover = 0
%	# binavg_surface_bin = yes, min = 0.300, max = 0.500, value = 0.000
%	# file_type = ascii
%	*END*
%	       -362      2.000    17.7347   4.569519   18.79914    0.67178    35.0566    4.92550    1515.82    35.0569    4.90044    1515.82  0.000e+00
%	        399      3.000    17.7316   4.569386   18.67382    0.66955    35.0581    4.90094    1515.83    35.0580    4.92091    1515.83  0.000e+00
%	


mnth=['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
%
% open data file
%
	fidd = fopen(str);
%
% get first header from file
%
	rec = fgetl(fidd);
%
%  parse headers
%
	while (rec(1)=='*' | rec(1)=='#'),

%
% VARS
%
		if strcmp(rec(1:min(size(rec,2),6)),'# name'), 
			strrec= strrep(rec,' ',[9]);
			while findstr(strrec,[9 9]) ~= [], 
				strrec = strrep(strrec,[9 9],[9]); 
			end;
			irec = findstr(strrec,[9]);
			order=[order str2num( strrec( irec(1):irec(2) ))];
			name=strrec( irec(4)+1:irec(5)-1);
			if 	strcmp(name,'t068:'), 	vars=[vars; 'te'];
			elseif	strcmp(name,'sal00:'), 	vars=[vars; 'sa'];
			elseif	strcmp(name,'pr:'),	vars=[vars; 'pr'];
			elseif	strcmp(name,'oxML/L:'),	vars=[vars; 'ox'];
			else			 	vars=[vars; 'un'];
			end;
		end;

%
% LONG
%
		if strcmp(rec(1:min(size(rec,2),16)),'* NMEA Longitude'), 
			strrec= strrep(rec,' ',[9]);
			while findstr(strrec,[9 9]) ~= [], 
				strrec = strrep(strrec,[9 9],[9]); 
			end;
			irec = findstr(strrec,[9]);
			lon = str2num( strrec( irec(4): irec(5)))+ str2num( strrec( irec(5): irec(6)))./ 60;
			if strcmp(strrec(irec(6)+1:length(strrec)),'W'), 
				lon=-lon; 
			end;
%			sprintf('%g\n',lon),			
		end;

%
% LAT
%
		if strcmp(rec(1:min(size(rec,2),15)),'* NMEA Latitude'), 
			strrec= strrep(rec,' ',[9]);
			while findstr(strrec,[9 9]) ~= [], 
				strrec = strrep(strrec,[9 9],[9]); 
			end;
			irec = findstr(strrec,[9]);
			lat = str2num( strrec( irec(4): irec(5)))+ str2num( strrec( irec(5): irec(6)))./ 60;
			if strcmp(strrec(irec(6)+1:length(strrec)),'S'), lat=-lat; end;
%			sprintf('%g\n',lat),			
		end;

% this is for time but i can't be bothered to make it work right now

%
% DATE
%
		if strcmp(rec(1:min(size(rec,2),12)),'# start_time'), 
			strrec= strrep(rec,' ',[9]);
			while findstr(strrec,[9 9]) ~= [], 
				strrec = strrep(strrec,[9 9],[9]); 
			end;
			irec = findstr(strrec,[9]);
%			disp(strrec);
% month
			for i=1:12, 
				if strcmp(strrec(irec(3)+1:irec(4)-1),mnth(i,:)), 
					date(2)=i; 
				end; 
			end;
% day
			date(3)=str2num(strrec(irec(4):irec(5)));
% year
			date(1)=str2num(strrec(irec(5):irec(6)));
% hour minute second 
			date(4:6)=[str2num([strrec(irec(6)+[1 2]); ...
					    strrec(irec(6)+[4 5]); ...
					    strrec(irec(6)+[7 8])] )]';

%			sprintf('%g\n',lat),
		end;


% parse rec
		rec = fgetl(fidd);
	end;

%
% parsing data
%
	if exist('lat','var')==1 && exist('lon','var')==1
		pos=lat.*sqrt(-1)+lon;
	else
		pos=NaN;
	end
%	nvars=size(vars,1);
%
% all the preceding was for the headers.
% the rest is for the data
% so for this module skip it.
%
%	fspec = []; for iii = 1:nvars-1, fspec = [fspec '%g\t']; end;
%	fspec = [fspec '%g\n'];
%	[D,C] = fscanf(fidd,fspec,[nvars,inf]);
%	data=D';
%
	fclose(fidd);

return;
