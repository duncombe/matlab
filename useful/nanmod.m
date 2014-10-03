function X=nanmod(Y,n)
%NANMOD - 	calculates remainder after division ignoring NaNs
% 
%USAGE -	X=nanmod(Y,n)
%
%EXPLANATION -	Why did I write this? Builtin mod seems to do
%		exactly this.
%
%SEE ALSO -	mod, rem, fix
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.4 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: nanmod.m,v 1.4 2011-04-09 14:05:14 duncombe Exp $
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

I=find(isnan(Y));
Y(I)=0;
X=mod(Y,n);
X(I)=NaN;
return;
