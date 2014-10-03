function C=num2cellstr(N)
%NUM2CELLSTR - 	converts a number matrix to a cell matrix of strings
% 
%USAGE -	
%
%EXPLANATION -	converting numbers to strings often requires
%		several steps, intermediate variables and loops.
% 		This function converts the matrix. A common usage
% 		is in labelling axes.
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2010/10/19 
%	$Revision: 1.2 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: num2cellstr.m,v 1.2 2011-04-09 14:05:14 duncombe Exp $
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

C=cell(size(N)); 
for i=1:numel(N),
	C(i)={num2str(N(i))};
end;
return;
