function varargout=xaxis(varargin)
% XAXIS -	changes the x-axis of a matlab plot
%
% USAGE - 	x=xaxis(ha,x)
%		x - [xmin, xmax]
%		ha - optional argument axis handle
% 		'equal' - optional argument to change y axis to remain
% 		equal to changed x axis

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -	
%  2013-03-11
% 	Seems to have made this change on that date. To determine and
% 	export the axis information as well as set it.
%  2013-03-27 
% 	display or not display as inituitively expected
% 
%  2013-04-03 
% 	allow for axis handles 
%  2013-04-04 
% 	fix a bug regarding testing for a handle
%  2013-04-09 
% 	bugfix y= -> x=
% 	arrange so that yaxis can be kept equal if the xaxis changes
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
%

% if exist('x','var')~=1, x=[]; end
keepequal=false;
if nargin<1, 
	x=[]; 
	ah=gca; 
else
	if ~all(ishandle(varargin{1}))
		ah=gca;
		x=varargin{1};
	else
		ah=varargin{1};
		if nargin>1
			x=varargin{2};
		else x=[];
		end
	end
	if any(strcmp('equal',varargin)), keepequal=true; end
end

A=axis(ah);

if ~isempty(x)
	A(1:2)=x;
	if keepequal
		dx=[A(2)-A(1)]/2;
		yc=mean(A(3:4));
		A(3:4)=yc+dx*[-1 1];
	end
	axis(ah,A);
else
	x=A(1:2);
	varargout{1}=x; 
end
if nargout>0
	x=A(1:2);
	varargout{1}=x;
end

