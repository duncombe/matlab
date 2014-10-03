function [M,V,N]=stats(X)
% STATS - 	calculates the mean and variance of a (matrix) sample
%
% USAGE - 	[M,V,N]=stats(X)
%
% EXPLANATION -	M columnwise mean of X
%		V columnwise variance of X
%		N number of samples (=size(X,1) less number of NaNs)
%


% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	?1995 original useful suite?
%
% PROG MODS -	2004-08-30: tidying up redundant code
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
x=X;
D=isnan(X);
I=find(D);
N=sum(~D); 
%if ~isempty(I),
	x(I)=zeros(size(I));
	sumx=sum(x); 
	M=sumx./N; 
	V=sum( (x - (~D).*(ones(size(x,1),1)*M) ).^ 2 ) ./ (N-1);
%else
%	M=nan;
%	V=nan;
%end;
clear x D I sumx 
return;

%
%for i=1:size(X,2),
%	I=find(~isnan(X(:,i)));
%	N(i)=length(I);
%	if N(i) > 0, 
%		M(i)=sum(X(I,i))./N(i); 
%	else 
%		M(i)=nan; 
%	end;
%	if N(i) > 1,
%		V(i)= sum ( ( X(I,i)-M(i) ).^2)./(N(i)-1); 
%	else 
%		V(i)=nan; 
%	end;
%end;
%return;
%
