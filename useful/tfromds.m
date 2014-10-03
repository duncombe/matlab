function T=tfromds(S,D,p)
%TFROMDS -	Temperature from a density and salinity	
% 
%USAGE -	T=tfromds(S,d,p)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2002-06-12
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

if min(size(S))>1, error('S must be a vector'); end;
if min(size(D))>1, error('D must be a vector'); end;
if max(size(p))>1, error('p must be a scalar'); end;

[m,n]=size(S); if m<n, S=S'; end;

t=[-2:0.01:40]';
T=[];

R=sw_dens(S*ones(1,size(t,1)),ones(size(S,1),1)*t',p);
for i=1:length(S),
	Ti=interp1(R(i,:),t,D,'spline');
	T=[T;Ti'];
end;

return;
% 
