function X=diffn(x,n)	% {{{
%DIFFN - returns the differences at n-point spacing
% 
%USAGE -	X=diffn(x,n)
%
%EXPLANATION -	returns the n-point difference
% 		i.e., X(1:n:end)=diff(x(1:n:end))
% 		      X(2:n:end)=diff(x(2:n:end))
% 		      X(3:n:end)=diff(x(3:n:end)), etc
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-04-20 
% 
%	$Revision: 1.1 $
%	$Date: 2011-04-20 12:47:31 $
%	$Id: diffn.m,v 1.1 2011-04-20 12:47:31 duncombe Exp $
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



[l,k]=size(x);
if l==1,
	X=nan(l,k-n);
else
	X=nan(l-n,k);
end;

for i=1:n,
	X(i:n:end)=diff(x(i:n:end));
end;

return;
