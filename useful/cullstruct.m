function  A=cullstruct(C,I)	% {{{
%CULLSTRUCT - 	remove redundant/bad rows from structure
% 
%USAGE -	A=cullstruct(C,I)
%
%EXPLANATION -	
%
%SEE ALSO -	
%
%KEYWORDS - truncate, reduce, remove, delete, trim, rationalize

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-07-10 
%	$Revision: 1.1 $
%	$Date: 2011-07-11 01:56:41 $
%	$Id: cullstruct.m,v 1.1 2011-07-11 01:56:41 duncombe Exp $
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


%  remove row index values I from structure C 
fn=fieldnames(C);
A=C;
for i=1:length(fn),
	[m,n]=size(C.(fn{i}));
	if m~=1 || n~=1 && max(I)<=m,
		A.(fn{i})(I,:)=[];
	end;
end;
return;

