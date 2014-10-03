function less(filename)
% LESS - 	fires up file lister (less)
%
% USAGE -	less(filename)
%


% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	
%
% PROG MODS -	1998-09-28 - OS independent
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

cname=computer;
if all(cname(1:2) == 'LN' ) || all(cname(1:3)=='GLN'),
	eval(['!xterm -T "Listing ' filename '" -e less ' filename ' &']);
elseif all(cname(1:2) == 'PC' ),
	eval(['!notepad ' filename ' &']);
else
	disp('LESS does not recognise your operating system. Make changes to less.m');
end;
return;

return;
