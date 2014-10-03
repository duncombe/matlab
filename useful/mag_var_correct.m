function  [East,North]=mag_var_correct(east,north,magvar)	% {{{
%MAG_VAR_CORRECT - Apply a magnetic variation correction to u,v data
% 
%USAGE -	[East,North]=mag_var_correct(east,north,magvar)	
%
%EXPLANATION -	For correcting magnetic variation an angle is required to be
%		added to the direction of the vector. When the vector is
%		given in (R,theta) coordinates this is trivial. For (u,v)
%		coordinates are given, the vector must be converted to
%		(R,theta) coordinates, the addition done and then converted
%		back to (u,v) coordinates. The steps can be reduced to a
%		simple formula using the relationships between the
%		coordinate systems and the addition rule for trig
%		functions. Geophysical context (u,v) coordinates use math
%		system, mag variations are given in oceanic coordinates
%		(\theta\prime = 90-\theta)
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-02-22
%	$Revision: 1.4 $
%	$Date: 2012-07-24 13:49:15 $
%	$Id: mag_var_correct.m,v 1.4 2012-07-24 13:49:15 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
% }}}

% License {{{
% -------
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
% }}}

if exist('magvar','var')~=1, error('Provide magnetic variation to apply'); end

% make conversion to other coordinate system
magvar=-magvar;

East=east.*cosd(magvar)-north.*sind(magvar);
North=north.*cosd(magvar)+east.*sind(magvar);


