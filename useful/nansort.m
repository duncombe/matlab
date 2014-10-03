function varargout=nansort(varargin)
%NANSORT - 	sort paying attention to NaNs	
% 
%USAGE -	varargout=nansort(varargin)
% 		as for normal sort
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2009/03/26 
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: nansort.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
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

% default
B=varargin{1};
rep=inf;
for i=2:nargin,
	if ischar(varargin{i}),
		if strmatch(varargin{i},'ascend'), rep=inf; end;
		if strmatch(varargin{i},'descend'), rep=-inf; end;
	end;
end;
I=find(isnan(B));
B(I)=rep;
[A,J]=sort(B,varargin{2:nargin}) ;
I=find(isinf(A));
A(I)=NaN;

varargout{1}=A;
varargout{2}=J;

return;

