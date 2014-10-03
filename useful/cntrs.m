function [X,Y,V]=cntrs(c)
% - 	
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: cntrs.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
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


X=NaN;
Y=NaN;
V=c(1,1);

j=1;
i(j)=2;
n(j)=c(2,1)+1;

while n(j)+2 < length(c),
	j=j+1;
	i(j)=n(j-1)+2;
	n(j)=n(j-1)+c(2,i(j)-1)+1;

	x=c(1,i(j):n(j)).';
	y=c(2,i(j):n(j)).';
	[X,x]=samerows(X,x);
	[Y,y]=samerows(Y,y);
	X(:,j)=x;
	Y(:,j)=y;
	V(j)=c(1,i(j)-1);

end;


