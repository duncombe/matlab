function str=cell2str(cellstrn)		%{{{
%CELL2STR - 	returns strings from cell items
% 
%USAGE -	str=cell2str(cellstrn)
%
%EXPLANATION -
% 	Cell arguments returned from functions often need to be
% 	turned into something else. There doesn't seem to be a
% 	way to do this without putting the returned value into a
% 	temporary variable. This function goes to fix this.
% 
% 	To convert a cell array of strings into a character array
% 	use CHAR
%
%SEE ALSO -	
%	char
% 
%BUGS -
%	Function does not seem to work as intended.
% 

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae		% {{{
%
%CREATED -	2009/02/20 
% 
%	$Revision: 1.7 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: cell2str.m,v 1.7 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2011/01/24 
% 	Include recursion to deal with nested strings, e.g.,
% 	regexp with tokens on a cell array will return a cell
% 	array of matches for each cell. 
% 
% }}}

% License	 % {{{
% -------
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

str=cellstrn{:};

% recurse if the contents are cell
if iscell(str),
	str=cell2str(str);
end;
return;

