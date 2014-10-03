function O=oxysat(T,s)
% OXYSAT -	Oxygen saturation value (ml/l)
%
% USAGE -	O=oxysat(T,s)
%		T - temperature C
%		s - salinity psu
%
% REFERENCE -	Weiss, R.F., 1970: The solubility of nitrogen, oxygen and
%		argon in water and seawater. Deep-Sea Res., 17, 721-735.
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	Dec 1997
%
% PROG MODS -	
%		2007/12/23 - updated and corrected help text
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

A1 = -173.4292; A2 = 249.6339; A3 = 143.3483; A4 = -21.8492;
B1 = -0.033096; B2 = 0.014259; B3 = -0.00170;

T = T+273.15;
O = exp( A1 + A2.*(100./T) + A3.*log(T./100) + A4.*(T./100) + ...
	s.*( B1 + B2.*(T./100) + B3.*(T./100).*(T./100)));

return;

