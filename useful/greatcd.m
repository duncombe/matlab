function [GCD] = greatc_d( x1, x2 )
%  GCD = gcd( x1, x2 )
%      		Great Circle Distance between points
%		x1, x2 : complex = long + i*lat;
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

radius = 6371.0;
angle  = cos(imag(x1).*pi./180.0).*cos(imag(x2).*pi./180.0).*  ...
         cos((real(x1)-real(x2)).*pi./180.0)+ ...
         sin(imag(x1).*pi/180.0).*sin(imag(x2).*pi/180.0);

if abs(angle) > 1.0, angle =1.0; end;
GCD = radius.*atan(sqrt(1.0./(angle.*angle)-1.0));

return;
