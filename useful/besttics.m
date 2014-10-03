function [xtics,xlabs]=besttics(do)
% BESTTICS -	ticks and labels for BEST program
%
% USAGE -	[xtics,xlabs]=besttics(do)
% 
%		xtics -	vector of x-axis tics (x-axis should be 
%			timebase in days) 
%		xlabs -	vector of x-axis labels 
%		do -	plot on current figure or return vectors
%
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -	
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
%
% 

if ~exist('do'), do=0; end;
modays = [ 	0 31 29 31 30 31 30 31 31 30 31 30 31, ...
		31 28 31 30 31 30 31 31 30 31 30 31 ...
	];  
%
moname = [ 	'Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; ...
		'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'; ...
		'Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; ...
		'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'; 'Jan' ...
	];
%
xtics = cumsum(modays)+1;
xlabs = moname(:,1);	% xlabs = [' '.*ones(size(moname,1),5) moname];
if do, set(gca,'xtick',xtics,'xticklabels',xlabs); end;
return;
