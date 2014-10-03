function [pos, data, sound] = pjcload (str,confirm)
% PJCLOAD - 	loads data from pjc ascii format file into variables named 
% 		according to s87 format data specifiers
%
% USAGE - 	[pos, stp_data, sounding] = pjcload(str,confirm);
% 
% EXPLANATION -	pos:	position (complex, pos = longitude+sqrt(-1).*latitude )
%		header:	string matrix containing file headers
%		sa, te, pr, de:	salt temperature, pressure and depth data
%		str:	filename of s87 file containing data
%		confirm:Boolean (1,[0]): write filename on open  
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 94-12-01, sfri & ldeo
%
% PROG MODS	96-02-09: rewritten for sfri data
%		
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

% open data file

	fidd = fopen(str);
	if ~exist('confirm'), confirm = 0; end;
	if confirm, disp(str); end;
% get first header from file, cut out position

	for i = 1:6, 
		rec = fgetl(fidd); 
	end;
	lat=str2num(rec(23:24))+str2num(rec(26:30))./60;
	rec = fgetl(fidd); 
	lon=str2num(rec(23:25))+str2num(rec(27:31))./60;
	pos = sqrt(-1)*lat+lon;

	rec = fgetl(fidd); 
	sound=str2num(rec(23:length(rec)));

% read the rest of the headers until the data identification line is reached

	while any(rec(1:2) ~= '#3'),
		rec = fgetl(fidd);
	end;
		rec = fgetl(fidd);
		rec = fgetl(fidd);

% cut out the variable identifiers
	data=[];
	dat=[1 2 3 4];
	while ~xor(any(dat~=-2),any(dat~=-1)), % rec(1)~='#',
		rec = strrep(rec,[32],[9]);
		while findstr(rec,[9 9]) ~= [], rec = strrep(rec,[9 9],[9]); end;
		I=findstr(9,rec);
		J= [ I(2:length(I)) length(rec)];
		dat=[];
		for i=1:length(I), 
			dat= [dat str2num(rec(I(i):J(i)))];
		end;
		data=[data;dat(4),dat(2),dat(1)];
		rec = fgetl(fidd);
	end;
	data=data(1:length(data)-1,:);

% go back

	fclose(fidd);
	return;

