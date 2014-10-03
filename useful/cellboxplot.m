function  [hands,X]=cellboxplot(C,varargin)	% {{{
%CELLBOXPLOT - box-whisker plots on same axes of data in cell array
% 
%USAGE -	[hands,X]=cellboxplot(C,varargin)
%
%EXPLANATION -	hands - handles to figure
% 		C - cell array of data 
% 		varargin - arguments to boxplot
% 
% 		Function algorithm is to concatenate cells into a single
% 		matrix and then call boxplot on the large matrix. 
%
%SEE ALSO -	useful/samerows
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-11-18 
% 
%	$Revision: 1.3 $
%	$Date: 2012-08-28 15:40:15 $
%	$Id: cellboxplot.m,v 1.3 2012-08-28 15:40:15 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2012-08-23 
% 	deal with call with non-cell argument
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

X=[]; 

if iscell(C),
	for i=1:length(C),	
		[X,c]=samerows(X,C{i}(:));
		X=[X,c]; 
	end
elseif isnumeric(C)
	X=C;
else
	error('Argument is not a cell array');
end

hands=boxplot(X,varargin{:});


