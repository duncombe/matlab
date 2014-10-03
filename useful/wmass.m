function [Member,DEV, LMember]=wmass(W,WT)
%WMASS - 	checks whether water type fits into defined water mass
% 
%USAGE -	wmass=(W,WT)
%
%EXPLANATION -	W columns of [S,T,P,O,dens]
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003/09/01
%
%PROG MODS -	
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

% Require water type to be in a particular format. Make it so.
% S T R O
Extreme=[0,40;-2,40;0,100;0,15];


for i=1:5,
        if isnan(WT(i,1)), WT(i,1)=Extreme(i,1); end;
        if isnan(WT(i,2)), WT(i,2)=Extreme(i,2); end;
        if WT(i,1)<WT(i,2),
                junk=WT(i,1); WT(i,1)=WT(i,2);WT(i,2)=junk;
        end; %if
end; % for 

% Test the water

Member=ones(size(W,1),1);
LMember=ones(size(W,1),5);
col=[1,2,5,4];
for i=1:4,
        %if ~isnan(W(i)), Member = Member & W(i)<=WT(i,1) & W(i)>=WT(i,2) ; end;
	if ~any(isnan(W(:,col(i)))),
		Member = Member & W(:,col(i))<=WT(i,1) & W(:,col(i))>=WT(i,2);
		LMember(:,i) = W(:,col(i))<=WT(i,1) & W(:,col(i))>=WT(i,2);
	end;
end;

% If the water mass definition is a line:

S=WT(6:size(WT,1),1);
T=WT(6:size(WT,1),2);

DEV=NaN;
if ~isempty(S),
	if ~(any(isnan(S)) | any(isnan(T))),
        M=(T(2)-T(1))./(S(2)-S(1)); C=T(2)-S(2).*M;
        DEV=W(:,2)-W(:,1).*M-C;
	Member=Member & DEV<=WT(5,1) & DEV>=WT(5,2);
	LMember(:,5)=DEV<=WT(5,1) & DEV>=WT(5,2);
	end;
end;    

return;

