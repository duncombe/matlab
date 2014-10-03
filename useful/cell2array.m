function  M=cell2array(C)	% {{{
%CELL2ARRAY - concatenates the elements of a cell array into a matrix 
% 
%USAGE -	M=cell2array(C)
%
%EXPLANATION -	Performs the action of [A{:}] 
% 		on numerical cells of different lengths
%
%SEE ALSO -	SAMEROWS, CELL2MAT
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-07-18 
%	$Revision: 1.1 $
%	$Date: 2013-03-20 10:42:04 $
%	$Id: cell2array.m,v 1.1 2013-03-20 10:42:04 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2013-03-20 
% 	Edits to help text
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
M=[];

	for i=1:length(C),	
		[M,c]=samerows(M,C{i}(:));
		M=[M,c]; 
	end

