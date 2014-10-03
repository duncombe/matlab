function [h0,h1]=ecolorbar(D,L,label,W,hand) 
% ECOLORBAR     colorbar with discrete color axis
% To be used with CONTOURF-plot. 
% 
% When contours (V) are given, the colorlimit ('Clim') property of
% _both_ the plot and the colorbar is locked to the lower and upper
% contourlevel.  This should solve the problem of how to keep the same
% color-to-data relationship from plot to plot. 
%
% As a general rule, place the colorbar on a side of the graph that has
% no ticklabels or title (right is this function's default).
%
% [h0,h1]=ecolorbar(D,L,label,W,hand)
%
% D  = a) The contour-specification vector used when making the 
%         CONTOURF-plot (the most robust method), 
%   or b) The data-matrix of the CONTOURF-plot 
%         (use when no contour-spec is given).
% 
% L     = String giving location of colorbar:
%		't'op
%		'b'ottom
%		'r'ight		(default)
%		'l'eft
%		'o'utside	(when rescaling of graph is 
%				 undesireable)
%		'a'lone		(in a subplot when it refers to several
%				 graphs in a subplot-figure)
%
% label = string for the color-axis-label               (default= empty)
%
% W     = Relative width (ratio of graph width/height)  (default= 1/30)
% 
% hand  = handles to axes which the colorbar refers to. Use this to
%	  ensure the right colorspan on all graphs and their colorbar.
%
% [h0,h1] are handles to the graph (h0) and to the colorbar (h1)
%
% NOTE1 : There is no opportunity to give single valued contourspecification
%         (the number of contours). I haven't gotten so far as to make that
%         robust, but then a well contemplated contourplot should always
%         have specified contourlevels. 
%
% NOTE2 : CONTOURF scales CAXIS from the lowest input contourlevel to the
%         highest given contourlevel or max(max(data)) whichever is
%         greatest!!! :-(
%         ECOLORBAR locks the coloraxis of both plot and colorbar between
%         the first and last contourlevel, to ensure consistency. When
%         several axes 'share' same colorbar, the 'clim' property of all
%         axes should be set equal to the colorbar, by input of their
%         handles in 'hand'! 
%
% Example 1: Difference from the ordinary colorbar-function:
%-------------------------------------------------------------------------
% [x,y,z]=peaks; v=-10:2:8; 
% figure(1); clf; [cs,h]=contourf(x,y,z,v); clabel(cs,h); colorbar
% figure(2); clf; [cs,h]=contourf(x,y,z,v); clabel(cs,h); ecolorbar(v);
% And not using contourspecification:
% figure(3); clf; [cs,h]=contourf(x,y,z); clabel(cs,h); ecolorbar(z);
%
% Example 2: Not equidistant contours.
%-------------------------------------------------------------------------
% figure(4); clf; v=[-8 -4 -2 -1 0 1 2 4 8]; 
% [cs,h]=contourf(x,y,z,v); clabel(cs,h); ecolorbar(v);
%
% See also CONTOURF LEVELS

% ### Updates: ###
% 00.10.17: Added options for "outside"- and "alone"-positioning 
% 99.11.19: I think I found the solution for the color-span problem.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modified from my_colorbar by Tore Furevik, Geophysical Institute,
% University of Bergen. 
% ECOLORBAR by Jan Even Nilsen:
%Time-stamp:<Last updated on 01/01/30 at 12:04:59 by even@gfi.uib.no>
%File:<d:/home/matlab/ecolorbar.m>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%CREATED -	
% this version obtained from Tom Farrar
% about October 8, 2010.
%
%	$Revision: 1.5 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: ecolorbar.m,v 1.5 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%   2011-02-18 
% 	Seems that ismatrix first appears in Matlab 2010b.
% 	Working with older versions of matlab, so this function
% 	crashes. Put in a fix.
%
%
%
error(nargchk(1,5,nargin));
if nargin < 5 | isempty(hand)
  hand=[];
end
if nargin < 4 | isempty(W)
  W=1/30;
end
if nargin < 3 | isempty(label) | ~ischar(label) 
  label='';
end
if nargin < 2 | isempty(L)
  L='r';
end  

outside=0; findstr(L,'o');  % check for "outside"
if ans, outside=1; L=L(find([1:length(L)]~=ans)); 
	if isempty(L), L='r'; end
end
alone=0; findstr(L,'a');    % check for "alone"
if ans, alone=1;   L=L(find([1:length(L)]~=ans)); 
	if isempty(L), L='r'; end
end

% if exist('ismatrix') ~= 5, 
% 	ismatrix=@(V)(all(size(V)>=0)&length(size(V))==2); 
% end;

% What D is input...
if isvector(D)     % D is a vector and therefore a contour specification
  V=D;
elseif ismatrix(D) % D is datafield and V is empty
  V=[];        
else
  error('D must be a matrix (the datafield of the plot) or a vector (contours)!');
end             

% make data matrix for colorbar:
if isempty(V)              % using the data (range)
  [x,VC]=meshgrid(1:2,minmax(D));
else
  [x,VC]=meshgrid(1:2,V);  % using the given contour-range 
end         
                         
% h0 = handle to the graph's axes ; h1 = handle to the colorbar's axes
h0=gca; a=get(h0,'position');
if alone, set(h0,'visible','off'); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch L
case 't'  
 W=W*a(4);
 % placement of the colorbar:
 if findstr(get(h0,'XAxisLocation'),'top'),os=2*W; else os=W; end 
 if outside
   h1=axes('position',[a(1) a(2)+a(4)+os  a(3) W]);
 else
   set(h0,'position',[a(1) a(2) a(3) a(4)-W-os]);
   h1=axes('position',[a(1) a(2)+a(4)-W  a(3) W]);
 end
 % plotting the colorbar:
 if isempty(V), [c,h]=contourf(VC',x',VC');
 else           [c,h]=contourf(VC',x',VC',V); 
 end
 set(h1,'XAxisLocation','top','YTick',[]);
 % drawing the colorbars tickmarks:
 if isempty(V)
   lev=levels(c); tick=maketick([lev VC(2)]); % Choose ticks
   % Choose datapoints on which to put the ends of the colorbar:
   % one increment outside the contourlevel-range,
   % on the ends of the coloraxis,
   % or as it is from contourf making the bar
   % (as tight as possible)
   levl=length(lev);dlev=[lev(2)-lev(1) lev(levl)-lev(levl-1)];
   cax=caxis;
   olim=get(h1,'Xlim');
   grenser=[max([cax(1) olim(1) lev(1)-dlev(1)]) min([olim(2) lev(levl)+dlev(2)])]; 
   tick=tick(find(tick>grenser(1)));
 else   % just use the contour specification
   tick=maketick(V);
   grenser=[min(V) max(V)];
 end
 set(h1,'XTick',tick,'Xlim',grenser); 
 xlabel(label)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'b'     
 W=W*a(4);
 % placement of the colorbar:
 if findstr(get(h0,'XAxisLocation'),'bottom'),os=W*2; else os=W; end 
 if outside
   h1=axes('position',[a(1) a(2)-os-W a(3) W]);
 else
   set(h0,'position',[a(1) a(2)+os+W a(3) a(4)-os-W]); 
   h1=axes('position',[a(1) a(2) a(3) W]);
 end
 % plotting the colorbar:
 if isempty(V), [c,h]=contourf(VC',x',VC');
 else           [c,h]=contourf(VC',x',VC',V);
 end
 set(h1,'YTick',[]);
 % drawing the colorbars tickmarks:
 if isempty(V)
   lev=levels(c); tick=maketick([lev VC(2)]);
   % Choose ticks
   % Choose datapoints on which to put the ends of the colorbar:
   levl=length(lev);dlev=[lev(2)-lev(1) lev(levl)-lev(levl-1)];
   cax=caxis;
   olim=get(h1,'Xlim');
   grenser=[max([cax(1) olim(1) lev(1)-dlev(1)]) min([olim(2) lev(levl)+dlev(2)])];
   tick=tick(find(tick>grenser(1)));
 else   % just use the contour specification
   tick=maketick(V);
   grenser=[min(V) max(V)];
 end
 set(h1,'XTick',tick,'Xlim',grenser);
 xlabel(label)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'r'  %default
 W=W*a(3);
 % placement of the colorbar:
 if findstr(get(h0,'YAxisLocation'),'right'),os=W*2; else os=W; end 
 if outside
   h1=axes('position',[a(1)+a(3)+os a(2) W a(4)]);
 else
   set(h0,'position',[a(1) a(2) a(3)-os-W a(4)]);
   h1=axes('position',[a(1)+a(3)-W a(2) W a(4)]);
 end
 % plotting the colorbar:
 if isempty(V), [c,h]=contourf(x,VC,VC);
 else           [c,h]=contourf(x,VC,VC,V);
 end
 set(h1,'YAxisLocation','right','XTick',[]);
 % drawing the colorbars tickmarks:
 if isempty(V)
   lev=levels(c);tick=maketick([lev VC(2)]); % Choose ticks
   % Choose datapoints on which to put the ends of the colorbar:
   levl=length(lev);dlev=[lev(2)-lev(1) lev(levl)-lev(levl-1)];
   cax=caxis;
   olim=get(h1,'Ylim');
   grenser=[max([cax(1) olim(1) lev(1)-dlev(1)]) min([olim(2) lev(levl)+dlev(2)])];
   tick=tick(find(tick>grenser(1))); 
 else   % just use the contour specification
   tick=maketick(V);
   grenser=[min(V) max(V)];
 end
 set(h1,'YTick',tick,'Ylim',grenser);
 ylabel(label)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'l'   
 W=W*a(3);
 % placement of the colorbar:
 if findstr(get(h0,'YAxisLocation'),'left'),os=W*2; else os=W; end 
 if outside
   h1=axes('position',[a(1) a(2)-os-W W a(4)]);
 else
   set(h0,'position',[a(1)+os+W a(2) a(3)-os-W a(4)]);
   h1=axes('position',[a(1) a(2) W a(4)]);
 end
 % plotting the colorbar:
 if isempty(V) [c,h]=contourf(x,VC,VC);
 else          [c,h]=contourf(x,VC,VC,V);
 end
 set(h1,'XTick',[]);
 % drawing the colorbars tickmarks:
 if isempty(V)
   lev=levels(c); tick=maketick([lev VC(2)]); % Choose ticks
   % Choose datapoints on which to put the ends of the colorbar:
   levl=length(lev);dlev=[lev(2)-lev(1) lev(levl)-lev(levl-1)];
   cax=caxis;
   olim=get(h1,'Ylim');
   grenser=[max([cax(1) olim(1) lev(1)-dlev(1)]) min([olim(2) lev(levl)+dlev(2)])];
   tick=tick(find(tick>grenser(1)));
 else   % just use the contour specification
   tick=maketick(V);
   grenser=[min(V) max(V)];
 end
 set(h1,'YTick',tick,'Ylim',grenser);
 ylabel(label)
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set current axis pointer back on the graph:
axes(h0);
% lock the coloraxis onto the colorbar in both plot and bar:
hand=hand(:)';
set([h0 h1 hand],'clim',grenser);


%-------------------------------------------------------------
function tick=maketick(lev)
% make the number of ticklabels be less than 10
tick=lev;
while length(tick)>10
  tick=tick(1:2:length(tick));
end

% no tick on the edges of colorbar
%if max(tick)==max(lev)
%  tick=tick(1:length(tick)-1);
%end







