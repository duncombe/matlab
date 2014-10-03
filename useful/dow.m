function DOW=dow(dat)
% DOW -	day of week, calculates dow from algorithm by Mike Keith
% 	http://users.aol.com/s6sj7gt/mikecal.htm
%
% USAGE -	DOW=dow(dat)
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	
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

y=dat(:,1); m=dat(:,2); d=dat(:,3);
M=m<3;
Y=y-M;

DOW=rem( (fix(23.*m./9)+d+2+Y+M.*3+fix(Y./4)-fix(Y./100)+fix(Y./400)),7);
return;


%%
%% original expression
%% (23*m/9+d+4+(m<3?y--:y-2)+y/4-y/100+y/400)%7 
%% (23*m/9+d+4+(m<3?y--:y-2)+y/4-y/100+y/400)%7 
%%

% if y<100, y=y+1900; end;
%if m<3,
%	y=y-1;
%	DOW=(fix(23.*m./9)+d+4+y+1+fix(y./4)-fix(y./100)+fix(y./400));
%else
%	DOW=(fix(23.*m./9)+d+4+y-2+fix(y./4)-fix(y./100)+fix(y./400));
%end;
% DOW=rem(DOW,7); 

