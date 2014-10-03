function [c,h]=bathym(range,cnts)
%BATHYM - 	draws contours of bathymetry on the current plot
% 
%USAGE -	bathym(range,cnts)
%
%EXPLANATION -	Looks at the environment variable TOPO to get the
%		topography data. Uses netcdf (mexnc) to read
%		data, plots with contour.
%		
% 		Input:
%		range is a 4-vector (like output of axis)
%		cnts is a vector of contour levels (see contour)
%
%		Output: as from contour
%		c is a contour matrix as described in contourc
% 		h is a handle to a contour group object for
% 			input to clabel
% 		
%
%SEE ALSO -	mexnc, contour
%
%REQUIRES - 	mexnc, TOPO environment variable with bathy data
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2008/09/16 
% 
%	$Revision: 1.6 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: bathym.m,v 1.6 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 	2009/01/13 
%	* Seems to be a typo where the range was hard-coded in
%	despite appearing in the argument list. Fixt.
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

emptycnts=0;

if ~exist('range'), range=[]; end;
if isempty(range), range=axis; end;
if ~exist('cnts'), emptycnts=1; end;

fname=getenv('TOPO');
[fid]= mexnc('open',fname);
[ndims, nvars, ngatts, unlimdim, status] = mexnc ( 'inq', fid );
lon=mexnc('get_var_double',fid,0);
lat=mexnc('get_var_double',fid,1);

% I=find(lon>0 & lon<30);
% J=find(lat<0 & lat>-45);
I=find(lon>=range(1) & lon<=range(2));
J=find(lat>=range(3) & lat<=range(4));

% get_vara_double gets a slab of var2 from fid, starting at
% lon(I(1)), lat(J(1)) and counting [length(I),length(J)]. But.
% netcdf counts from 0, so we must subtract one from the indices
% when calling mexnc.
bathy=mexnc('get_vara_double',fid,2,[J(1),I(1)]-1,[length(J),length(I)]).';

if emptycnts,
	[c,h]=contour(lon(I),lat(J),bathy);
else
	[c,h]=contour(lon(I),lat(J),bathy,cnts);
end;

return;

