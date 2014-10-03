function [BI,AI,DB,DA]=closest(A,B,units)
%CLOSEST - 	finds closest station pairs in two station lists
% 
%USAGE -	[BI,AI,DB,DA]=closest(A,B)
%
%EXPLANATION -	A,B position vectors; can be [lon, lat] or lon + lat.*sqrt(-1)
%		BI  index of pos in B which is closest to pos in A
%		AI  index of pos in A which is closest to pos in B
% 		DA, DB distance of closest point
% 		units - nm or km
% 
% 		if B is created by "B=A(randperm(length(A)));"
% 		and [BI,AI]=closest(A,B); then
%		[B,A(AI,:)] are the same stations in each row; and
% 		[A,B(BI,:)] are the same stations in each row
%
% 		Example: Nominal station positions for a line are
% 		in S; actual stations occupied are in P. To find
% 		the station numbering of the stations occupied,
% 		IS=closest(P,S);
%
%SEE ALSO -	sw_dist, kmeans
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2008/09/08 
% 
%	$Revision: 1.9 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: closest.m,v 1.9 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 	2008/09/25 
% 		* for NaNs in input return NaNs in output
%	2008/10/06 
% 		* for scalar A or B, set BI or AI to 1
% 		* for real A or B, trying to transpose from row
% 		to column is wrong
% 	2009/01/26 
% 		* sw_dist expects units; provide these if nec.
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

if exist('units')~=1, units='nm'; end;

ta=0;
tb=0;

if isreal(A),
	Ala=A(:,2);
	Alo=A(:,1);
else
	[ma,na]=size(A); if ma<na, ta=1; A=A.'; end;
	Ala=imag(A);
	Alo=real(A);
end;

if isreal(B),
	Bla=B(:,2);
	Blo=B(:,1);
else
	[mb,nb]=size(B); if mb<nb, tb=1; B=B.';  end;
	Bla=imag(B);
	Blo=real(B);
end;

ANaN=find(isnan(Ala)|isnan(Alo));
BNaN=find(isnan(Bla)|isnan(Blo));

ALA=repmat(Ala,1,length(Bla));
BLA=repmat(Bla.',length(Ala),1);

ALO=repmat(Alo,1,length(Blo));
BLO=repmat(Blo.',length(Alo),1);

y=reshape([ALA(:),BLA(:)].',[],1) ;
x=reshape([ALO(:),BLO(:)].',[],1) ;

d=sw_dist(y,x,units);

D=reshape(d(1:2:length(d)),size(BLO));

[DA,AI]=min(D);
[DB,BI]=min(D.');

if ~ta, AI=AI.'; end;
if ~tb, BI=BI.'; end;

if length(Ala)==1, AI=1; end;
if length(Bla)==1, BI=1; end;

BI(ANaN)=NaN;
AI(BNaN)=NaN;

return;

