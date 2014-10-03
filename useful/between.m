function I = between( X, R, neg )
%BETWEEN - 	 Find elements of the matrix between the extremes of the range
% 
%USAGE -	I = between(X,R,neg)
%
%EXPLANATION -	X data
% 		R range inside which to find 
% 		I index of X points inside R
% 		neg invert the match, ie find points outside R bool
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	c. 2011-02 
% 
%	$Revision: 1.8 $
%	$Date: 2013-04-12 16:56:35 $
%	$Id: between.m,v 1.8 2013-04-12 16:56:35 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2013-04-11 
% 	introduce inverse function
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

if exist('neg','var')~=1, neg=[]; end
if isempty(neg), neg=false; end

if ischar(neg)
	neg=strcmpi('not',neg);
end

if neg
	I=find(X>max(R) | X<min(R)); 
else
	I=find(X<=max(R) & X>=min(R)); 
end


