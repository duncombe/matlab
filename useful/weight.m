function X=weight(x,w)
%WEIGHT - 	Expands a matrix, x, according to weights, w
% 
%USAGE -	X=weight(x,w)
%
%EXPLANATION -	x - matrix
%		w - weights (integers)
%		X - expanded matrix
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-12-04
%
%PROG MODS -	
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

nx=0;
[n,m]=size(x);
X=zeros(sum(w),m);
for i=1:size(x,1),
	% X(nx+1:nx+w(i),:)=x(i,:).'*ones(w(i),m)
	X(nx+1:nx+w(i),:)=ones(w(i),m).*(ones(w(i),1)*x(i,:));
	nx=nx+w(i);
	end;
return;
	
