function [STP,bvf]=pycnoc(stp,N,M)
% PYCNOC -	Determine pycnocline (maximum Brunt-Vaisala Freq) for CTD data
%		Extracts the data at the most stable part of water column
%
% USAGE -	[STP,bvf]=tc(stp,N)
%		stp
%		STP - data at bv max
%		bvf - BVF for data
%		N - size of triangular filter to apply (default 10)
%		M - range in wc to test for a cline [ min max ]
%


% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1999-04-16 
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


if ~exist('M'),
	M=[-10000 20000]; 
elseif max(size(M))<2,
	M=[M 20000]; 
end;
if M(1)>M(2), M(1:2)=[M(2),M(1)]; end;
if ~exist('N'), 
	N=[]; 
end;
if isempty('N'),
	N=10; 
end;

[m,n]=size(stp);

% filter data. only filter S and T

A=triang(N); B=sum(A);

fstp= [mfiltfil(A,B,stp(:,1:2)) stp(:,3:n)];
bvf=sw_bfrq(fstp(:,1),fstp(:,2),fstp(:,3));
astp=ave(fstp);

J=find(astp(:,3)>M(1)&astp(:,3)<M(2));
[y,I]=max(bvf(J));
STP=astp(J(I),:);
return;

