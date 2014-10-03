function [h,L,H]=catenary(d,D,s,w)
%function [h,L,H]=catenary(d,D,s,s0,w)
%
% find the depth of sensors given the depth at one point, water 
% columnn depth, and cable lengths, assuming a catenary
% 	h	height
% 	L 	span
%	H	horizontal tension
%
%	d	depth of reference sensor (from pres readings conv to dept)
%	D	water column depth
%	S	cable segments
%	w	weight per unit length

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2005-12-01
%		
%
%PROG MODS -	
%		2006-02-19: change the input parameters
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

% S given is half what the equations desire

S=2.*s;

m=size(d,1);
n=size(S,2);

h=zeros(m,n);
h(:,1)=D-d;

% Calculate the horizontal tension
H=w./(8.*h(:,1)).*( (S(1).^2) - (4.*h(:,1).^2) ); 

% Calculate the span
L=2.*( H*ones(1,n) )./w.*asinh( ones(m,1)*S .*w ./ ( 2.* H*ones(1,n) ) );

% height
h= ( H*ones(1,n) ./w ) .* ( cosh( w.* L ./ ( 2.*H*ones(1,n) ) ) -1 ) ;

% return half of L (since we were called with only half of S)

L=L./2;

return;

