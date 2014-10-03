function holdstn ( sw )
% HOLDSTN - 	sets hold on station data plots
%
% USAGE - 	holdstn('on') 
%		holdstn('off')
%		holdstn
% 
% EXPLANATION -	holdstn on sets hold on all three displaystn axes; 
%		holdstn off sets hold off; 
%		holdstn toggles the setting
%		See also DISPLAYSTN
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 94-12-23, sfri & ldeo
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

if ~exist('sw'), sw = []; end;
subplot(1,3,1);
eval(['hold ' sw ]); 
subplot(1,3,2);
eval(['hold ' sw ]); 
subplot(1,3,3);
eval(['hold ' sw ]); 
return;
