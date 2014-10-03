function overctdo(figs,stp,cols,step)
% OVERCTDO -	Overplots a sequence of SP, TP and TS plots:
%
% USAGE -	overctdo(figs,stp,cols)
%
%		figs - array of figure handles
%			[Menufig,SaltFig,TempFig,TSFig,OxyFig,SOFig,TOFig] 
%			to the figures as output by showctdo
%		stp - CTD data
%		cols - color 
%
% SEE ALSO -	showctd, displays
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	CMDR 96-09-04
%
% PROG MODS -	1999-11-02 debug sort and table lookup causing interp1 to fail
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

MenuFig=figs(1);
SaltFig=figs(2);
TempFig=figs(3);
TSFig=figs(4);
OxyFig=figs(5);
SOFig=figs(6);
TOFig=figs(7);

if ~exist( 'cols'), cols='r'; end;
if ~exist('step'), step=100; end;

X1=min(stp(:,3));
X2=max(stp(:,3));
pi = [ceil(X1./step).*step:step:X2]';
[junk,I]=sort(stp(:,3));
x=stp(I,:);
J=find(diff(junk)<=0);
if ~isempty(J),
        disp('CTD data unordered');
        x(J,:)=[];
end;

if ~isempty(pi),
	stpm = pi*ones(1,size(stp,2));
	for i = [1:2,4],
        	stpm(:,i) = interp1( x(:,3), x(:,i), pi);
	end;
end;
clear x;

figure(SaltFig); 
	plot(stp(:,1),stp(:,3),cols); 
	if ~isempty(pi),
		plot(stpm(:,1),stpm(:,3),[cols 'o']); 
	end;
	zoom on;

figure(TempFig); 
	plot(stp(:,2),stp(:,3),cols); 
	if ~isempty(pi),
		plot(stpm(:,2),stpm(:,3),[cols 'o']); 
	end;
	zoom on;

figure(OxyFig); 
	plot(stp(:,4),stp(:,3),cols); 
	if ~isempty(pi),
		plot(stpm(:,4),stpm(:,3),[cols 'o']); 
	end;
	zoom on;

figure(TOFig); 
	plot(stp(:,4),stp(:,2),cols); 
	if ~isempty(pi),
		plot(stpm(:,4),stpm(:,2),[cols 'o']);
	end;
	zoom on;

figure(SOFig); 
	plot(stp(:,4),stp(:,1),cols); 
	if ~isempty(pi),
		plot(stpm(:,4),stpm(:,1),[cols 'o']);
	end;
	zoom on;

figure(TSFig); 
	plot(stp(:,1),stp(:,2),cols); 
	if ~isempty(pi),
		plot(stpm(:,1),stpm(:,2),[cols 'o']);
	end;
	zoom on;

figure(MenuFig);

return;
