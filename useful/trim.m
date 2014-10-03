function B=trim(A,n)
%TRIM - 	remove the highest n and lowest n 
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
%	$Id: trim.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
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

B=A;

if exist('n')~=1, n=1; end;

for i=1:n,
	[junk,I]=min(B);
	[junk,J]=max(B);
	for j=1:size(B,2),
		B(I(j),j)=NaN;
		B(J(j),j)=NaN;
	end;
end;

return;

