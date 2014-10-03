function A=unwrapd(varargin)
%UNWRAPD - unwrap vectors in degrees
% 
%USAGE -	A=unwrapd(a)
%
%EXPLANATION -	unwrap (provided in elfun toolbox) works in
%		radians. unwrapd converts, calls unwrap and
%		converts back.
%
%SEE ALSO -	unwrap, rad2deg, deg2rad
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2010/10/21 
% 
%	$Revision: 1.4 $
%	$Date: 2011-06-17 12:08:32 $
%	$Id: unwrapd.m,v 1.4 2011-06-17 12:08:32 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2011-06-17 
% 	Minor typo corrections in header.
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
if nargin==1,
	a=deg2rad(varargin{1});
	A=rad2deg(unwrap(a));
end;
if nargin==2,
	a=deg2rad(varargin{1});
	TOL=deg2rad(varargin{2});
	A=rad2deg(unwrap(a,TOL));
end;
if nargin==3,
	a=deg2rad(varargin{1});
	TOL=deg2rad(varargin{2});
	DIM=varargin{3};
	A=rad2deg(unwrap(a,TOL,DIM));
end; 

return;


