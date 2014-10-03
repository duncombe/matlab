function [varargout]=boyplot(X,Y,col)
%BOYPLOT - horizontal boxplot
% 
%USAGE -	H=boyplot(X,Y,col)
%
%EXPLANATION -	
% 	Boxplot functions plot along the x axis with the box-whisker
% 	vertical. This boyplot plots along the y axis with the
% 	box-and-whisker plot horizontal. Y must be vector of size(X,2)
% 	
%
%SEE ALSO -	boxplot, myboxplot, boxvalues
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	before 2012-05-03 
% 
%	$Revision: 1.5 $
%	$Date: 2012-12-13 22:05:01 $
%	$Id: boyplot.m,v 1.5 2012-12-13 22:05:01 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2012-11-29 
% 	This thing is starting to get complicated. Making adjustments to
% 	plot the box and whiskers properly, e.g., plotting the whiskers and
% 	quartiles out to the last data points closer than these limits,
% 	instead of plotting the limits. 
%  2012-11-30 
% 	Returning the handles.
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

if exist('Y','var')~=1, Y=[]; end
if isempty(Y), Y=1:size(X,2); end

if nargout>1
	error('Too many output arguments');
end

H=struct('medians',[],'quartiles',[]);
if nargout==1, varargout={H}; end 

if all(isnan(X))
	warning('USEFUL:boyplot:ArgumentXIsNaN',[ mfilename ' failing. All X is NaN.']);
	return
end

if all(isnan(Y))
	warning('USEFUL:boyplot:ArgumentYIsNaN',[ mfilename ' failing. All Y is NaN.']);
	return
end

% [M,Q,O,E,N]=myboxplot(X,0);
% turns out myboxplot.m was returning very wrong values
[M,Q,O,E,N]=boxvalues(X);


if exist('col','var')~=1, col=[]; end
if isempty(col), col='k'; end

if ischar(col) && length(col)>1, error('marker color wrongly specified');  end

hold on 
% keyboard
H.medians=plot(M,Y,[col '+'],'markersize',12);
for i=1:size(X,2)
	I=between(X(:,i),Q(:,i));
	% plot(Q,[Y;Y],col,'linewidth',6);
	H.quartiles(i,:)=plot(minmax(X(I,i)),[Y(i);Y(i)],col,'linewidth',6);
	% outlier limits
	I=between(X(:,i),O(:,i));
	% plot(O,[Y;Y],col);
	H.outliers(i,:)=plot(minmax(X(I,i)),[Y(i);Y(i)],col);
end
	H.extremes=plot(E,[Y;Y],[col '.'],'markersize',6);

if size(E,2)>1
	H.elines=plot(E.',[Y;Y].',[col '--']);
	H.mlines=plot(M.',Y.',col);
end

if nargout==1
	varargout={H};
end


