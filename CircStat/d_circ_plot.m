function a = d_circ_plot(varargin)
% - 	circ_plot with degrees instead of radians
% 
%USAGE -	
%
%EXPLANATION -	CircStat toolbox demands radian arguments,
%	geosciences deal almost excluesively with degrees; this
%	is a  trivial wrapper to render one of the CircStat
%	modules a little more accessible.
%
%SEE ALSO -	circ_plot
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2010/11/26 
%	$Revision: 1.1 $
%	$Date: 2010-11-26 21:28:40 $
%	$Id: d_circ_plot.m,v 1.1 2010-11-26 21:28:40 duncombe Exp $
%
%CHANGELOG -	
%
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

alpha=deg2rad(varargin{1});
a = circ_plot(alpha, varargin{2:end});
return;

