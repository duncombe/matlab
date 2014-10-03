function  displayerror(EM)	% {{{
%DISPLAYERROR - 	
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
%CREATED -	2012-10-29 
% 
%	$Revision: 1.1 $
%	$Date: 2012-12-12 21:04:47 $
%	$Id: displayerror.m,v 1.1 2012-12-12 21:04:47 duncombe Exp $
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
disp(EM.message);

for i=1:length(EM.stack),
	disp(['Error using ' EM.stack(i).name ' in line ' num2str(EM.stack(i).line)]);
end


% 	MException object with properties:
% 
%     identifier: 'MATLAB:badsubscript'
%        message: 'Index exceeds matrix dimensions.'
%          stack: [3x1 struct]
%          cause: {}
% 
% 3x1 struct array with fields:
%     file
%     name
%     line
% 
