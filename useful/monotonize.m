function  [Y,I,cnt]=monotonize(X,ratio)	% {{{
%MONOTONIZE - 	Remove reversals from series 
% 
%USAGE -	[Y,I,cnt]=monotonize(Y)
%
%EXPLANATION -	for when interp1 complains about multiple x values
% 		To reverse sense of monotonization, ie for decreasing
% 		series, pass -X and multiply output by -1.
% 
% 		X - 
% 		I - index to input of output values
% 		cnt - iterations in loop to achieve result
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2013-04-06 
% 
%	$Revision: 1.1 $
%	$Date: 2013-04-07 14:21:19 $
%	$Id: monotonize.m,v 1.1 2013-04-07 14:21:19 duncombe Exp $
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

if exist('X','var')~=1, error('Requires an argument'); end
if exist('ratio','var')~=1, ratio=25; end

Y=X;
m=length(X);
I=1:length(Y);
cnt=0;
while true
	i=find(diff(Y)<=0);
	if isempty(i), break; end
	Y(i+1)=[];
	I(i+1)=[];
	cnt=cnt+1;
end
if 100*(1-length(Y)./length(X)) > ratio
	warning(['More than ' num2str(ratio) '% data discarded']);
end


