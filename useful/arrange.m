function  [Y]=arrange(X,I,dim)	% {{{
%ARRANGE - 	arrange the columns of X in order of index I
% 
%USAGE -	[Y]=arrange(X,I,dim)
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
%	$Date: 2013-01-10 17:59:00 $
%	$Id: arrange.m,v 1.1 2013-01-10 17:59:00 duncombe Exp $
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

if exist('dim','var')~=1, dim=[]; end
if isempty(dim), dim=2; end

if exist('I','var')~=1, I=[]; end
if isempty(I), I=1:size(X,dim); end

Y=X(:,I);

