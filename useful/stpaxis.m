function stpaxis(AX1,AX2,AX3,AX4,AX5,AX6)
% STPAXIS - 	sets the axes on a S, T, P plot as produced by displays
%
% USAGE -	stpaxis(A6)
%		stpaxis(Amin,Amax)
%		stpaxis(S2,T2,P2)
%		stpaxis(Smax,Smin,Tmax,Tmin,Pmax,Pmin)
%
% EXPLANATION -	Smax, Tmax,Pmax - axis maxima
%		Smin, Tmin, Pmin - axis minima
%		S2=[Smax,Smin]
%		T2=[Tmax,Tmin]
%		P2=Pmax,Pmin]
%		Amin=[Smin,Tmin,Pmin]
%		Amax=[Smax,Tmax,Pmax]
%		A6=[Smax,Smin,Tmax,Tmin,Pmax,Pmin]
%
%		Any of the three forms are recognized and can be used.
%
% SEE ALSO - 	displays
%		

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1999-01-22: Africana V150 CMDR
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

ax=ones(1,6);for i=1:6, ax(i)=[]; end;

if nargin==6,
	for i=1:nargin,
		eval(['ax(i)=AX' num2str(i) ';']);
	end;
elseif nargin==3,
	ax([1,2])=AX1;
	ax([3,4])=AX2;
	ax([5,6])=AX3;
elseif nargin==2,
	ax([1,3,5])=AX1;
	ax([2,4,6])=AX2;
elseif nargin==1,
	if length(AX1)<6,
		error( 'STPAXIS: a single argument must have 6 elements');
	else
		ax=AX1(1:6);
	end;
else
	error( 'STPAXIS: takes 1,2,3 or 6 arguments of 6,3,2 or 1 elements each');
end;

h=get(gcf,'children');
h=flipud(h);
if length(h)==3,
	if ~isempty(ax(1)) & ~isempty(ax(2)),
		if ax(1)>ax(2), ax([2,1])=ax([1,2]); end;
		set(h(2),'xlim',[ax(1) ax(2)]); 
		set(h(3),'xlim',[ax(1) ax(2)]);
	end;
	if ~isempty(ax(3)) & ~isempty(ax(4)),
		if ax(3)>ax(4), ax([4,3])=ax([3,4]); end;
		set(h(1),'xlim',[ax(3) ax(4)]); 
		set(h(3),'ylim',[ax(3) ax(4)]);
	end;
	if ~isempty(ax(5)) & ~isempty(ax(6)),
		if ax(5)>ax(6), ax([6,5])=ax([5,6]); end;
		set(h(1),'ylim',[ax(5) ax(6)]); 
		set(h(2),'ylim',[ax(5) ax(6)]);
	end;
end;


return;
