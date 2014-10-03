function  [M,D]=vect2met(varargin)	% {{{
%VECT2MET - converts a vector (east and north components) to mag and dir
% 
%USAGE -	[M,D]=vect2met(E,N)
% 	or	[M,D]=vect2met(V)
% 	where V is a (2 x n) matrix ([E N]) or complex (E+i*N)
%
%EXPLANATION -	This can be confusing. Put it in a function and avoid
%		reinventing the wheel everytime.
%
%SEE ALSO -	pol2cart, 
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-07-24 
% 
%	$Revision: 1.2 $
%	$Date: 2012-07-26 17:54:26 $
%	$Id: vect2met.m,v 1.2 2012-07-26 17:54:26 duncombe Exp $
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

switch nargin
case 1
	if ~isreal(varargin{1})
		N=imag(varargin{1});
		E=real(varargin{1});
	else
		if any(size(varargin{1})==2),
			dim=find(size(varargin{1})==2);
			switch dim,
			case 1, N=varargin{1}(2,:); E=varargin{1}(1,:); 
			case 2, N=varargin{1}(:,2); E=varargin{1}(:,1);
			end
		else
			error('single argument must be 2 x n or n x 2');
		end
	end
case 0
	help(mfilename);
	error('No arguments');
case 2
	N=varargin{2};
	E=varargin{1};
otherwise
		error('Takes maximum 2 arguments');
end

% all it seems to take is switching x and y in making a complex number
V=N+1i*E;
M=abs(V);
D=angle(V)*180/pi;

