function [map] = shfcolor(inc,shft)
% SHFCOLOR -	rotates the current colourmap by inc steps
%		(I can't find a function that does this: spinmap is hell)
%
% USAGE -	newmap = shfcolor(map,inc)
%
%		shifts the current colormapping (ie. figure(gcf)) by inc steps
%		and returns the new mapping in newmap if it is required.
%		inc can be negative
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

map=colormap;
n=size(map,1);
if ~exist('shft'), shft=1; end;

for ii=1:abs(inc),
	if inc<0, 
		map=[ map(2:n,:); map(1,:) ] ;  
	else, 
		map=[ map(n,:); map(1:n-1,:) ] ;  
	end;
	if shft, colormap(map); end;
end;
if ~shft, colormap(map); end;
return;
