function [fpeak,peak,p,minoffset,weaktail]=spectralpeaks(Pad)
%SPECTRALPEAKS - 	
% 
%USAGE -	[fpeak,peak,p,minoffset,weaktail]=spectralpeaks(Pad)
%
%EXPLANATION -	
% 		fpeak = freq of the determined peaks
% 		peak = psd of the determined peaks
% 		p = coefficients of the robustfit line
% 		minoffset = offset of the minimum of the spectrum
% 		weaktail = background noise level
% 		
% 		Pad = dspdata object 
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	sometime prior to 2011-10-06 as psrt of
% 		ntasspectrum, on this date broekn out into
% 		its own file
%	$Revision: 1.2 $
%	$Date: 2011-10-26 13:07:08 $
%	$Id: spectralpeaks.m,v 1.2 2011-10-26 13:07:08 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 2011-10-26 
% 	changed criterion for weaktail: all segments with median <=
% 	median(end) are used to calculate median(weaktail). median(weaktail
% 	is then used in the ranksum test.
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



% determines the peaks in the spectrum, and returns them sorted 
% fpeak - peak frequency
% peak - peak intensity
% p - coefficients of spectrum baseline in loglog space
% minoffset - minimum of detrended spectrum
% weaktail - median of last 25% of the spectrum

% convert to log scale
x=log10(Pad.Frequencies);
y=log10(Pad.Data);

% avoid the singularities
I=find(isfinite(x) & isfinite(y));

% detrend the scaled data (cannot use detrend, must find the 
% line and subtract it)
% p=polyfit(x(I),y(I),1);
% Use least trimmed squares fitting from LIBRA
% rew=ltsregres(x(I),y(I),'plots',0);
% p=[rew.slope,rew.int];
% Use robustfit from matlab stats
b=robustfit(x(I),y(I)); p=[b(2), b(1)];
w=x(I);
z=y(I)-polyval(p,x(I));

K=localmaximum(z,6);
[garb,J]=sort(z(K),'descend');
minoffset=min(z); % this is always going to be negative
peak=10.^y(I(K(J))); 	% because we want the real PSD, not the
			% reduced by baseline one. leave it
			% sorted by baseline though.
fpeak=10.^w(K(J));

% now calculate the weaktail level (the background spectral E).
% Assume that the highest frequency has the closest to background.
% Test which frequency bands are the same or less than this last one and 
% take the median of those.

n=16; m=fix(length(y)./n); M=reshape(y(1:(m.*n)),m,n);
j=find(median(M)<=median(M(:,end)));
Mtail=reshape(M(:,j),[],1);

for i=1:size(M,2),
	% test for the medians the same or less at the 99% level
	% if different H==1, the same H==0
	% [P(i),H(i)]=ranksum(M(:,i),M(:,end),'alpha',0.01);
	[P(i),H(i)]=ranksum(M(:,i),Mtail,'alpha',0.01);
end;

weaktail=median(reshape(M(:,~H),[],1));

end 

