function fX = nanfiltfilt(B, A, X, varargin)
%NANFILTFILT - 	filters the columns of X interpolating across NaN values
% 
%USAGE -	fX = nanfiltfilt(B, A, X, varargin)
% 
% 		B, A - filter coefficients as for filtfilt
% 		X - matrix to be filtered. 
% 		varargin - is passed `as is' as arguments to 
% 			interp1 for varying the interpolation
% 			method (see interp1)
%
%EXPLANATION -	filtfilt is highly intolerant of NaNs. This
%	function removes the nans and interpolates across them
%	before passing them to filtfilt.
%
%SEE ALSO -	
% 	interp1, filtfilt, filter, nanfilter
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: nanfiltfilt.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
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

if isempty(varargin),
	% default interpolation method
	varargin={'linear'};
end;

[m,n]=size(X);
fX=nan(m,n);

for i=1:n,
	z=X(:,i);
	I=find(isnan(z));
	z(I)=[];
	x=[1:m].';
	x(I)=[];
	
	j=size(z,1); 
	if j>1,
		% set up the axis
		XI=[1:m].';
		% trimmed so that there is no extrapolation to reintroduce NaNs
		XI(XI<min(x) | XI>max(x))=[];
		% interpolate across the NaNs
		ZI=interp1(x,z,XI,varargin{:}); 
		% filter the clean series
		fX(XI,i)=filtfilt(B,A,ZI);
	end;
end;

return;

