function [T,Sstats,nS]=enclosure(stp,resol,func)
%ENVELOPE -	returns the temperature envelope of data on a TS diagram
%
%USAGE -	[T,Sstats,nS]=enclosure(stp,resol,func)
%
%EXPLANATION -	
%		stp -	salinity temperature pressure matrix
%		resol -	resolution reqd in temperature [0.02]
% 		func - 'mean' or 'median'
%		T -	temperature vector used
% 		Sstats - for 'mean' [min -sd mean +sd max]
% 			 for 'median' [ min 25% median 75% max] 
%		nS -	number of points
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
% 	2009/01/08 
%	* other functions to describe the data
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

mm=minmax(stp(:,2));

if ~exist('resol'), resol=[]; end;
if isempty(resol), resol=1./50; end;
if ~exist('func'), func=[]; end;
if isempty(func),func='mean'; end;

% t=[[floor(min(mm)./resol):ceil(max(mm)./resol)].*resol].';
t=[[floor(min(mm)./resol-1):ceil(max(mm)./resol+1)].*resol].'-resol./2;

M=length(t)-1;
Sstats=nan(M,5);
nS=nan(M,1);
T=nan(M,1);

for i=1:M,
	I=find(stp(:,2)>=t(i) & stp(:,2)<=t(i+1));
	if ~isempty(I),
		if strcmp(func,'mean'),
		  [x1,x2,x3]=stats(stp(I,1));
		  SD=sqrt(x2);
		  Sstats(i,:)=[ min(stp(I,1)) x1-SD x1  x1+SD  max(stp(I,1))];
		  nS(i)=x3;
		elseif strcmp(func,'median'),
		  Sstats(i,:)=prctile(stp(I,1),[0,25,50,75,100]);
		  nS(i)-sum(~isnan(stp(I,1)));
		end;

		T(i)=(t(i)+t(i+1))./2;
	end;

end;


return
