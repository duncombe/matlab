function [stp,stn,grid,dd,dt,lat,lon,sndg,datrec]=v080load(str)
% V080LOAD -	loads data from Voyage 080 format CTD file
%
% USAGE -	[stp,stn,grid,dd,dt,lat,lon,sndg]=v080load(str)
%
% EXPLANATION -	stp
%		stn
%		grid
%		dd
%		dt
%		la
%		lo
%		sndg
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	98-11-02
%
% PROG MODS -	
%  2012-05-03 
% 	close the file that was opened
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

fidd=fopen(str);

%
% Station:	9838

rec=fgetl(fidd);
[s1,stn]=strtok(rec);

%
% Grid:	2

rec=fgetl(fidd);
[s1,grid]=strtok(rec);

%
% Latitude:	 32	58.14

rec=fgetl(fidd);
[s1,s2]=strtok(rec);
[s3,s4]=strtok(s2);
n3=str2num(s3);
n4=str2num(s4);
lat=sign(n3).*(abs(n3)+abs(n4)./60);

%
% Longitude:	  7	15.64

rec=fgetl(fidd);
[s1,s2]=strtok(rec);
[s3,s4]=strtok(s2);
n3=str2num(s3);
n4=str2num(s4);
lon=sign(n3).*(abs(n3)+abs(n4)./60);

%
% Date:	 900214	99:99

rec=fgetl(fidd);
datrec=rec;
[s1,s2]=strtok(rec);
[s3,s4]=strtok(s2);
dd=[str2num(['19' s3(1:2)]) str2num(s3(3:4)) str2num(s3(5:6))];
[s5,s6]=strtok(s4,':');
[s7,s8]=strtok(s6,':');

if isempty(s7), s7=s5; s5='0'; end;
dt=[str2num(s5) str2num(s7)];

dt(1)=dt(1)-2;
if dt(1)<0,
	dt(1)=dt(1)+24; dd(3)=dd(3)-1; 
	if dd(3)<=0, disp('CHANGE the month');
	end;
end;

%
% Sounding:	5100

rec=fgetl(fidd);
[s1,s2]=strtok(rec);
sndg=str2num(s2);

%
% Height above bottom:	9838

rec=fgetl(fidd);
[s1,s2]=strtok(rec);
zm=str2num(s2);

% @

rec=fgetl(fidd);

[D,C]=fscanf(fidd,form(3),[3,inf]);
stp=D([3,2,1],:)';

if fidd>2, fclose(fidd); end 

return;


