function [ M, Q, O, E, N ] = xyboxp( X, Y, Nbin )
% XYBOXP -	draws x-y box whisker plot
%
% USAGE - 	[ M, Q, O, E, N ] = xyboxp( X, Y, Nbin )
%
% EXPLANATION -	M -
%		Q -
%		O -
%		E -
%		N -
%		X -
%		Y -
%		Nbin -
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1998-11-12
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

maxx = maxi(X);
minx = mini(X);
bin = (maxx-minx) ./Nbin;
XX = [0:Nbin].*bin+minx;
XX(length(XX))=maxx;
x=ave(XX');

M=[]; Q=[]; O=[]; E=[]; N=[];

for i=1:Nbin, 
	I=find( X>=XX(i) & X<=XX(i+1) );
	if ~isempty(I),
		[m,q,o,e,n]=boxplot(Y(I),0);
	else
		m=NaN;q=[NaN;NaN];o=[NaN;NaN];e=[NaN;NaN];N=0;
	end;
	M=[M;m]; Q=[Q;q']; O=[O;o']; E=[E;e']; N=[N;n];
	
end;


hold on;
plot(x,M); 
plot(x*ones(1,size(Q,2)),Q,'r');
%plot(x*ones(1,size(O,2)),O,'r');
plot(x*ones(1,size(E,2)),E,'x');
return;

