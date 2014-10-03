function [dY,dD,mY,vY,N]=anomaly(Y,D,res,stat)
%ANOMALY - calculates parameter average through a water column
% 
%USAGE -	[dY,dD,mY,vY,N]=anomaly(Y,D,res,stat)
%
%EXPLANATION -	Y -  parameter that varies along an ordinate (eg. T or S)
%		D -  ordinate (eg. density or pressure)
%		res -  resolution 
%		dY -  anomaly: Y-mean(Y)
%		dD -  monotonically increasing vector: [min(D):res:max(D)]
%			M=length(dD)
%	stat=='mean'
%		mY -  mean of Y at res intervals (Mx1 vector)
%		vY -  variance of Y at res intervals (Mx1 vector)
%	stat=='median'
%		mY -  median of Y at res intervals (Mx1 vector)
%		vY -  quartiles of Y at res intervals (Mx2 vector)
%	stat=='extreme'
%		mY -  maximum of Y at res intervals (Mx1)
%		vY -  minimum of Y at res intervals (Mx1)
%
%		N -  number of Y values at res intervals
%
%SEE ALSO -	
%	envelope.m
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2008/02/03
%
%PROG MODS -	
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
%

if exist('res')~=1, res=[]; end;
if isempty(res),
	res=(max(D)-min(D))./20;
	delta=(max(D)-min(D)).*res;
else
	delta=res;
end;
dD=min(D):delta:max(D);

if exist('stat')~=1, stat=[]; end;
if isempty(stat), stat='mean'; end;

mY=ones(length(dD)-1,1).*NaN;
vY=ones(length(dD)-1,1).*NaN;
dY=Y.*0;
N=1;
for i=1:length(dD)-1,
	I=find(D<dD(i+1) & D>=dD(i) );

if strcmpi('mean',stat),
	mY(i)=nanmean(Y(I));
	vY(i)=nanvar(Y(I));
elseif strcmpi('median',stat),
	mY(i)=nanmedian(Y(I));
	wi=isnan(Y(I)); w=Y(I); w(wi)=[]; wn=length(w); 
	if wn>=1, 
		W=sort(w);
		vY(i,1:2)=[W(ceil(0.25.*wn)),W(ceil(0.75.*wn))];
	else
		vY(i,1:2)=[NaN NaN];
	end;
elseif strcmpi('extreme',stat),
	if ~isempty(I),
		mY(i)=nanmax(Y(I));
		vY(i)=nanmin(Y(I));
	end;
end;

	N(i)=sum(~isnan(Y(I)));
	dY(I)=Y(I)-mY(i);
end;

dD=[(min(D)+delta./2):delta:(max(D)-delta./2)].';

% figure; plot(Y,D,'.');
% figure; plot(dY,D,'.');
% figure; plot(mY,dD,mY+sqrt(vY),dD,mY-sqrt(vY),dD);

return;

