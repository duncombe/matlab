function CTD=checkprs(expr)
% CHECKPRS - 	checks consistency of PRS data files 	
% 
% USAGE -	CTD=checkprs(expr)
%
% EXPLANATION -	
%
% SEE ALSO -	
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	2000-05-30
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
if ~exist('expr'), 
        expr='*.PR2'; 
else 
        if isempty(expr), 
                expr='*.PR2'; 
        end; 
end;

L=ls(expr);
[l,L]=strtok(L);
while ~isempty(l),
	more off; 
	disp(l);
	more on;

	stp=prsload(l);
	[stp,pos,dt,stn,snd,id,dat]=prsload(l);

	figure; plot(dat(:,1),diff([0;stp(:,3)]));
		title(l);
		xlabel('Scan');
		ylabel('Pressure Diff');
		zoom on;
	[l,L]=strtok(L);
end;

return;
