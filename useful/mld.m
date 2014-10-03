function [ML,PRtop,PRbottom,Ave,Var,Del]=mld(DAT,PR,limit,range)
%MLD -		Mixed layer detection. The range of values within the 
%		stad are within 2*limit. If range is negative
% 		it is the distance from the bottom.
% 
%USAGE -	[ML,PRtop,PRbottom,Ave,Var,Del]=mld(DAT,PR,limit,range)
%
%EXPLANATION -	ML - height of the stad (PRtop-PRbottom)
%		PRtop - reference at the top of the stad
%		PRbottom - reference at the bottom of the stad
%		DAT - vector of data to scan (eg. temperature)
%		PR - reference vector (eg. pressure)
%		limit - detection variability
% 		range - check only a range of depths
%		Ave, Var - statistics of the stad values
%		Del - max(stad)-min(stad)
%
%SEE ALSO -	mixlayer
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2001-10-16
%
%PROG MODS -	2004-06-08: Made to work on matrices. Adjust stats O/P
%		2005-02-18: Bugfix in PR references
% 		2008/09/08: generalize, make range to be a range
% 		2009/01/25
% 		* set the more state to off for duration
% 		* include possibility of negative range (distance
% 		from the bottom)
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

morestate=get(0,'more');
more off;

% check the input
% find the value greater than the limit
% find the value less than the limit

% l=length(DAT);

if exist('range')~=1, range=[]; end;
if isempty(range), range=maxi(maxi(PR)); end;
if length(range)==1,
	if range<0,
		range=[ [maxi(PR)+range].', [maxi(PR)+1].' ];
	else
		range=[ 0, range];
	end;
end;

[l,M]=size(DAT);

if size(range,1)~=M, 
	range=repmat(range,M,1);
end;

if any(any(size(DAT)-size(PR))),
	error([	'Input matrices are not the same shape' 10 ...
		'Unless you REALLY know what you are doing,' 10 ... 
	 	'this is not what you want!']); end;

% ML=zeros(l,M);
ML=nan(l,M);
PRtop=ML; PRbottom=ML; Ave=ML; Var=ML; Del=ML;

for m=1:M,
    scandep=range(m,:);
    % disp( ['Processing ' num2str(m) ' of ' num2str(M) ]);

    dat=DAT(:,m);
    pr=sort(PR(:,m));

    D=max(find(pr<=scandep(2)));
    D0=min(find(pr>=scandep(1)));
    for i=D0:D,
    	I=flipud(find(abs(dat(1:i)-dat(i))>=limit));
    	J=find(abs(dat(i:l)-dat(i))>=limit)+i-1;
    	if isempty(I), I=1; end;
    	if isempty(J), J=i; end;

    	pr1=pr(I(1));
    	pr2=pr(J(1));
    
    	ML(i,m)=pr2 - pr1;
    
    	PRtop(i,m)=pr1;
    	PRbottom(i,m)=pr2;
    	[Ave(i,m),Var(i,m)]=stats(DAT(I(1):J(1),m));
    	Del(i,m)=max(dat(I(1):J(1)))-min(dat(I(1):J(1)));
    end;
end;

more(morestate);

return;

