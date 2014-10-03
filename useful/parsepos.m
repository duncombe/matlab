function [POS]=parsepos(posstr)
%PARSEPOS -	parse a generic position string
%
%USAGE - 	[POS]= parsepos(posstr)
% 
%EXPLANATION - Parses the latitude or longitude string in posstr
%  		and recognizes any of the forms dd:mm:ss H, dd.dddd H,
%  		dd:mm.mmm H, dd:mm.mmmH, ddHmm.mmmm, etc. Returns the
%  		position in the form [-]dd.dddd
% 
%SEE ALSO - 	STRINGPOS

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	1999-07-13 Africana V155 Benefit Training
%		modified from a gawk script
%
%PROG MODS -	2004-09-29: attempting to operate on a matrix (Alg131)
% 2013-03-22 
% 	Edits to help text
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
d=1;
sign=1;
angle=0;

% Determine the hemisphere if possible

if ~isempty( findstr('E',upper(posstr)) ),
	hemisphere='E';
elseif ~isempty( findstr('W',upper(posstr)) ),
	hemisphere='W'; 
	sign=-1;
elseif ~isempty( findstr('S',upper(posstr)) ),
	hemisphere='S'; 
	sign=-1;
elseif ~isempty( findstr('N',upper(posstr)) ),
	hemisphere='N';
elseif ~isempty(findstr('-',posstr)), 
	sign=-1;
end;

L=posstr;
delim=' :''"eEsSwWnN-';
[l,L]=strtok(L,delim);
while ~isempty(l),
	angle=angle+str2num(l)./d;
	d=d.*60;	  
	[l,L]=strtok(L,delim);
end;
% Add up the digits in the string. Make the assumption that each element
% degrees minutes seconds appears if a subordinate element is present, ie
% if degrees or minutes are zero and seconds are not, that is explicitly 
% stated rather than seconds being indicated by a quote or a blank in the 
% string
	POS= sign.*angle ;
return;

