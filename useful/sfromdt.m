function S=sfromdt(T,D,p)
%TFROMDS -	Temperature from a density and salinity	
% 
%USAGE -	S=sfromdt(T,D,p)
%
%EXPLANATION -	
%
%SEE ALSO -	tfromds
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-09-04
%
%PROG MODS -	Modified from tfromds.m
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

if min(size(T))>1, error('T must be a vector'); end;
if min(size(D))>1, error('D must be a vector'); end;
if max(size(p))>1, error('p must be a scalar'); end;

[m,n]=size(T); if m<n, T=T'; end;

s=[0:0.01:40].';
S=[];

R=sw_dens( ones(size(T,1),1)*s', T*ones(1,size(s,1)), p);
for i=1:length(T),
	Si=interp1(R(i,:),s,D,'spline');
	S=[S;Si'];
end;

return;
% 
