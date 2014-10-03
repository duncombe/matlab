function [ML,PRtop,PRbottom,Ave,Var]=mld(DAT,PR,limit)
%MLD -		Mixed Layer Detection. The range of values within the 
%		stad are within 2*limit.
% 
%USAGE -	[ML,PRtop,PRbottom,Ave,Var]=mld(DAT,PR,limit)
%
%EXPLANATION -	ML - height of the stad (PRtop-PRbottom)
%		PRTop - reference at the top of the stad
%		PRbottom - reference at the bottom of the stad
%		DAT - vector of data to scan (eg. temperature)
%		PR - reference vector (eg. pressure)
%		limit - detection variability
%		Ave, Var - statistics of the stad values
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2001-10-16
%
%PROG MODS -	2004-06-08: documentation corrections
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

% check the input
% find the value greater than the limit
% find the value less than the limit

l=length(DAT);
ML=zeros(size(DAT,1),1);
PRtop=ML; PRbottom=ML; Ave=ML; Var=ML;

for i=1:l,
	I=flipud(find(abs(DAT(1:i)-DAT(i))>=limit));
	J=find(abs(DAT(i:l)-DAT(i))>=limit)+i-1;
	if isempty(I), I=1; end;
	if isempty(J), J=i; end;

	pr1=PR(I(1));
	pr2=PR(J(1));

	ML(i)=pr2 - pr1;

	PRtop(i)=pr1;
	PRbottom(i)=pr2;
	[Ave(i),Var(i)]=stats(DAT(I(1):J(1)));
end;
return;

