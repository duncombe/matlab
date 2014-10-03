function tsplot(stp,tit)
% TSPLOT - 	plots parameter-parameter diagrams
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.4 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: tsplot.m,v 1.4 2011-04-09 14:05:14 duncombe Exp $
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


figure;
	plot(stp(:,1),stp(:,2),'o'); 
	axis([34.2,35.8,0,25]);
	xlabel('Salinity');
	ylabel('Temperature');
	title(tit);
	orient landscape; 
	set(gcf,'PaperPosition',[1 0.5 8.5 7]);
	zoom on;

return;

