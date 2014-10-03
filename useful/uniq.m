function [Y,J]=uniq(X)	% {{{
%UNIQ -	determines whether adjacent rows of matrix are unique 
%	and returns the unique rows. (Use unique)
%
%USAGE - 	[Y,J]=uniq(X)
% 		Y unique rows of X
% 		Y==X(J,:)
%		
%SEE ALSO -
% 	unique, intersect, union

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae % {{{
%
%CREATED -	2000-05-19
%	$Revision: 1.6 $
%	$Date: 2012-01-13 15:13:13 $
%	$Id: uniq.m,v 1.6 2012-01-13 15:13:13 duncombe Exp $
%	$Name:  $
%
%PROG MODS -	
%  2012-01-13 
% 	change to return indexes also
%
% }}}

% License % {{{
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

	tilt=0;
	[m,n]=size(X);
	if m==1, X=X.'; tilt=1; t=m;m=n;n=t; end;
	x=diff(X);
	if n>=2, x=sum(x.'); end;
	I=find(x~=0);
	Y=[X(1,:); X(I+1,:)];
	if tilt, Y=Y.'; end;
	J=[1, I+1].';
return;

