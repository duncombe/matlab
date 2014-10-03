function [D]=parsdate(datestr)


% 
% 2013-03-30 
% 	discover a bug. seconds were never returned, because the regex did
% 	not match.

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

month=['JAN';'FEB';'MAR';'APR';'MAY';'JUN';'JUL';'AUG';'SEP';'OCT';'NOV';'DEC'];

A=[]; m=0;
while isempty(A),
	A=findstr(month(m+1,:),upper(datestr)); m=m+1;
end;

R=datestr(16+3:length(datestr));
[d,R]=strtok(R);
[Y,R]=strtok(R);
[H,R]=strtok(R,':');
[M,R]=strtok(R,':');
[S,R]=strtok(R,': ');
D=[str2num(Y) m str2num(d) str2num(H) str2num(M) str2num(S)];

if length(D) ~= 6, warning('Bad time string'); end

% disp(datestr);
% disp(D);

