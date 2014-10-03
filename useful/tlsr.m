function [a,b,c] = tlsr(x,y)	% {{{
%TLSR - total least squares regression or orthogonal regression
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	
%	$Revision: 1.2 $
%	$Date: 2011-06-20 18:03:22 $
%	$Id: tlsr.m,v 1.2 2011-06-20 18:03:22 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
% }}}

% License {{{
% -------
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
% }}}

if nargin==1,
	X=x;
else
	X=[x,y];
end;

[A,B,C]=princomp(X);

% returns [intercept,slope]

sl=A(2,1)./A(1,1); 

in=mean(X)*[-sl;1];
a=[in,sl];

[n,m]=size(X);

% Xfit
b = repmat(mean(X),n,1) + B(:,1)*A(:,1).';

c=C;
% error 
c = abs((X - repmat(mean(X),n,1))*A(:,2));

return;

% [n,p] = size(X);
% meanX = mean(X,1);
% Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
% residuals = X - Xfit;
% 
% The equation of the fitted plane, satisfied by each of the fitted
% points in Xfit, is ([x1 x2 x3] - meanX)*normal = 0. The plane
% passes through the point meanX, and its perpendicular distance to
% the origin is meanX*normal. The perpendicular distance from each
% point in X to the plane, i.e., the norm of the residuals, is the
% dot product of each centered point with the normal to the plane.
% The fitted plane minimizes the sum of the squared errors.
% 
% error = abs((X - repmat(meanX,n,1))*normal);
% sse = sum(error.^2)
% 
