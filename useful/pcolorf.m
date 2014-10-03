function  varargout=pcolorf(varargin)	% {{{
%PCOLORF - does pcolor and sets the shading to flat for you
% 
%USAGE -	varargout=pcolorf(varargin)
% 		(same arguments and outputs as pcolor, which see)
%
%EXPLANATION -	Mathworks does not believe in providing a method to set
%		default shading in pcolor, and to avoid the intense
%		irritation of doing pcolor and being presented with a
%		completely black square, pcolorf does the shading command
%		automatically. 
%
%SEE ALSO -	PCOLOR
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2013-03-29 (SPURS-2, EN-255)
% 
%	$Revision: 1.1 $
%	$Date: 2013-03-31 07:27:11 $
%	$Id: pcolorf.m,v 1.1 2013-03-31 07:27:11 duncombe Exp $
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

varargout=cell(1,nargout); 
[varargout{:}]=pcolor(varargin{:});
shading('flat');


