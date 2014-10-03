function N=lottery(n)
% LOTTERY - 	Chooses n x 6 lotto numbers from 1 to 49 
%
% USAGE - 	N=lottery(n)
% 
% EXPLANATION - N: the numbers (nx6 matrix)
% 		n: number of tickets to choose
%		
% USES - 	rand
%


% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	2000-03-17
%
% PROG MODS -	
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

rand('seed',sum(100*clock));

if ~exist('n'), n=[]; end;
if isempty(n), n=1; end;

d=sort(ceil(rand(6,n).*49));

I=find(diff(d(:))==0);
while ~isempty(I),
 	d(I)=ceil(rand(size(I)).*49);
	d=sort(d);
	I=find(diff(d(:))==0);
end;	
N=d';
 
return;

