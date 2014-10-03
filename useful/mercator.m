function [X,Y]=mercator(x,y)
% MERCATOR -	returns the proportion to multiply the 
%		longitude given the latitude
%
% USAGE -	[X,Y]=mercator(x,y)
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	
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

% Y=6367./111.12.*log(tan((45+X./2).*pi./180));
% Y=log(tan((45+X./2).*pi./180));
X=x./cos(x.*pi./180);
Y=y;
return;

