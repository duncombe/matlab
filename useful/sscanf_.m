function [S,COUNT,ERRMSG,NEXTINDEX]=sscanf_(s,vorm,N); 

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
S=[];
L=s;
if isinf(N(2)),
	i=0;
	while ~isempty(L),
		i=i+1;
%		disp(i);
		for j=1:N(1),
			[l,L]=strtok(L,[9 10 ' ']);
			if ~isempty(l), S(i,j)=str2num(l); end;
		end;
	end;
else
	for i=1:N(2),
		for j=1:N(1),
			[l,L]=strtok(L,[9 10 ' ']);
			if ~isempty(l), S(i,j)=str2num(l); end;
		end;
	end;
end;
COUNT=i;
ERRMSG=[];
NEXTINDEX=i+1;

return;

