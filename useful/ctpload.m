function [ STP, stn, grid, sndg ] =ctpload(str,G0)
% CTPLOAD -	Loads SFRI ascii CTD data from pre-1991 files
%		Columns labelled DEPTHS TEMP SALT in files are 
%		in reality Pressure, Temp, Conductivity. Uses
% 		G0=42.909 to calculate salinity.
%
% USAGE - 	[STP, stn, grid, sndg ] =ctpload(str,G0)
%		Input:	str - filename string
%			G0 - Conductivity constant for the cell.
%			     Defaults to 42.909.
%		Output:	STP - Salt, temp, pressure, conductivity
%			stn - Ships station number
%			grid - Grid number
%			sndg - Sounding
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 98-10-22, sfri
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

% get first header from file. first 3 lines are 
% PLANKTON   SHIPS    FILE  CTD-C
% STATION    STATION  NO.   XBT-X  SOUNDING
% --------   -------  ----  -----  --------
	rec = fgetl(fidd);
	rec = fgetl(fidd);
	rec = fgetl(fidd);
%
% Read the station info
% 006003     A0257    004     C      165.00
	rec = fgetl(fidd);

	pstn=rec(1:9); 
	stn=strrep(rec(10:18),' ',''); 
	grid=str2num(rec(19:25)); 
	toss=rec(26:30); 
	sndg=str2num(rec(31:length(rec)));
%
% Read three header lines
%
%            DEPTHS     TEMP     SALT
%            ------  -------  -------
	rec = fgetl(fidd);
	rec = fgetl(fidd);
	rec = fgetl(fidd);

% load the data into D

	fspec = form(3);
	[D,C] = fscanf(fidd,fspec,[3,inf]);

	STP = [ sw_salt( D(3,:)./G0, D(2,:), D(1,:)); D(2,:); D(1,:); D(3,:)]';


% go back

	fclose(fidd);
	return;

