function [Y,I]=maxi(X)
%MAXI -	NaN-tolerant maximum 
% 	Matlab's max function is now NaN-aware, and use of maxi is 
% 	deprecated (aside from the fact that it was not
% 	vectorized and used a loop).  
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
% 
%CREATED: ????
%
%PROG MODS -	
%   2010/12/22 
% 	Function use is deprecated
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
% 

[n,m]=size(X);
if (n==1) | (m==1), 
	NX=find(~isnan(X));
	[Y,YI]=max(X(NX));
	I=NX(YI);
else,
	for ii=1:m,
		NX=find(~isnan(X(:,ii)));
		[Y(ii),YI]=max(X(NX,ii));
		I(ii)=NX(YI);
	end;
end;

return;

