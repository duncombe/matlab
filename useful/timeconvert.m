function  dat=timeconvert(varargs)		% {{{
%TIMECONVERT - 	
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
%CREATED -	
%	$Revision: 1.1 $
%	$Date: 2011-04-27 22:57:31 $
%	$Id: timeconvert.m,v 1.1 2011-04-27 22:57:31 duncombe Exp $
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

if nargin==4,
	date=varargs{1};
	year=varargs{2};
	from=varargs{3};
	to=varargs{4};
elseif nargin==3,
	date=varargs{1};
	from=varargs{2};
	to=varargs{3};
else
	error('number of args is 3 or 4');
end;

if size(date,2)==3 || size(date,2)==6, 	% then it is a date vector: 
	numdate=datenum(date);
end;

switch from,
	'yday', 	

if exist('year')~=1, year=[]; end;
if isempty(year), year

mday
yday=mday-datenum(year,1,0);

