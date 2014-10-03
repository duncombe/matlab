function [DX]=blockmean(x,npts)
% BLOCKMEAN -	blockmean of a matrix
%
% USAGE -	[DX]=blockmean(x,npts)
%
%		x - 	matrix
%		npts - 	number of pts to take for mean
%		DX - 	npts-average, columnwise of x
%
%		Note - 	pads with NaNs and uses reshape and NaN insensitive 
%			mean function USEFUL/stats.m
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -	
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
%

[nx,mx]=size(x);
filler=nan.*ones(npts-rem(nx,npts),mx);
padx=[ x; filler ];
[n,m]=size(padx); 
dx=reshape(padx,npts,n./npts.*m);
Dx=stats(dx); 
DX=reshape(Dx,n./npts,m);
return;
		
