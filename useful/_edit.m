function edit(filename)
% EDIT - 	fires up an editor (vi/notepad)
%
% USAGE -	edit(filename)
%



% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	
%
% PROG MODS -	1998-09-28:  OS independent
%		2002-10-14:  edit with rxvt if it exists else use xterm
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
if all(cname(1:2) == 'LN') || all(cname(1:4) == 'GLNX'),
	options=[' -fg white -bg black -T "Editing ' filename '" -e vim ' filename ];
	eval(['!(rxvt ' options ' 2> /dev/null || xterm ' options ' )&']);
elseif all(cname(1:2) == 'PC' ),
	eval(['!notepad ' filename ' &']);
else
	disp('EDIT does not recognise your operating system. Make changes to edit.m');
end;
return;

