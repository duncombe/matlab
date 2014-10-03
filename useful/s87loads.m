function [stp, pos, tim, header, stn, grd ] = s87loads(str)
% S87LOADSTP - 	loads data from s87 format file into s,t,p matrix
%
% USAGE - 	[stp, pos, tim, header, stn, grd] = s87loads(str);
% 
% EXPLANATION -	stp:	matrix of [ salt, temp, pres ];
%		pos:	position (complex, pos = longitude+sqrt(-1).*latitude )
%		tim:	station time
%		header:	header block
%		stn:	station field from header
%		grd:	grid field from header
% 
% 		Somewhat more generalized program, loads one file
% 		at a time, returns stpo matrix only. Use instead
% 		s87loader.m
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 94-12-01, sfri & ldeo
%
% PROG. MODS.	94-12-20: change to give header instead of variables
%		95-03-13: return s t p in matrix
%		96-05-24: clear inconsistencies, return header as well.
%		98-10-05: deblank var ident line
% 		99-10-27: allow for pressure variable being absent
%		2001-08-20: allow for bad salinity data
%		2001-10-17: return also station and grid fields
%		2005-03-25: fix complaints about integers in strings (char)
% 		2005-03-29: fix complaints about output not assigned
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
	while ~isempty(findstr(rec,[9 9])),
		rec = strrep(rec,char([9 9]),char([9]));
	end;
	irec = findstr(rec,[9]); irec=[irec length(rec)];
	pos = 	sqrt(-1)*str2num(rec(:,irec(3):irec(4))) + ...
		str2num(rec(:,irec(4):irec(5)));
	dat = rec(irec(5)+1:irec(6));
	hr = rec(irec(7)+1:irec(8)); 
%	disp([dat,hr])
% allow for bad date time values
	if size(dat,2)<8,
		disp([str ': Bad date value: trying to parse "' dat '"']); 
		dat='00/00/00'; 
	end;
	if size(hr,2)<5,
		disp([str ': Bad time value: trying to parse "' hr '"']);
		hr='00:00';
	end;
	[s1,s2]=strtok(dat,'/-.');
	[s2,s3]=strtok(s2,'/-.');
	s3=strtok(s3,'/-.');
%	disp([s1,s2,s3])
	[h1,h2]=strtok(hr,':');
	h2=strtok(h2,':');
	tim = [ str2num(setstr(s1)) ...
		str2num(setstr(s2)) ...
		str2num(setstr(s3)) ...
		str2num(setstr(h1)) ...
		str2num(setstr(h2)) ];

% read the rest of the headers until the data identification line is reached

	while rec(1) ~= '@',
		rec = fgetl(fidd);
		header = [ header [10] rec ];
		end;

% cut out the variable identifiers

%	rec = strrep(rec,[9],[32]);
%	rec=deblank(rec);
%	rec = strrep(rec,[32],[9]);
%	while ~isempty(findstr(rec,[9 9])), rec = strrep(rec,[9 9],[9]); end;
%
%%	if isempty(rec(length(rec))), rec=rec(1:length(rec)-1); end;
%%	while rec(length(rec)==9), rec=rec(1:length(rec)-1); end;
%%	if rec(2)~=9, rec(1)=9; rec=['@' rec]; end;
%	nvars = floor(length(rec)/3);
%%	disp(nvars);
%%	vars = (reshape([lower(rec(2:(3.*nvars+1))) ],3,nvars))';
%	vars = (reshape([lower(rec(2:length(rec))) 9],3,nvars))';
	s2=lower(rec(2:length(rec)));
	nvars=0;
	[s1,s2]=strtok(s2);
	while ~isempty(s1),
		nvars=nvars+1;
		vars(nvars,:)=s1;
		[s1,s2]=strtok(s2);
	end;
	
%% exit with vars = matrix of [nvars,3];
% build the format specifier for reading the data

	fspec = []; for iii = 1:nvars-1, fspec = [fspec '%g\t']; end;
	fspec = [fspec '%g\n'];

% load the data into D

	[D,C] = fscanf(fidd,fspec,[nvars,inf]);
	D=D';
	J=find(D<=-9);D(J)=NaN.*J;
% put the data into individual vectors

	clear te pr sa de;

%	nvars
%	vars
%	size(D) 
	for ii = 1:nvars,
%		ii
%		vars(ii,:)
		eval( [ vars(ii,:) '= D(:,ii);']);	
	end;
	baddata=0; badsa=''; badte='';badpr='';badox='';
	if ~exist('ox'), ox=NaN.*ones(size(D,1),1); badox=' ox'; baddata=1; end;
	if ~exist('te'), te=NaN.*ones(size(D,1),1); badte=' te'; baddata=1; end;
	if ~exist('sa'), sa=NaN.*ones(size(D,1),1); badsa=' sa'; baddata=1; end;
% allow for pressure/depth variable being absent
	% if ~exist('de') & exist('pr'), pr=sw_dpth(de,imag(pos)); end;
	if ~exist('pr') & exist('de'), pr=sw_pres(de,imag(pos)); end;
	if ~exist('pr'), pr=NaN.*ones(size(D,1),1); badpr=' pr'; baddata=1; end;

	stp=[sa,te,pr,ox];

	if baddata==1,
		disp(['Data column missing from ' str ':' badsa badte badpr badox ]);
	end;

% find station and grid
	hdr=header;
	[stn,hdr]=strtok(hdr);
	[stn,hdr]=strtok(hdr);
	[grd,hdr]=strtok(hdr);

% go back

	fclose(fidd);
	return;

