function [y]=vectint(x,px,py)
% VECTINT -	interpolates to x between two (complex) vectors
%

% PROGRAM - 	MATLAB code by someone (could be me, but I don't 
%		recognise it!?!)
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

[n,m]=size(px);
px1=px(:,1:m-1); px2=px(:,2:m);
py1=py(:,1:m-1); py2=py(:,2:m);

condn=~(( (px1>x) & (px2>x) ) | ( (px1<x) & (px2<x) ));
II=find(condn==0);condn(II)=nan*II;

inter=(py2-py1)./(px2-px1).*(x-px1) + py1; 
y=condn.*inter;

return;


