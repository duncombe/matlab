function  PD=kwikspec(X,T)	% {{{
%KWIKSPEC - 	
% 
%USAGE - PD=kwikspec(X,T)	
%
%EXPLANATION -	
% 	PD power spectral density
% 	X time series data
% 	T sampling period 
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-09-02 
%	$Revision: 1.2 $
%	$Date: 2011-09-08 21:54:00 $
%	$Id: kwikspec.m,v 1.2 2011-09-08 21:54:00 duncombe Exp $
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

h=spectrum.cov;
% h=spectrum.burg(16);
Hopts=psdopts(h);
Hopts.Fs=1./T;
PD=psd(h,X,Hopts);
return;



