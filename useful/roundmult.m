function  X=roundmult(x,y,funct)	% {{{
%ROUNDMULT - 	round matrix to nearest multiple 
% 
%USAGE -	X=roundmult(x,y,funct)	
%
%EXPLANATION -	x - array to round
% 		y - to the nearest multiple
% 		funct - handle to the desired function method
% 			used for rounding (@round, @fix, @floor,
% 			@ceil), default @round
% 		X - result
%
%SEE ALSO -	
% 	ROUND, FIX, FLOOR, CEIL, ROUNDAXIS
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-04-20 
% 
%	$Revision: 1.4 $
%	$Date: 2013-04-09 06:28:32 $
%	$Id: roundmult.m,v 1.4 2013-04-09 06:28:32 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2013-04-09 
% 	Make general repairs, help text, remove returns, semis.
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

if ~exist('funct')==1, funct=[]; end
if isempty(funct), funct=@round; end
if isstr(funct), funct=str2func(funct); end

X=funct(x./y).*y;

