function dirstack=pushd(dr)
% PUSHD -	push working directory
%
% I can't get this to work! 
% A function won't globally change the working directory and a script
% won't take an argument.
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
global DIRSTACK
if ~exist('DIRSTACK'), DIRSTACK=[]; end;
if isempty(DIRSTACK), DIRSTACK=str2mat(pwd,DIRSTACK); end;
if ~exist('dr'),
	DIRSTACK(1:2,:)=DIRSTACK(2:1,:);
else
	if strcmp(dr(1),'+'),
		i=str2num(dr(2:length(dr)));
		DIRSTACK([1,i],:)=DIRSTACK([i,1],:);
	else
		DIRSTACK=str2mat(dr,DIRSTACK);
	end;
end;
disp(deblank(DIRSTACK(1,:)));
pwd
return;
%

 
