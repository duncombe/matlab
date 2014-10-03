function [ASTTEX]=asttex(draw)
%ASTTEX - 	draws the asttex mooring positions on the current axes
% 
%USAGE -	[ASTTEX]=asttex(draw)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-12-04
%
%PROG MODS -	
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

ASTTEX=[ 
	15.8126720 -31.9567440;
	15.1350400 -33.1682360;
	14.583056 -34.123800;
	14.167040 -34.825792;
	13.803912 -35.426008;
	13.465536 -35.974936;
	13.090208 -36.572344;
	12.740264 -37.118616;
	12.384512 -37.663540;
	12.055912 -38.157720;
	11.688544 -38.699952;
	11.314808 -39.240688;
	];

if exist('draw'),
	hold on; 
	geoplot(ASTTEX,'*');
	% text(LP(:,1),LP(:,2),LS);
	end;
return;

