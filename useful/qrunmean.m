function Y=qrunmean(y,n) % {{{
%QRUNMEAN -	quick running mean filter
% 
%USAGE -	Y=qrunmean(y,n)
%
%EXPLANATION -	uses filter . n must be odd. If n is even, we do n=n+1.
%
%SEE ALSO -	runmean, runstats
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	
%	$Revision: 1.3 $
%	$Date: 2012-11-04 14:34:20 $
%	$Id: qrunmean.m,v 1.3 2012-11-04 14:34:20 duncombe Exp $
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

% filter size must be odd
% if mod(n,2)==0, n=n+1; end

% keyboard

K=1:length(y);
J=find(~isnan(y));
M=find(isnan(y));

y=interp1(J,y(J),K,'nearest','extrap').';

% any(isnan(y))


I=fliplr(2:n);

% try
x=[y(I); y; y(end-(I-1))]; 
% catch
% keyboard
% end


X=filter(boxcar(n),sum(boxcar(n)),x);
Y=X([n+fix(n/2)]:[end-fix(n/2)]); 

Y(M)=NaN;

% [size(y,1) size(Y,1)]



