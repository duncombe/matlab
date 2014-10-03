function Y = circ_prctile(X, P, dim)	% {{{
% 
%CIRC_PRCTILE - returns P percentiles of circular data in X (radians)
% 
%USAGE -	Y = circ_prctile(X, P, dim)
%
% 		X circular data
% 		P percentiles to extract
% 		dim along this dimension of X
% 
%EXPLANATION -	Analogous to prctile, for linear data,
%	circ_prctile calculates percentiles for circular or
%	angular data. There is a conceptual difficulty in getting
%	maxima, minima and percentiles of data arranged on a
%	circle since 2pi wraps to 0. However, see Zar, or Fisher,
%	for an explanation of the circular median. The median of
%	data on a circle is the diameter of the circle which
%	divides the data into two equal counts.  This diameter
%	is described by two points on the circle and the median
%	is chosen as the point on the side of the most data
%	points.  Having obtained a median, calculating other
%	percentiles involves subtracting the median from all the
%	data, rendering the angular data in a linear form where
%	determination of the maximum, minimum and percentiles is
%	possible using prctile.m. 
% 
%SEE ALSO -	circ_median, circ_mean, prctile, mean, median
% 
%FUNCTIONS CALLED -
% 	wrapToPi (Map Toolbox)
%	circ_median (CircStat Toolbox)
% 	prctile (Stats Toolbox)
% 

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae 	% {{{
%
%CREATED -	2010/11/28 
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: circ_prctile.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%
% }}}

% License	% {{{
% -------
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
% }}}

if nargin<2, error('circ_prctile: not enough arguments'); end;


% Determine the circular median (sometime go to median and sort
% out how to deal with the dimension problem. Meantime, pass the
% problem to circ_median if necessary.
if nargin>2, 
	m=circ_median(X,dim);
else
	m=circ_median(X);
end;

% rotate the data so the median is at 0 and ensure that all are
% in the interval -pi to +pi
x=wrapToPi(X-m);

if nargin>2, 
	y=prctile(x,P,dim);
else
	y=prctile(x,P);
end;

% rotate back and reduce to the first rev
Y=mod(y+m,2.*pi);

return;

