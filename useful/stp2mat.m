function [varargout]=stp2mat(stp)
% function [SM,TM,PM]=stp2mat(stp)
%STP2MAT - 	Converts STP matrix to [mxn] matrixes of S, T and P
% 
%USAGE -	[SM,TM,PM]=stp2mat(stp)
%
%EXPLANATION -	Convenient for some purposes to have STP a matrix of
%		nx3 with salinity in STP(:,1), etc. and stations separated
%		by row of NaNs. However, sometimes 
% 		need seperate matrices with stations in columns.
%		stp - STP matrix, nx3
%		SM - Salinity matrix
%		TM - Temperature
% 		PM - pressure
%
%SEE ALSO -	SAMEROWS
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-12-10
%
%PROG MODS -	2004-03-19: deal with stp having NaN values which are
%			not station markers
%		2005-10-18: deal with stp of only one station (no NaN markers)
% 		2009/01/12: break up any size matrix 

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

[m,n]=size(stp);

% the next line finds all rows with all NaN values (station markers)
if n==1,
	I=find(isnan(stp)).';
else
	I=find(~any(~isnan(stp.')));
end;

%
if isempty(I), I=m+1; end;
I=[0;I.'];
dI=diff(I);
% TM=SM; PM=SM;
% size(SM)
varargout=cell(1,nargout);
N=max(n,nargout);
for j=1:N,
   SM=NaN.*ones(max(dI)-1,size(I,1)-1);
   for i=2:size(I,1),
	SM(1:dI(i-1)-1,i-1)=stp(I(i-1)+1:I(i)-1,j);
	% TM(1:dI(i-1)-1,i-1)=stp(I(i-1)+1:I(i)-1,2);
	% PM(1:dI(i-1)-1,i-1)=stp(I(i-1)+1:I(i)-1,3);
   end;
   varargout(j)={SM};
end;
% size(SM)
return;

