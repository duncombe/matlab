function [cl] = coslan(qu,we)
%  COSLAN -     returns the weights for a cosine-lanczos low-pass
%		filter
%
%  USAGE -	[cl] = coslan(qu,we)
%
%		we - 	weights for symmetrical filter, number of weights 
%			returned is odd, either the number requested or 
%			one more 
%
%		qu -	quarter power (half amplitude) period, in terms 
%			of the sampling frequency, eg. if data are sampled 
%			at 1 hertz then qu seconds is the period at which 
%			the power passed by the filter is 1/4 of the input 
%			power. If you use freqz (in the signal processing 
%			toolbox), -6.02 dB = 10*log10(1/4);
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -	
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

nweights=fix(we./2)+1;
quarter = qu;
sumv=1;
weights=1;
for i=1:nweights-1,
    t=(1+cos(pi*i/nweights))/2;
    freq=2*pi*i/quarter;
    weights(i+1)=t*(sin(freq)/freq);
    sumv=2*weights(i+1)+sumv;
end;

weights=weights'/sumv;

cl=[weights(length(weights):-1:2);weights];
clear weights;
return;


