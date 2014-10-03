function [T,maxS,minS,aveS,varS,nS]=envelope(stp,resol)
%ENVELOPE -	returns the temperature envelope of data on a TS diagram
%
%USAGE -	[T,maxS,minS,aveS,varS,nS]=envelope(stp,resol)
%
%EXPLANATION -	
%		stp -	salinity temperature pressure matrix
%		resol -	resolution reqd in temperature [0.02]
%		T -	temperature vector used
%		maxS -	maximum values of S at each T
%		minS -	minimum values of S at each T
%		aveS -  mean of S at each T
%		varS -	variance
%		nS -	number of points
% 
% Note: there is nothing here which is specific to S, T and P. It looks
% 	like that for any NxM (M>=2) matrix, A, the values of A(:,1) will
% 	be binned along A(:,2) and the stats of the binning returned. 
%		
%
%SEE ALSO -	
%	anomaly.m
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2000-08-21
%
%PROG MODS -	
%  2012-07-18 
% 	Added to explanation text 
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

mm=minmax(stp(:,2));

if ~exist('resol'), resol=[]; end;
if isempty(resol), resol=1./50; end;

% t=[[floor(min(mm)./resol):ceil(max(mm)./resol)].*resol].';
t=[[floor(min(mm)./resol-1):ceil(max(mm)./resol+1)].*resol].'-resol./2;

M=length(t)-1;
maxS=[];
minS=[];
aveS=[];
varS=[];
nS=[];
T=[];

for i=1:M,
	I=find(stp(:,2)>=t(i) & stp(:,2)<t(i+1));
	if ~isempty(I),
		maxS=[maxS; max(stp(I,1))];
		minS=[minS; min(stp(I,1))];
		[x1,x2,x3]=stats(stp(I,1));
		aveS=[aveS; x1];
		varS=[varS; x2];
		nS=[nS; x3];
		T=[T;(t(i)+t(i+1))./2];
	end;

end;


return
