function S=guildl(Rt,T)
% GUILDL -	Calculates Salinity from conductivity ratio for
%		the guildline salinometer (UNESCO/ICES/SCOR/IAPSO 1980)
%
% USAGE -	S=guildl(Rt,T)


% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1999-08-31
%
% PROG MODS -	
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

a=[0.0080,-0.1692,25.3851,14.0941,-7.0261,2.7081];
b=[0.0005,-0.0056,-0.0066,-0.0375,0.0636,-0.0144];

p=[0:5];
R=sqrt(repmat(Rt,1,size(p,2)).^repmat(p,size(Rt,1),1));
dT=T-15;

dS=dT./(1+0.0162.*dT).*R.*repmat(b,size(R,1),1);
% S=sum(R.*repmat(a,size(R,1),1))+repmat(sum(dS,2),1,size(a,2);
S=sum(R.*repmat(a,size(R,1),1),2)+sum(dS,2);
return;
