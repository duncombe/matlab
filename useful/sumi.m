function [S]=sumi(X)
%SUMI - 	Sum of the elements
% 
%USAGE -	same as sum except nan's are ignore
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-12-09
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
I=find(isnan(X));
X(I)=0.*I;
S=sum(X);
return;
