function [ STP, stn, grid, dd, dt, la, lo, sndg ]=sfriload(str)
% SFRILOAD -	Loads SFRI ascii CTD data
%
% USAGE - 	[STP,stn,grid,dd,dt,la,lo,sndg]=sfriload(str)
%		Input:	str - filename string
%		Output:	STP - Salt, temp, pressure
%			stn - Ships station number
%			grid - Grid number
%			dd - Date array [ye, mo, da]
%			dt - Time array [ho, mi, ss]
%			la - Latitude (decimal degrees)
%			lo - Longitude (decimal degrees)
%			sndg - Sounding
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 96-08-27, sfri
%
% PROG MODS -	1998-09-28 cmdr: generalise latitude and longitude conversion
%			(using strtok)
%		2000-07-24: generalise reading the data to account for 
%			case where there are no bottle data flags.
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


% open data file

	fidd = fopen(str);

% get first header from file
	rec = fgetl(fidd);	% #1---------Header Block
	rec = fgetl(fidd);	% Station number      : 

	if length(rec)<29, disp([str ': Station number not found.']); stn=NaN; else stn=rec(23:29); end;

	rec = fgetl(fidd);	% Grid position       :

	% grid=str2num(rec(23:25));
	strrec=strrep(rec,':',' ');
	strrec(find(isletter(strrec)))=[];
	strrec(find(isspace(strrec)))=[];
	grid=str2num(strrec);


	rec = fgetl(fidd);	% Starting Date       :
	
	if length(rec)<32, disp([str ': Starting date not found.']); dd=[1999 12 31];  else
		dd=[str2num(rec(29:32)) str2num(rec(26:27)) str2num(rec(23:24))];
	end;

	rec = fgetl(fidd);	% Starting time       :

	if length(rec)<30, disp([str ': Starting time not found.']); dt=[23 59 59]; else
		dt=[str2num(rec(23:24)) str2num(rec(26:27)) str2num(rec(29:30)) ];
	end;

	rec = fgetl(fidd);	% Latitude            :

%	la=str2num(rec(23:24))+(str2num(rec(26:30))./60) ;
	if length(rec)<23, 
		la=[]; 
	else
		strrec=upper(strrep(rec,' ',[9]));
		[s1,s2]=strtok(strrec);
		[s1,s2]=strtok(s2);
		signl=1-isempty(findstr('N',s2)).*2;
		s2(find(isletter(s2)))=[];
		[s1,s2]=strtok(s2);
		la=signl.*(str2num(s1)+str2num(s2)./60);
		clear s1 s2 signl
	end;

	if isempty( la),
		disp([str ': Latitude not found.']); 
		la = NaN;
	end;

	rec = fgetl(fidd);	% Longitude           :

%	lo=str2num(rec(23:25))+(str2num(rec(27:31))./60) ;
	if length(rec)<23, 
		lo=[]; 
	else
	strrec=upper(strrep(rec,' ',[9]));
	[s1,s2]=strtok(strrec);
	[s1,s2]=strtok(s2);
	signl=isempty(findstr('W',s2)).*2-1;
	s2(find(isletter(s2)))=[];
	[s1,s2]=strtok(s2);
	lo=signl.*(str2num(s1)+str2num(s2)./60);
	clear s1 s2 signl
	end;
	if isempty( lo),
		disp([str ': Longitude not found.']); 
	lo = NaN; end;

	rec = fgetl(fidd);	% Sounding            :

	sndg =str2num(rec(23:length(rec))); 
	if isempty( sndg), sndg = NaN; end;

	rec = fgetl(fidd);	% #2---------Calibration constants:
	rec = fgetl(fidd);	% Calibration date    :
	rec = fgetl(fidd);	% Underwater Unit     :
	rec = fgetl(fidd);	% Std Salinity Sample :
	rec = fgetl(fidd);	% Conductivity        :
	rec = fgetl(fidd);	% Temperature         : 
	rec = fgetl(fidd);	% Pressure            :
	rec = fgetl(fidd);	% #3---------Data Block
	rec = fgetl(fidd);	%    Depth    Temp     Conduc    Salin     Wire out    Load

% load the data into D
	D=[];

% The loop is the inefficient slow way which is needed for some data sets

% The indented is common code to both the inefficient way and the efficient way
	rec=fgetl(fidd);
  while isempty(findstr(rec,'--')), 
  stp=[];
	a2=rec;
	while ~isempty(a2),
		[a1,a2] = strtok(a2); 
		if isstr(a1),
		  stp = [stp,str2num(a1)];
		else
		  stp=[stp, a1];
		end;
	end;
	if isstr(a2),
	  stp = [stp,str2num(a2)];
	else
	 stp=[stp, a2];
	end;
  if ~isempty(D),
    while size(stp,2) < size(D,1),
      stp=[stp,0];
    end; 
  end;
  D=[D stp.'];
%	n=length(stp);
  rec=fgetl(fidd);
  end;
	
% This is the efficient way. Unfortunately it is broken for some stations.
%	fspec = [reshape([setstr(ones(n,1)*'%g')]',1,n.*2) '\n'];
%	[D,C] = fscanf(fidd,fspec,[n,inf]);
%	D=[stp', D];

	STP = [D(4,:).' D(2,:).' D(1,:).'];
	I = find(STP(:,1)==-2);
% if I is empty, then we check for another flag. if that flag is also 
% not found we want STP as it is, otherwise we want STP from the beginning 
% to the first I found.
	if isempty(I), I=find(STP(:,1)==-1); end;
	if ~isempty(I), STP = STP(1:I-1,:); end;

% go back

	fclose(fidd);
	return;

