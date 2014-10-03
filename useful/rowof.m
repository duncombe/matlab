function Y=rowof(X,I)
%ROWOF - returns a row of the matrix	
% 
%USAGE -	
%
%EXPLANATION -	X - matrix
%		I - row number
%
%SEE ALSO -	
%
%BUGS -
% 	Should be generalised so that call will return vector
% 	from any dimension - vectorfrom(X,I,DIM).  Should involve
% 	a combination of shiftdim and squeeze?

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2010/10/29 
%	$Revision: 1.5 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: rowof.m,v 1.5 2011-04-09 14:05:14 duncombe Exp $
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

Y=X(I,:);
return;
