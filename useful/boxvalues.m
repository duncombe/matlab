function [med, qu, outl, extreme, N ]=boxvalues(X) % {{{
%BOXVALUES -
% 
%USAGE -	
%
%EXPLANATION -	myboxplot.m waxs being used to provide critical values for
%		drawing a boxpot. Turned out to return bad values.
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-12-12 
%	$Revision: 1.1 $
%	$Date: 2012-12-12 15:11:39 $
%	$Id: boxvalues.m,v 1.1 2012-12-12 15:11:39 duncombe Exp $
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

q=prctile(X,[0 25 50 75 100].');
med=q(3,:);
qu=q([2,4],:);
extreme=q([1,5],:);
N=sum(~isnan(X),1);
iqr=qu(2,:)-qu(1,:);

up=qu(2,:)+iqr*1.5;
lo=qu(1,:)-iqr*1.5;

for i=1:size(X,2)
	lov(i)=min(X(X(:,i)>=lo(i),i));
	upv(i)=max(X(X(:,i)<=up(i),i));
end

outl=[lov;upv];

