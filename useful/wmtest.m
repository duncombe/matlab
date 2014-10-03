function [WMASSES,WMNS,WMCHAR]=wmtest(STP,silent)
% WMTEST - 	water mass analysis on STP matrix
% 
%USAGE -	[WMASSES,WMNS,WMCHAR]=wmtest(STP,silent)
%
%EXPLANATION -	 WMASSES - water masses 
%		WMNS - Water mass names
%		WMCHAR - characteristics used
%		STP - 	salinity temperature pressure
%		silent - display wm name [1]
%
%SEE ALSO -	isinpoly (saga toolbox), wmdefn
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-11-25
%
%PROG MODS -	2003-11-27: run silently
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

% wmdefn sets up the water mass definitions
% NWM is the number of water masses
% WMN# is the water mass name for water mass #
% WM# is the definition for water mass # (S,T,P)

if ~exist('silent'), silent=1; end;

[WMCHAR,WMNS,NWM]=wmdefn;

S=STP(:,1);
T=STP(:,2);
P=STP(:,3);
WMASSES=zeros(size(STP,1),1);

for i=1:NWM,
	% disp(i)
	% size(WMASSES)
	% if ~silent, eval( [ 'disp(WMN' num2str(i) ');']); end;
	% eval( [ 'I=find(isinpoly(S,T,WM' num2str(i) '(:,1),WM' num2str(i) '(:,2)));'] );
	if ~silent, disp(WMNS(i,2)); end;
	j=find( sum(isnan(WMCHAR.'))==size(WMCHAR,2)); j=[j,size(WMCHAR,1)+1];
	k=j(i)+1:j(i+1)-1;
	I=find(isinpoly(S,T,WMCHAR(k,1),WMCHAR(k,2)));

	WMASSES(I,size(WMASSES,2))=0.*I+i;
end;

return;
