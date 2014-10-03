function Y=extract(X,x)
%EXTRACT - 	extract the indexes from an array
% 
%USAGE -	Y=extract(X,x)
%
%EXPLANATION -	X: matrix(mxn)
%		x: vector (1xn)
%		Y: vector (1xn) 
%		Y is the elts in the cols of X pointed to by the elts in x
% 
%Matlab function permute rearranges the dimensions of a multidimensionall
%matrix. EXTRACT retrieves particular elements from the columns of X.
% 
%SEE ALSO -	permute, sub2ind, ind2sub
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2004-06-09 (using hints given by d.byrne
%
%PROG MODS -	
%  2013-01-08 
% 	Mods to help text
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

if any(size(X)==1), X=X(:); end;
[m,n]=size(X);
if length(x)~=n,
	error('Vector x must have same number of elements as columns in matrix');
end;

Y=X(x+m.*[0:n-1]);

