function [var]=varname(pathname)
%VARNAME -	returns variable name from a path/filename string
%
%USAGE -	[var]=varname(pathname)
%
%EXPLANATION -	pathname - pathname to parse
%		var - string derived from file name in pathname
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	According to the datestamp, May 22, 2001, but I'm sure it's
%		more ancient than that! 
%PROG MODS -	2001-10-08: tidy up some loose ends
%		2001-10-17: Seems this was actually a bit broken. Fix!
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

tstr=pathname;
s=findstr(tstr,'/');
b=findstr(tstr,'\');
p=findstr(tstr,'.');

d=max([max(s),max(b)]);
if isempty(d), d=0; end;
e=max(p);
if isempty(e), e=length(tstr)+1; end;

var=tstr([d+1]:[e-1]);
return;

