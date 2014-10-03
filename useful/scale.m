function Y = scale(X,V,D)
% SCALE - 	scales a matrix to fit a window
%
% USAGE - 	Y=scale(X,V,D)
%
%		X - matrix to scale
%		V - range of scaled output data [0,1]
%		D - range of unscaled input data [minmax(X)]
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	2000-05-25
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

if ~exist('D'), D=minmax(X); end;
if ~exist('V'), V=[0,1]; end;

Y=(X-D(1))./diff(D).*diff(V)+V(1);

return;

