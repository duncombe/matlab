function man(topic);
% MAN -		Synonym of HELP
%		Do 'help help' or 'man help' for more help
%
%		See also LOOKFOR, WHAT, WHICH, DIR, MORE, MAN.

% PROGRAM -     MATLAB code by c.m.duncombe rae
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

if ~exist('topic')
	help
elseif strcmp(topic,'man')
	help help
else
	help(topic)
end
