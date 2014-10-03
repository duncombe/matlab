function STP=presfilt(stp,Int)
% PRESFILT -	Removes pressure reversals from CTD cast data,
%		interpolates to standard interval (default 1db)
% 		using interp1
%
% USAGE -	STP=presfilt(stp,Int)
%
% EXPLANATION -	STP - filtered stp data
%		stp - raw [salt,temp,pres, ... ] data
%		Int - interval to reduce data to [no interpolation]
%		if Int == 'mean', then the mean interval is used
%		if Int == 'max', then maximum interval is used
% 
% SEE ALSO -	spline, interp1
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1998-10-25
%
% PROG MODS -	2000-03-24: Add test for Int=='max'. Fix indexing.
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

% Condition of Int is checked later, when a ecision id made about the interval

[N,M]=size(stp);
m=stp(1,3);	% start with first pressure reading
% I=[];		% initialize index 
I=1;		% initialize index 

for i=1:N,
	if stp(i,3)>m, 
		m=stp(i,3); 
		I=[I;i]; 
	end; 
end;

Stp=stp(I,:);

if ~exist('Int'), Int=[]; end;
if isstr(Int),
	if strcmp(Int,'mean'), 
		Int=mean(diff(Stp(:,3)));
	elseif strcmp(Int,'max'),
		Int=max(diff(Stp(:,3))); 
	else
		Int=[];
	end; 
end;


if ~isempty(Int),
	STP(:,3)=[ceil(min(Stp(:,3))):Int:max(Stp(:,3))]';
	if M>3, cols=[1,2,4:M]; else cols=[1,2]; end;
	for i=cols, STP(:,i)=interp1(Stp(:,3),Stp(:,i),STP(:,3)); end;
else
	STP=Stp;
end;


return;

