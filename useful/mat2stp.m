function [varargout]=mat2stp(varargin)
%STP2MAT - 	Converts [mxn] matrixes of S, T and P to STP matrix
% 
%USAGE -	stp=mat2stp(SM,TM,PM)
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
%SEE ALSO -	SAMEROWS, stp2mat
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-12-10
%
%PROG MODS -	2004-03-19: deal with stp having NaN values which are
%			not station markers
%		2005-10-18: deal with stp of only one station (no NaN markers)
% 		2009/01/12: break up any size matrix 
%		2009/02/08 modify to reverse the process
% 		2009/03/17 fix the (euphemism-mistake). tried to test the
% 		station marker against the number of stations. Of
% 		course this is wrong. Fixt.


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

% should check sizes are all the same

[m,n]=size(varargin{1});
k=nargin;

STP=nan((m+1).*n,k);

for j=1:k,
	V=[varargin{j};nan(1,n)];
	STP(:,j)=V(:);
end;

mkr=find(sum(isnan(STP).')==k).';
STP(mkr(find(diff(mkr)==1)),:)=[];
varargout={STP};

return;

