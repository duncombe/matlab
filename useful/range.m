function [r]=range(x)
% RANGE =	finds the range of a set of data (max(x)-min(x))
%
% USAGE -	[r]=range(x)

%
%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	When?? Date on initial revision was 2000/05/05
%	$Revision: 1.5 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: range.m,v 1.5 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2010/12/22 
% 	Matlab now has NaN stable max and min functions, maxi and
% 	mini no longer required.
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

r=max(x)-min(x);

return;

