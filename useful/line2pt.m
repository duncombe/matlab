function [M,C]=line2pt(p1,p2,draw,pen);
%line2pt - 	Calculates the slope and intercept from two points
% 
%USAGE -	[M,C]=line2pt(p1,p2,draw,pen);
%
%EXPLANATION -	M - returned slope
%		C - returned intercept
%		p1,p2 - points
%		draw - draw the line on the current axes (1|0) [0]
%		pen - colour for plot [green]
%
%SEE ALSO -	regrplot
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2002-03-31
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
if ~exist('draw'), draw=[]; end;
if isempty(draw), draw=0; end;
if ~exist('pen'), pen='g'; end;

M=(p2(:,2)-p1(:,2))./(p2(:,1)-p1(:,1));
C=p2(:,2)-M.*p2(:,1);

if draw, regrplot(M,C,0,pen); end;
return
