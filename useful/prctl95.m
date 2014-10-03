function Y=prctl95(X)
% - 	
% 
%USAGE -	
%
%EXPLANATION -	to use grpstats, function needs to accept one
%		parameter. This allows us to get 25 and 75
%		percentile stats with grpstats.
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.4 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: prctl95.m,v 1.4 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2010/10/09
% 	What were you thinking? There MUST have been a more
% 	coherent way of doing this than building separate
% 	functions for each percentile.
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

Y=prctile(X,95);
return;

