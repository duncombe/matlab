function [CP,MP]=makeclip(X,Y,cst)
%MAKECLIP - 	aid for generating clip paths
%		Takes a cruise track, plots it and reads input from graph,
%		finding points on the track closest to positions entered
%		with the pointer.
% 
%USAGE -	[CP,MP]=makeclip(X,Y,cst)
%
%EXPLANATION -	X - column vector defining X values
%		Y - column vector defining Y values
%		cst - draw a coastline
%		CP - clip path of points on X,Y closest to mark points [x,y]
%		MP - mark points entered [x,y]
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2001-11-25 at sea on Africana 163
%
%PROG MODS -	
%		2002-04-16 add coastline
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

CP=[];
MP=[];

R=X+i.*Y;
if ~exist('cst'), cst=0; end;

figure; plot(R);hold on;
if cst, coast; end;
butt=1;
while butt==1,
	[x,y,butt]=ginput(1);
	r=x+i.*y;
	[R0,I]=min(abs(R-r));
	if butt==1,
		plot(R(I),'ro');
		plot(r,'mx');
		CP = [ CP; real(R(I)),imag(R(I))];
		MP = [ MP; x,y ];
	else
		CP = [ CP; CP(1,:) ];
		MP = [ MP; MP(1,:) ];
		plot(CP(:,1),CP(:,2),'r');
		plot(MP(:,1),MP(:,2),'m');
		break;
	end;
end;
	
return;
