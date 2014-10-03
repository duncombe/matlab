function [x,p1]=loadies(snno1)
% LOADIES -	loads ies data from file, getting position and 
%		correcting the timebase
%
% USAGE -	[x,p1]=loadies(snno1)
%
%		x is [timebase,trvltime], timebase hours from jan 1 92,
%			trvltime in seconds
%		p1 is complex position longitude+sqrt(-1)*latitude
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
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

eval(['global ' snno1 ';']);
if ~exist(snno1),
	disp(['Loading ' snno1 ]);
	eval(['load \data\ies\' snno1 '.fix ;']); 
end;

eval(['x=' snno1 ';']);
h=x(1,:); 
x=x(2:length(x),1:2);
x(:,1)=round(x(:,1)+h(1)+170*24); 
p1=h(4)+h(5)/60 - (h(2)+h(3)/60)*sqrt(-1); 

clear h
return;
