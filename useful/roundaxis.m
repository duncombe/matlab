function  A=roundaxis(B,m)	% {{{
%ROUNDAXIS - rounds axis limits to integral values of multiplier
% 
%USAGE -	A=roundaxis(B,m)
%
%EXPLANATION -	B - [x1 x2 y1 y2] 
% 		A - [floor(x1) ceil(x2) floor(y1) ceil(y2)]
% 		m - multiplier scalar, applied to x and y
% 		    1x2 vector applies m(1) to x and m2 to y
%
%SEE ALSO -	ROUNDMULT
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2013-03-27  EN-255
%	$Revision: 1.2 $
%	$Date: 2013-04-09 06:28:32 $
%	$Id: roundaxis.m,v 1.2 2013-04-09 06:28:32 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
% }}}

% License {{{
% -------
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
% }}}

if exist('m','var')~=1, m=[]; end
if isempty(m), m=1; end
if length(m)==1, m(2)=m(1); end

A=[	roundmult(B(1),m(1),@floor), ...
	roundmult(B(2),m(1),@ceil), ...
	roundmult(B(3),m(2),@floor), ...
	roundmult(B(4),m(2),@ceil)];

