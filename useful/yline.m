function h=yline(x,varargin)
%YLINE - plot lines on the current axes parallel to the ordinate
%		at levels defined in x	
% 
%USAGE -	h=yline(x,varargin)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2011-11-17, yline created 2011/01/14 
% 
%	$Revision: 1.4 $
%	$Date: 2012-08-15 18:11:30 $
%	$Id: yline.m,v 1.4 2012-08-15 18:11:30 duncombe Exp $
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
%

ax=axis;

%
[m,n]=size(x);


y=[ones(m,n)*ax(3:4)].';

hold on;
h=plot([x,x].',y,varargin{:});

return;

