function  flipyaxis(fh)	% {{{
%FLIPYAXIS - reverses the direction of the y axis on current plot
% 
%USAGE -	flipyaxis(fh)	
%
%EXPLANATION -	 fh - figure handle
% 		Simple function cannot deal with multiple axes in subplots. 
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-08-31 
% 
%	$Revision: 1.3 $
%	$Date: 2012-09-11 09:17:06 $
%	$Id: flipyaxis.m,v 1.3 2012-09-11 09:17:06 duncombe Exp $
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

if exist('fh','var')~=1, fh=[]; end
if isempty(fh), fh=gcf; end

ah=findobj(fh,'type','axes');

ydir=get(ah,'ydir');

% keyboard

J=find(strcmp(ydir,'normal'));
I=find(strcmp(ydir,'reverse'));
set(ah(I),'ydir','normal');
set(ah(J),'ydir','reverse');
end


