function [varargout]=geoplot(X,str)
% GEOPLOT - 	plot [x y] matrix as points on a plane (instead of 
%		two separate lines)
%
% USAGE - 	h=geoplot(X)
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -   2004-10-21: return a handle
% 		2009/02/22: if there are no output args, return
% 		nothing 
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
% 
%

if size(X,2) < 2,
	error('geoplot: argument must have at least two columns');
end;
x = X(:,1); 
y = X(:,2);

if (nargin == 1),
	h=plot(x,y);
else,
	h=plot(x,y,str);
end;

if nargout>0, varargout={h}; end;

return;

