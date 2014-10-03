function [X]=ave(x)
%AVE - 	returns the two-point running mean of a vector (matrix) 
%
%USAGE - 	[X]=ave(x)
% 
%EXPLANATION -	x matrix of size(N,M)
%		X matrix of size(N-1,M) where the elements are 
%			X(i,:)=(x(i,:)+x(i+1,:))./2
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 95-01-05, sfri & ldeo
%
% PROG MODS -	
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
% 

[m,n]=size(x); 
if (m==1) | (n==1), 
	s=max([m,n]); 
	X=diff(x)./2+x(1:s-1);
else,
	X=diff(x)./2+x(1:m-1,:);
end;
return;

