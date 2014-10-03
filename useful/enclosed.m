function [D,Sstats,Tstats,N]=enclosed(stp,pos,resol,func)
%ENVELOPE -	returns the envelope of TS data along isopycnals
%
%USAGE -	[D,Sstats,Tstats,N]=enclosed(stp,pos,resol,func)
%
%EXPLANATION -	
%		stp -	salinity temperature pressure matrix
% 		pos - 	position (long+i*lat)
%		resol -	resolution reqd in temperature [0.02]
% 		func - 'mean' or 'median'
%		D -	density vector used
% 		Sstats - for 'mean' [min -sd mean +sd max]
% 			 for 'median' [ min 25% median 75% max] 
% 			 for 'hist' return histograms
%			 variances may be obtained from the 'mean':
% 			 stddev=(Sstats(:,4)-Sstats(:,2))/2
% 		Tstats - as for Sstats
%		N -	number of points
%		
%
%SEE ALSO -	
%	anomaly.m, enclosure.m
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	original concept, 2000-08-21
% 		modified enclosure 2009/03/17 
%
%PROG MODS -	
% 	2009/01/08 
%	* other functions to describe the data
% 	2009/03/17 
% 	* make it do along isopycnals 
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

% work on density surfaces
[S,T,P]=stp2mat(stp);
d=gamma_n(S,T,P,real(pos),imag(pos));
disp('done gamma lookup');

mm=minmax(d);

% set up for mean (the default)
if ~exist('resol'), resol=[]; end;
if isempty(resol), resol=1./50; end;
if ~exist('func'), func=[]; end;
if isempty(func), func='mean'; end;

% r is the density vector
if max(size(resol))==1,
r=[[floor(min(mm)./resol(1)-1):ceil(max(mm)./resol(1)+1)].*resol(1)].'- ...
	resol(1)./2;
else
	r=resol;
end;

M=length(r)-1;

if regexp(func,'mean|median'),
	Tstats=nan(M,5);
	Sstats=nan(M,5);
elseif regexp(func,'hist'),
	nt=minmax(T);
	ns=minmax(S);
	if max(size(resol))<2, 
		resol(2)=1./50;
	end;
	HS=[[floor(min(ns)./resol(2)-1):ceil(max(ns)./resol(2)+1)].* ...
		 resol(2)].'-resol(2)./2;
	Sstats=nan(M,length(HS));
end;

nS=nan(M,1);
nT=nan(M,1);

for i=1:M,
	I=find(d>=r(i) & d<=r(i+1));
	if ~isempty(I),
		if strcmp(func,'mean'),
		  % stats returns [mean variance count]
		  [x1,x2,x3]=stats(S(I));
		  SDS=sqrt(x2);
		  Sstats(i,:)=[ min(S(I)) x1-SDS x1  x1+SDS  max(S(I))];
		  nS(i)=x3;
		  [x1,x2,x3]=stats(T(I));
		  SDT=sqrt(x2);
		  Tstats(i,:)=[ min(T(I)) x1-SDT x1  x1+SDT  max(T(I))];
		  nT(i)=x3;

		elseif strcmp(func,'median'),
		  Sstats(i,:)=prctile(S(I),[0,25,50,75,100]);
		  nS(i)=sum(~isnan(S(I)));
		  Tstats(i,:)=prctile(T(I),[0,25,50,75,100]);
		  nT(i)=sum(~isnan(T(I)));
		elseif strcmp(func,'hist'),
		  Sstats(i,:)=histc(S(I),HX);
		  nS(i)=sum(~isnan(S(I))); 
		  Tstats(i,:)=histc(T(I),HX);
		  nT(i)=sum(~isnan(T(I))); 
		end;

	end;
	D(i)=(r(i)+r(i+1))./2;

end;
D=D(:);
N=[nS,nT];

return;

