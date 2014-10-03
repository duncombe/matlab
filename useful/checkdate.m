function nvec=checkdate(vec)
% 
%CHECKDATE - 	checks a date vector for two digit year and corrects
% 
%USAGE -	nvec=checkdate(vec)
%
%EXPLANATION -	
% 	Need to check dates for Y2K problem. Designed for
% 	collected data, so always in the past. Pivot year always
% 	taken from now().
%
%SEE ALSO -	
% 
%FUNCYIONS CALLED -
% 	columnof (Useful Toolbox)
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2010/12/30
%	$Revision: 1.4 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: checkdate.m,v 1.4 2011-04-09 14:05:14 duncombe Exp $
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

nvec=vec;
if vec(1) < 100, % two digit year
	if vec(1) > mod(columnof(datevec(now),1),100),
		nvec(1)=vec(1)+1900;
	else
		nvec(1)=vec(1)+2000;
	end;
end;
return;
