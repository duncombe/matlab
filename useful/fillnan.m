function Y=fillnan(x,y)
%FILLNAN - 	interpolates to fill in missing values in a series
% 
%USAGE -	Y=fillnan(x,y)
%
%EXPLANATION -	
%
%SEE ALSO -	interp1
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2008/04/14
%	$Revision: 1.5 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: fillnan.m,v 1.5 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
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

if ~exist('y'), y=x; x=1:length(y);  end;

I=find(isnan(y));

x0=x; x0(I)=[]; Y=y; y(I)=[]; 

Y(I)=interp1(x0,y,x(I));

return;

