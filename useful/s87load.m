function [pos, header, sa, te, pr, de, pt, ox] = s87load (str)
% S87LOAD - 	loads data from s87 format file into variables named 
% 		according to s87 format data specifiers
%
% USAGE - 	[pos, header, sa, te, pr, de, pt, ox] = s87load(str);
% 
% EXPLANATION -	pos:	position (complex, pos = longitude+sqrt(-1).*latitude )
%		header:	string matrix containing file headers
%		sa, te, pr, de:	salt temperature, pressure and depth data
%		str:	filename of s87 file containing data
%
% 		Very basic, not generalized. Loads one file at a
% 		time. Use instead s87loader.m
%	

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 94-12-01, sfri & ldeo
%
% PROG MODS	94-12-20: change to give header instead of variables
%		2005/03/25: fix complaints about integers in strings (char)
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

% get first header from file, cut out position

	rec = fgetl(fidd);
	header = rec;
	rec = strrep(rec,' ',char([9]));
	% while findstr(rec,[9 9]) ~= [], rec = strrep(rec,[9 9],[9]); end;
	while ~isempty(findstr(rec,[9 9])),
		rec = strrep(rec,char([9 9]),char([9]));
	end;
	irec = findstr(rec,[9]);
	pos = sqrt(-1)*str2num(rec(:,irec(3):irec(4))) + str2num(rec(:,irec(4):irec(5)));

% read the rest of the headers until the data identification line is reached

	while rec(1) ~= '@',
		rec = fgetl(fidd);
		header = [ header [10] rec ];
		end;

% cut out the variable identifiers

	rec = strrep(rec,char([32]),char([9]));
	while findstr(rec,[9 9]) ~= [], rec = strrep(rec,char([9 9]),char([9])); end;
	nvars = length(rec)/3;
	vars = (reshape([lower(rec(2:length(rec))) 9],3,nvars))';

% build the format specifier for reading the data

	fspec = []; for iii = 1:nvars-1, fspec = [fspec '%g\t']; end;
	fspec = [fspec '%g\n'];

% load the data into D

	[D,C] = fscanf(fidd,fspec,[nvars,inf]);
	D=D';

% put the data into individual vectors

	% clear te pr sa de; 
	te=[]; pr=[]; sa=[]; de=[];
	for ii = 1:nvars,
		eval( [ vars(ii,:) '= D(:,ii);']);	
		end;

% go back

	fclose(fidd);
	return;

