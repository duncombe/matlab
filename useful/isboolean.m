function TF=isboolean(X)	% {{{
%ISBOOLEAN - tests if array is boolean equivalent (1,0,true,false)
% 
%USAGE -	TF=isboolean(X)
%
%EXPLANATION -	tests if an array is logical equivalent, either all ones
% 		and zeroes or all trues and falses. Returns false for [],
% 		strings, and numeric arrays that are not 0 or 1.
%
%SEE ALSO -	ISLOGICAL, ISNUMERIC, LOGICAL
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2013-03-26 on EN522
%	$Revision: 1.1 $
%	$Date: 2013-03-26 06:03:51 $
%	$Id: isboolean.m,v 1.1 2013-03-26 06:03:51 duncombe Exp $
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

if exist('X','var')~=1, X=[]; end
if isempty(X), X=2; end	% consistent with islogical([])==0

if islogical(X)
	TF=true;
elseif all(X==0 | X==1)
	TF=true;
else
	TF=false;
end

