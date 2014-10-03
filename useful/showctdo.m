function [figs]=showctdo(stp,titlestr,cols,step,DefaultAxis)
% SHOWCTDO -	Plots S, T, O and P data on a sequence of six plots:
%		T/P, S/P, O/P S/O, T/O and T/S. Buttons are placed on a 
%		menuplot nearby to 
%		facilitate moving among the plots. Each plot has button to 
%		assist in finding the appropriate menuplot.
%
% USAGE -	[figs] = showctd( stpo, titlestr, cols, step)
%
%		figs - array of figure handles to the three figures dreated
%		stpo - CTDO data
%		titlestr - title to label the plot
%		cols - color
%		step - marker step
%
% SEE ALSO -	overctd
%


% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	CMDR 96-09-04
%
%
% PROG MODS -	1999-09-17 debug sort and table lookup causing interp1 to fail
%		1999-11-03 change axis settings
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

if ~exist('titlestr'), titlestr=''; end;
if ~exist('cols'), cols='r'; end;
if ~exist('step'), step=100; end;
if ~exist('DefaultAxis'), DefaultAxis=[33.5,36.5,-2,25,0,1000,0,9]; end;

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

SaltFig=figure; 
	plot(stp(:,1),stp(:,3),cols); 
	hold on;
	if ~isempty(pi),
		plot(stpm(:,1),stpm(:,3),[cols 'o']); 
	end;
	set(gca,'ydir','reverse'); 
	title([titlestr]);
	xlabel('Salinity');
	ylabel('Pressure');
	% eval(['axisinitial' num2str(SaltFig) '=axis;']);
	eval(['axisdefault' num2str(SaltFig) '=DefaultAxis([1 2 5 6]);']);
	zoom on;

TempFig=figure; 
	plot(stp(:,2),stp(:,3),cols); 
	hold on;
	if ~isempty(pi),
		plot(stpm(:,2),stpm(:,3),[cols 'o']); 
	end;
	set(gca,'ydir','reverse'); 
	title([titlestr]);
	xlabel('Temperature');
	ylabel('Pressure');
	% eval(['axisinitial' num2str(TempFig) '=axis;']);
	eval(['axisdefault' num2str(TempFig) '=DefaultAxis([3 4 5 6]);']);
	zoom on;

OxyFig=figure; 
	plot(stp(:,4),stp(:,3),cols); 
	hold on;
	if ~isempty(pi),
		plot(stpm(:,4),stpm(:,3),[cols 'o']); 
	end;
	set(gca,'ydir','reverse'); 
	title([titlestr]);
	xlabel('Oxygen');
	ylabel('Pressure');
	% eval(['axisinitial' num2str(OxyFig) '=axis;']);
	eval(['axisdefault' num2str(OxyFig) '=DefaultAxis([7 8 5 6]);']);
	zoom on;

TOFig=figure; 
	plot(stp(:,4),stp(:,2),cols); 
	hold on; 
	if ~isempty(pi),
		plot(stpm(:,4),stpm(:,2),[cols 'o']);
	end;
	title([titlestr]);
	xlabel('Oxygen');
	ylabel('Temperature');
	% eval(['axisinitial' num2str(TOFig) '=axis;']);
	eval(['axisdefault' num2str(TOFig) '=DefaultAxis([7 8 3 4]);']);
	zoom on;

SOFig=figure; 
	plot(stp(:,4),stp(:,1),cols); 
	hold on; 
	if ~isempty(pi),
		plot(stpm(:,4),stpm(:,1),[cols 'o']);
	end;
	title([titlestr]);
	xlabel('Oxygen');
	ylabel('Salinity');
	% eval(['axisinitial' num2str(SOFig) '=axis;']);
	eval(['axisdefault' num2str(SOFig) '=DefaultAxis([7 8 1 2]);']);
	zoom on;

TSFig=figure; 
	plot(stp(:,1),stp(:,2),cols); 
	hold on; 
	if ~isempty(pi),
		plot(stpm(:,1),stpm(:,2),[cols 'o']);
	end;
	title([titlestr]);
	xlabel('Salinity');
	ylabel('Temperature');
	% eval(['axisinitial' num2str(TSFig) '=axis;']);
	eval(['axisdefault' num2str(TSFig) '=DefaultAxis([1 2 3 4]);']);
	zoom on;

screensize=get(0,'screensize');
width=120;
buttonwidth=width;
buttonheight=30;
height=8.*buttonheight;

topleft=screensize(4)-50;

MenuFig=figure;
	set(MenuFig,'position',	[1,topleft,width,height],'menubar','none');
	set(gca,'visible','off');

button=7;

uicontrol(MenuFig,'string',titlestr,...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

button=button-1;

uicontrol(MenuFig,'string','Temp',...
	'callback',['figure(' num2str(TempFig) ')'],...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

button=button-1;

uicontrol(MenuFig,'string','Salt',...
	'callback',['figure(' num2str(SaltFig) ')'],...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

button=button-1;

uicontrol(MenuFig,'string','Oxygen',...
	'callback',['figure(' num2str(OxyFig) ')'],...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

button=button-1;

uicontrol(MenuFig,'string','TO',...
	'callback',['figure(' num2str(TOFig) ')'],...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

button=button-1;

uicontrol(MenuFig,'string','SO',...
	'callback',['figure(' num2str(SOFig) ')'],...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

button=button-1;

uicontrol(MenuFig,'string','TS',...
	'callback',['figure(' num2str(TSFig) ')'],...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

button=button-1;

uicontrol(MenuFig,'string','Finished',...
	'callback',['close([' 	num2str(TempFig) ',' ...
				num2str(SaltFig) ',' ...
				num2str(OxyFig) ',' ...
				num2str(TSFig) ',' ...
				num2str(TOFig) ',' ...
				num2str(SOFig) ',' ...
				num2str(MenuFig) '])'],...
	'Position',[0,button.*buttonheight,buttonwidth,buttonheight]...
	);

figs= [SaltFig,TempFig,TSFig,OxyFig,SOFig,TOFig];

for Fig=figs,
uicontrol(Fig,'string','Menu',...
	'callback',['figure(' num2str(MenuFig) ')'],...
	'Position',[0,0,90,20]...
	);
eval(['ad=axisdefault' num2str(Fig) ';']);
axiscommand=['axis([' sprintf('%g %g %g %g',ad) ']);'];
uicontrol(Fig,'string','AxDef',...
	'callback',axiscommand,...
	'Position',[0,20,45,20]...
	);
% eval(['ad=axisinitial' num2str(Fig) ';']);
% axiscommand=['axis([' sprintf('%g %g %g %g',ad) ']);'];
uicontrol(Fig,'string','AxIni',...
	'callback',['axis(''auto'')'],...
	'Position',[45,20,45,20]...
	);
end;

figs=[MenuFig, figs];

% uicontrol(TempFig,'string','Menu',...
% 	'callback',['figure(' num2str(MenuFig) ')'],...
% 	'Position',[0,0,50,20]...
% 	);
% 
% uicontrol(TSFig,'string','Menu',...
% 	'callback',['figure(' num2str(MenuFig) ')'],...
% 	'Position',[0,0,50,20]...
% 	);
% 
% buttons(SaltFig, 'Temp', TempFig, 'TS', TSFig);
% buttons(TempFig, 'Salt', SaltFig, 'TS', TSFig);
% buttons(TSFig, 'Temp', TempFig, 'Salt', SaltFig);


return;
