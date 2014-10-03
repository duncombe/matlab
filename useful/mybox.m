function H=mybox(x,y,pen)
%BOX - 		Plots a box enclosing the given limits on the current plot
% 
%USAGE -	H=mybox(x,y,pen)
%
%EXPLANATION -	H - handle to the oblect
%		x - x limits
%		y - y limits
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2004-06-02
%
%PROG MODS -	
%  2009/11/07 	A matlab builtin is called ``box''. Moved this
%  		function to mybox.m
%  
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

if ~exist('pen'), pen='r'; end;

X=[min(x); max(x)];
Y=[min(y); max(y)];
H=plot( X([1 2 2 1 1]), Y([1 1 2 2 1]), pen );
return;
