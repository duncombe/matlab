function varargout=yaxis(varargin)
% YAXIS -	changes the y-axis of a matlab plot
%
% USAGE - 	yaxis(ha,y)
%		y - [ymin, ymax]
%		ha - optional argument axis handle

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -	
%  2013-03-27 
% 	Conversion to export or display as well as set the axis,
%  	in the same way as xaxis.
%  2013-04-03 
% 	allow for axis handles 
%  2013-04-04 
% 	fix a bug regarding testing for a handle
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

% if exist('y','var')~=1, y=[]; end
% keyboard
if nargin<1, 
	y=[]; 
	ah=gca; 
else
	if length(varargin{1})>1
		ah=gca;
		y=varargin{1};
	else
			% if ishandle(varargin{1})
			% get(gca,'type') == axes, not figure]
		ah=varargin{1};
		if nargin>1
			y=varargin{2};
		else y=[];
		end
	end
end

A=axis(ah);

if ~isempty(y)
	A(3:4)=y;
	axis(ah,A);
else
	y=A(3:4);
	varargout{1}=y; 
end
if nargout>0
	y=A(3:4);
	varargout{1}=y;
end

