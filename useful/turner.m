function Tu = turner(S,T,P,wind)
%TURNER - Calculates the Turner Angle for water column stability	
% 
%USAGE -	Tu = turner(S,T,P,wind)
%
%EXPLANATION -	
% 		wind = filter window (applied with nanfiltfilt)
%
%SEE ALSO -	
% 	spice.m
% 	sw_dens0.m
%
%REFS - 
% Flament, P. (2002), A state variable for characterizing water
% 	masses and their diffusive stability: spiciness, Prog.
% 	Oceanogr., 54(1--4), 493--501.

 

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.4 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: turner.m,v 1.4 2011-04-09 14:05:14 duncombe Exp $
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

% test for arguments being separate (S,T,P) or matrixed [S,T,P]
if nargin==1,
	% split the arg into S, T, P
	wind=[];
	P=S(:,3); T=S(:,2); S=S(:,1);
elseif nargin==2,
	% arg 2 had better be the filter window
	wind=T;
	P=S(:,3); T=S(:,2); S=S(:,1); 
elseif nargin==3
	wind=[];
	% S=S; T=T; P=P;
% elseif nargin>3
	% arg 4 had better be the filter window
end;

if ~isempty(wind),
	S=nanfiltfilt(wind,sum(wind),S);
	T=nanfiltfilt(wind,sum(wind),T);
	% do not filter the depth coordinate
end; 

Pi=spice(S,T,P);
Rho=sw_dens0(S,T);

Tu=180./pi.*atan2(diff(Pi),diff(Rho));

return;

