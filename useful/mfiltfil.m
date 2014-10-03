function [Y]=mfiltfilt(B,A,X)
% MFILTFILT -	filtfilt for matrices, applies same filter to all columns
%
% USAGE - 	[Y]=mfiltfilt(B,A,X)
%
% DEPENDS -	depends on filtfilt in the signal toolbox
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
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
% 
%
[n,m]=size(X);
Y=X;		% pre-allocate space for the result - program runs quicker
for ii=1:m,
	Y(:,ii)=filtfilt(B,A,X(:,ii));
end;
return;
		

