function [ STP, stn, grid, dd, dt, la, lo, sndg, AirP, voy ] =tapeload(str,G0)
% TAPELOAD -	Loads SFRI ascii CTD data from tape files
% 		Uses G0=42.909 to calculate salinity.
%
% USAGE - 	[STP,stn,grid,dd,dt,la,lo,sndg,AirP ] =tapeload(str,G0)
%
% EXPLANATION -	Input:	str - filename string
%			G0 - Conductivity constant for the cell.
%			     Defaults to 42.909.
%		Output:	STP - Salt, temp, pressure, conductivity
%			stn - Ships station number
%			grid - Grid number
%			sndg - Sounding
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 98-10-25, sfri
%
% PROG MODS -	
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


if ~exist('G0'), G0=42.909; end;

% open data file

	fidd = fopen(str);

% Read header lines
% Tape file no. :  4 
	rec = fgetl(fidd);
	[s1,s2]=strtok(rec,':'); grid=s2(2:length(s2));
	rec = fgetl(fidd);
	rec = fgetl(fidd);
	rec = fgetl(fidd);
% Title         :                          
% 9** HYDRO LOG **   
% 1  
%23:36:12 11/ 2/1983   
	rec = fgetl(fidd);
	t1=rec(1:2); t2=rec(4:5); t3=rec(7:8);
	dt=[str2num(t1),str2num(t2),str2num(t3)];
	d1=rec(10:11);d2=rec(13:14);d3=rec(16:19);
	dd=[str2num(d3),str2num(d1),str2num(d2)];
%STATION AO819        GRID O13 O52 OO6B  
	rec = fgetl(fidd);
	[s1,s2]=strtok(rec); [stn,s2]=strtok(s2);
	[s1,s2]=strtok(s2); [voy,s2]=strtok(s2);
%N13423.74S 1832.96E   
	rec = fgetl(fidd);
	la=(1-2.*(rec(10)~='N')).*(str2num(rec(3:4))+str2num(rec(5:9))./60);
	lo=(1-2.*(rec(19)~='E')).*(str2num(rec(11:13))+str2num(rec(14:18))./60);
%                                         AIRPRES
%    0.80    0.00   74.70   15.45   18.00 1015.00   15.00   81.36  
	rec = fgetl(fidd);
	s2=rec; metdata=[];
	for i=1:7, [s1,s2]=strtok(s2); metdata = [ metdata; str2num(s1)]; end;
	AirP=metdata(6);
	sndg=NaN;
%
% read the end of cast data
	for i=1:4, rec = fgetl(fidd); end;
%
% read the blank lines
	for i=1:20, rec = fgetl(fidd); end;
%
% read 10 bottle trips
	for i=1:10, rec = fgetl(fidd); end;
%
% load the data into D

	fspec = form(3);
	[D,C] = fscanf(fidd,fspec,[4,inf]);
	D(:,size(D,2))=[];
	STP = [ sw_salt( D(3,:)./G0, D(2,:), D(1,:)); D(2,:); D(1,:); D(3,:)]';


% go back

	fclose(fidd);
	return;

