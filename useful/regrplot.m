function [h]=regrplot(SL, IN, STERR, COL)
% REGRPLOT -	Plots a regression line and std error limits on the current plot
%
% USAGE -	h=regrplot(SL, IN, STERR, COL)
%		SL - slope
%		IN - intercept
%		STERR - standard error
% 		COL - color for drawing the lines
% 		h - vector of handles to the lines drawn (1 is
% 		line, h(2) is upper error line, h(3) is lower
% 		error line.
%
% SEE ALSO -	REGRESS
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae SFRI 96-09-14
%
% PROG MODS -	
%  2010/11/17 
% 	check input properly, return line handles
%	set line styles more aesthetically
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

if exist('STERR')~=1, STERR=[]; end; 
if isempty(STERR), STERR=0; end;

if ~exist('COL')
	COL='r';
end;

ax=axis; x=ax(1:2); 
h=zeros(1,3);
y = x .* SL + IN ;         
yeu = x .* SL + IN + STERR ; 
yel = x .* SL + IN - STERR ; 
h(1)=line(x,y); set(h(1),'color',COL);
h(2)=line(x,yeu); set(h(2),'color',COL,'linestyle','-.'); 
h(3)=line(x,yel); set(h(3),'color',COL,'linestyle','-.');

return;

