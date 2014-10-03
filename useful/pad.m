function [X]=pad(X,n,side)
%PAD - 	pad matrix 
% 
%USAGE -	[X]=pad(X,n,side)
%
%EXPLANATION -	X matrix
%		n number of elements to pad
%		side pad at 'top' (left) or 'bottom' (right)
%
%		pad adds rows at top or bottom, so if you want 
%		to add columns, transpose the matrix. If n is 
%		greater than the number of rows, then pad assumes 
%		that the matrix is in row order and adds columns.
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2008/03/17
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: pad.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
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

if ~exist('side'), side='t'; end;

[i,j]=size(X);
t=0;
if i<n, X=X.'; t=1; end;
[i,j]=size(X);
if i<n,
	error('Number of elements to pad is greater than size of matrix');
end;
if strcmpi(side(1),'t'), 
	X=[X(1:n,:);X];
elseif strcmpi(side(1),'b'),
	X=[X;X(i-n+1:i,:)];
else
	disp([ 'Usage: X=' mfilename '(X,n,side);']);
	disp([ '       where side is one of ''t[op]'' or ''b[ottom]''']);
	error('Invalid option for ''side''');
end;
if t, X=X.'; end;
return;

