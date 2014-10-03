function H=annotate(CORNER,TEXT)
%ANNOTATE - 	Annotates a plot 
%
%USAGE - 	H=annotate(CORNER,TEXT)
%		H - handles to the text
%		CORNER - text string indicating 'topleft', 'bottomright' etc
%		TEXT - the annotation. Either a string in which lines may be
%			separated by a carriage return [10], or a string
%			matrix (see STR2MAT).
%



% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	2000-05-08
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

A=axis;

dx=(A(2)-A(1))./20;
dy=(A(4)-A(3))./25;

% Compose the annotation

if min(size(TEXT))==1,
	T=TEXT; 
	[t,T]=strtok(T,10);
	TEXT=t;
	[t,T]=strtok(T,10);
	while ~isempty(t),  TEXT=str2mat(TEXT,t); [t,T]=strtok(T,10); end;
end;

% Setup the position and spacing

ValidCorner=1;
CORNER=lower(CORNER);

if strcmp(CORNER,'topright'),
% print the text in the top right of the figure
	HA='right'; dy=-dy; dx=-dx; X=A(2); Y=A(4);
elseif strcmp(CORNER,'topleft'),
% print the text in the top left of the figure
	HA='left'; dy=-dy; X=A(1); Y=A(4);
elseif strcmp(CORNER,'middleleft'),
% print the text in the centre left of the figure
	HA='left'; X=A(1); Y=(A(3)+A(4))./2;
elseif strcmp(CORNER,'middleright'),
% print the text in the centre right of the figure
	HA='right'; X=A(2); dx=-dx; Y=(A(3)+A(4))./2;
elseif strcmp(CORNER,'bottomright'),
% print the text in the bottom right of the figure
	HA='right'; dx=-dx; X=A(2); Y=A(3);
	TEXT=flipud(TEXT);
elseif strcmp(CORNER,'bottomleft'),
% print the text in the bottom left of the figure
	HA='left'; X=A(1); Y=A(3);
	TEXT=flipud(TEXT);
else
	disp([	'Corner not clearly defined.' 10 ...
		'Options are: topright, topleft, bottomright, bottomleft']);
	ValidCorner=0;
end;

% Output to the plot

if ValidCorner,
	X=X+dx;
%	[T,TEXT]=strtok(TEXT,10);
%	while ~isempty(T),
	H=[];
	for i=1:size(TEXT,1),
		Y=Y+dy;
		h=text(X,Y,TEXT(i,:)); set(h,'horizontalalignment',HA);
		H=[H,h];
%		[T,TEXT]=strtok(TEXT,10);
	end;
end;
return;

