function [hours,mins,secs]=s2hms(sec) % {{{
%S2HMS      converts seconds to integer hour,minute,seconds
%
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2005/11/27 
% 
%	$Revision: 1.4 $
%	$Date: 2011-05-19 16:31:54 $
%	$Id: s2hms.m,v 1.4 2011-05-19 16:31:54 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
% }}}

% License {{{
% -------
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
% }}}

hours=floor(sec/3600);
mins=floor(rem(sec,3600)/60);
secs=(rem(sec,60));

return;

