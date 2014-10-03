function sagapic(flag)
% SAGAPIC Pictures illustrationg SAGA Toolbox.
%	SAGAPIC(NAME)  creates pictures illustrating
%	various programs and algorithms in the 
%	SAGA Toolbox.
%
%	      NAME can be one of the following strings:
%	knots    - "knots collection",
%	map      - topographic map,
%	polybool - Boolean operations with polygons,
%	ched     - convex hull of "equilibrium points on 
%	           a sphere,
%	chrs     - convex hull of random points on a sphere,
%	add2ch   - adding a point to a convex hull,
%	mebius   - Mebius strip,
%	delaunay - relation between the Delaunay triangu-
%	           lation and a convex hull on a sphere,
%	voronoi  - planar Voronoi diagram
%	triang   - triangulated plane with TRIANG command,
%	dlncirc  - 2-d Delaunay triangulation and
%	           circles through each triangles,
%	membrane - MATLAB logo as a triangulated
%	           surface,
%	interp   - interpolation from irregular data using
%	           triangulation method,
%	fillmiss - restoration of missing values in a matrix,
%	quadtree - adaptive division with QUADTREE,
%	objmap   - objective mapping interpolation.
%	inpolyhd - points in/out of 3-d polyhedron.
%
%	Example:
%	>> sagapic mebius
%
%	Abbreviations such as SAGAPIC TRI are allowed.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/18/95

if nargin==0, help sagapic, return, end
if ~isstr(flag)
  error(' NAME must be a string variable')
end

% ================= KNOTS ==============================
% === "Knots" collection (periodic tubes) ==============
name = 'knots';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))

  % Axes positions .....................
  sza = [.5 .5];
  apos = [.0 .5; .51 .5; 0 .01; .51 .01]; 
 
  % Create KNOTS surfaces ..............
  for jj=1:4
    ax(jj) = subplot(2,2,jj);
    set(ax(jj),'pos',[apos(jj,:) sza])
    num = jj+2;
    s(jj) = knots(num,[],.12);
    str = ['knots(' num2str(num) ')'];
    t(jj) = text(0.35+jj*.1,-.75,str);
    set(t(jj),'fontsize',14)
    axis equal, axis square,axis off
  end
 
  % Coloring ...........................
  set(s,'edgecolor','r')
  colormap pink
 
  % Global title .......................
  ag = axes('pos',[0 0 1 1]);
  tt = text(.3,.95,'KNOTS  Collection');
  set(tt,'fontsize',22)
  axis off

  set(gcf,'color',[.2 .2 .5])
return, end


% ================== MAP ===============================
% === Topographic map filled with CONTOURF command
name = 'map';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))

  load topo
  contourf(topo,[-1000 -500 0 500 1000])
  clr = hsv(64);
  clr = clr([44 40 36 22 9 4],:);
  colormap(clr)
  title('Topographic map filled with CONTOURF')
  set(get(gca,'title'),'fontsize',16)

  set(gcf,'color',[.2 .2 .4])
return, end


% ================== POLYBOOL ==========================
% === Boolean operations on polygons
name = 'polybool';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg

  % Intersections of 3 simple polygons: rectangle,
  % triangle, ellipse ..................................
  ax1 = subplot(2,2,1);
  [x1,y1] = ellipse(.85,.2,pi/2.8,.4,.3);
  x2 = [0 1 1 0]; y2 = [0 0 1 1];
  x3 = [.1 .95 .45]; y3 = [-.1 -.1 1.3];
  % Now calculate intersections themselves:
  [x12,y12] = polyints(x1,y1,x2,y2);      % P1 & P2
  [x13,y13] = polyints(x1,y1,x3,y3);      % P1 & P3
  [x23,y23] = polyints(x2,y2,x3,y3);      % P2 & P3
  [x123,y123] = polyints(x12,y12,x3,y3);  % P1 & P2 & P3
  p = fill(x1,y1,'r',x2,y2,'g',x3,y3,'b'); hold on
  pp = fill(x12,y12,'y',x13,y13,'m',x23,y23,'c',x123,y123,'w'); 
  hold off, axis off
  text(.4,-.2,'simple intersections')
  drawnow

  % XOR of 2 "arcs" ....................................
  ax2 = subplot(2,2,2);
  a = 1.5;
  [x1,y1] = ellipse(.2,1);
  x1 = x1-a*y1.^2;
  x2 = -x1-.55; y2 = y1+.13;
  [x12,y12] = polyxor(x1,y1,x2,y2);
  p = fill(x1,y1,'r',x2,y2,'g'); hold on
  px = polyplot(x12,y12,'fill','y'); hold off
  axis off
  text(-.3,-.8,'XOR')
  drawnow


  % Multiple intersections of non-convex polygons ......
  % First polygon ..........
  th = linspace(0,2*pi,176);
  rad = 1+.8*cos(9*th);
  x1 = rad.*cos(th);
  y1 = rad.*sin(th);

  % Second polygon .........
  th = linspace(0,2*pi,111);
  rad = 1+.9*cos(6*th);
  x2 = rad.*cos(th)+.75;
  y2 = rad.*sin(th)+.32;

  [xi,yi] = polyints(x1,y1,x2,y2); % Intersection
  ax3 = subplot(2,2,3);
  fill(x1,y1,'r',x2,y2,'g'), hold on
  polyplot(xi,yi,'fill','y'); % Call POLYPLOT command
  axis off
  text(.5,-1.5,'intersection')
  drawnow

  x2 = x2+.41; y2 = y2-.68;
  [xu,yu] = polyuni(x1,y1,x2,y2); % Union
  ax4 = subplot(2,2,4);
  fill(x1,y1,'r',x2,y2,'g')
  polyplot(xu,yu,'fill','y'); % Call POLYPLOT command
  axis off
  text(-.75,-1.8,'union')

  set(ax1,'pos',[-.08 .49 .45 .5])
  set(ax2,'pos',[.48 .5 .5 .5])
  set(ax3,'pos',[-.02 -.02 .52 .54])
  set(ax4,'pos',[.49 -.06 .56 .6])

  % Global title
  a = axes('pos',[0 0 1 1]); axis off
  t = text(.5,.96,'Boolean operations with polygons');
  set(t,'horizontal','center','fontsize',18)

  set(gcf,'color',[.2 .2 .5])
return, end



% =================== CHED =============================
% === Convex hull of "equilibrium points" on a sphere
name = 'ched';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  n = 60;
  R = eqdsph(n);    % Constructing "equilibrium points

  N = convexh(R);
  p = surftri(N,R,[-30,50])

  caxis([-1.5 1.5])
  axis square, axis off
  set(gca,'pos',[-.1 -.1 1.2 1.2])

  % Labels
  a=axes('pos',[0 0 1 1]);
  str = ['Convex hull of ' num2str(n) ...
         ' "equlibrium points" on a sphere'];
  t1 = text(.18,.95,str);
  set(t1,'fontsize',16)
  t2 = text(.1,.05,'Used routines: EQDSPH, CONVEXH');
  axis off

  set(gcf,'color',[.2 .2 .4])
return, end


% ==================== CHRS ============================
% === Convex hull of "random uniform" points on a sphere
name = 'chrs';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  n = 100;
  R = randsph(n);
  N = convexh(R); % "Uniform random" points on a sphere
  p = surftri(N,R,[80,-60])  % Patchwork

  % Set axes ..................
  colormap cool
  axis square  axis off
  set(gca,'pos',[-.1 -.1 1.2 1.2])

  % Make a title ..............
  a=axes('pos',[0 0 1 1]);
  str = ['Convex hull of ' num2str(n)...
        ' "random uniform" points on a sphere'];
  t1=text(.15,.95,str)
  set(t1,'fontsize',16)
  t2 = text(.1,.05,'Used routines: RANDSPH, CONVEXH');
  axis off

  set(gcf,'color',[.2 .2 .4])
return, end


% ================== ADD2CH ============================
% === Adding point to a 3-d convex hull:
% === Illustration of convex hull algorithm
name = 'add2ch';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  np = 40;
  R = rand(np,3);
  R(np,:) = [.5 .5 1.5];    % External point
  N = convexh(R(1:np-1,:)); % Convex hull of n-1 points

  clg, p = surftri(N,R);

  % Calculate new facets (call ADDPT2CH command)
  [Nn,mi] = addpt2ch(R,N,np);
  n_old = sum(mi);
  n_new = size(Nn,1);
  % Plot 3-d faceted surface
  pn = surftri(Nn(n_old+1:n_new,:),R,'w','none');
  set(pn,'linewidth',3)

  colormap pink
  hold on
  rn = R(np,:);
  plot3(rn(1),rn(2),rn(3),'*');
  text(rn(1),rn(2),rn(3)+.05,'New point')
  hold off

  axis square, axis equal, axis off
  set(gca,'pos',[-.1 -.15 1.2 1.3])

  at = axes('pos',[0 0 1 1]);
  tt = text(.2,.95,'Construction of a 3-d convex hull');
  set(tt,'fontsize',20)
  axis off

  set(gcf,'color',[.2 .2 .4])
  return
end


% ============= MEBIUS =================================
% === "Mebius strip" surface with MEBIUS routine
name = 'mebius';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg
  s = mebius;
  view(-165,60)
  colormap hot,brighten(.6)

  axis square, axis equal, axis off
  set(gca,'pos',[-.1 -.15 1.2 1.3])

  at = axes('pos',[0 0 1 1]);
  tt1 = text(.5,.95,'Mebius  strip');
  set(tt1,'fontsize',25,'fontweight','bold')
  set(tt1,'horizontal','center')
  tt2 = text(.05,.03,'Created with  MEBIUS  and  TUBE  programs');
  axis off
  set(gcf,'color',[.25 .25 .5])

  return
end


% ======= DELAUNAY =====================================
% === Relation between Delanay triangulation and 
% === a convex hull on a higher-dimensional sphere
name = 'delaunay';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg
  np = 40;
  x=rand(np,1); y=rand(np,1);
  R = mapsph([x y],-1);
  p1 = triangul(x,y,2);

  [D,Nrm] = convexh(R);
  s = find(Nrm(:,3)<=0);
  D(s,:) = [];
  R = R*.7;
  p2 = surftri(D,R,20*(R-min(min(R))));
  view(-45,25)
  axis square, axis equal, axis off
  set(gca,'pos',[-.2 -.15 1.5 1.3])

  % Title
  at = axes('pos',[0 0 1 1]);
  t(1) = text(.5,.95,'Planar Delaunay triangulation');
  t(2) = text(.5,.88,'as a convex hull on 3-d sphere');
  set(t,'fontsize',16,'horizontal','center')
  axis off

  set(gcf,'color',[.25 .25 .6])
return, end


% ============ VORONOI =================================
% === Planar Voronoi diagram ===========================
name = 'voronoi';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg
  np = 15;
  clp = 'c';
  cld = 'y';
  lwv = 3;

  x = rand(1,np); y = rand(1,np);
  [xc,yc,S,Nt,lv] = voronoi2(x,y,1); % Call VORONOI2
  set(lv,'linewidth',3)
  ii = find(all(Nt<=np));
  p = surftri(Nt(:,ii),x,y);
  set(p,'edgecolor',cld,'facecolor','none')
  set(p,'linewidth',2)
  lp = line('xdata',x,'ydata',y);
  set(lp,'linestyle','.','marker',18,'color',clp)
  axis([-.1 1.1 -.1 1.1])
  set(gca,'pos',[.02 .0 .85 .9])
  title('Planar Voronoi diagram')
  set(get(gca,'title'),'fontsize',16,'fontwe','bold')
  axis off

  al = legend('w','Voronoi polygons',...
       cld,'Delaunay triangles')
  set(al,'color',[.2 .2 .5])

  set(gcf,'color',[.25 .25 .4])
return, end


% ============ TRIANG ==================================
% === Planar Delaunay triangulation with TRIANGUL 
name = 'triang';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg
  np = 200;
  x=randn(1,np); y = randn(1,np);
  N = triangul(x,y,1);
  set(gca,'pos',[0.02 -.05 .96 .98])
  axis square,axis off

  at = axes('pos',[0 0 1 1]);
  t1 = text(.5,.96,'Delaunay triangulation of a planar set')
  set(t1,'horizontal','center','fontsize',16)
  t2 = text(.5,.91,'with TRIANGUL function');
  set(t2,'horizontal','center','fontsize',16)
  axis off

  set(gcf,'color',[.25 .25 .6])
return, end


% ============ DLNCIRC =================================
% === Illustration of empty circumference property of
% === Delaunay triangulation 
name = 'dlncirc';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg
  n = 10;
  x = rand(n,1); y = rand(n,1);
 
  N = triangul(x,y,1);
  [c,r] = circmsph([x y],N);
 
  % Plot circles trough each triangle
  circle(r,c(:,1),c(:,2))  % Call CIRCLE
  axis equal, axis square  % Make proportions right

return, end 



% ======= MEMBRANE =====================================
% === Triangulated "patchwork" membrane surface -
% === illustration of SURFTRI command
name = 'membrane';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg
  np = 500;
  M=membrane;
  sz = size(M);
  [xg,yg] = meshgrid(1:sz(2),1:sz(1));
  x = rand(1,np)*sz(2); y=rand(1,np)*sz(1);
  z = interp2(xg,yg,M,x,y);
  p = surftri(x,y,z);                 % Call SURFTRI
  set(gca,'pos',[-.15 -.08 1.25 1.25])
  axis off

  at = axes('pos',[0 0 1 1]);
  t1 = text(.5,.96,'MATLAB  Logo  in a "triangular"  form')
  set(t1,'horizontal','center','fontsize',18)
  t2 = text(.5,.89,'used SURFTRI (and TRIANGUL) functions');
  set(t2,'horizontal','center','fontsize',14)
  axis off

  set(gcf,'color',[.2 .2 .55])
  axis off
return, end


% ========== INTERP ====================================
% === Interpolation by triangulation method (INTERPTR)
name = 'interp';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg
  set(gcf,'pos',[15 350 580 520])
  np = 60;
  axpos = [-.18 .4 .85 .85;
           .35  .35 .85 .85;
           .05  -.12 .9 .95];
  x = randn(1,np); y = randn(1,np);
  z = exp(-(x*1.2).^2-(y*1.5).^2);
  z = z+1.1*exp(-((x+.8)*2.5).^2-((y-.8)*2.5).^2);

  v = linspace(-2,2,50);
  [xi,yi] = meshgrid(v,v);

  for jj = 1:3
    if jj==1
      zi = interptr(x,y,z,xi,yi);
    elseif jj==2
      zi = interptr(x,y,z,xi,yi,'e');
    elseif jj==3
      zi = interptr(x,y,z,xi,yi,'eg');
    end
    axes;
    s = surface(xi,yi,zi);
    caxis([-.1 1.2])
    hold on
    l = plot3(x,y,z,'.w');
    set(l,'markersize',15)
    set(gca,'pos',axpos(jj,:))
    view(-50,55), axis off, drawnow
  end

  % Labels .....
  at = axes('pos',[0 0 1 1]);
  t1 = text(.5,.97,'Gridding by triangulation method');
  set(t1,'horizontal','center','fontsize',18)

  t2(1) = text(.2,.45,'interptr(x,y,z,xi,yi)');
  t2(2) = text(.8,.45,'interptr(x,y,z,xi,yi,''e'')');
  t2(3) = text(.72,.03,'interptr(x,y,z,xi,yi,''eg'') /with gradients/');
  set(t2,'horizontal','center','fontsize',14)
  axis off
 
  set(gcf,'color',[.1 .1 .4])
return, end


% ================ FILLMISS ============================
% === Restoration of missing values in a matrix ========
name = 'fillmiss';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  np = [.1 1.0];
  clg
  P0 = peaks;
  nn = prod(size(P0));

  subplot(2,3,4)
  pcolor(P0); shading flat
  axis off
  title('Original')
  set(gca,'pos',[.01 .01 .31 .38])

  % A few missing values ...............
  ind = ceil(rand(1,np(1)*nn)*nn);
  P = P0;
  P(ind) = P(ind)*nan;
  np(1) = sum(sum(isnan(P)))/nn;
  subplot(2,3,2)
  pcolor(P); shading flat
  axis off
  title(['Missing ' num2str(np(1)*100) '%'])
  set(gca,'pos',[.35 .46 .31 .38])

  P = fillmiss(P);
  subplot(2,3,5)
  pcolor(P); shading flat
  axis off
  set(gca,'pos',[.35 .01 .31 .38])
  title('Restored')

  % Many missing values
  ind = ceil(rand(1,np(2)*nn)*nn);
  P = P0;
  P(ind) = P(ind)*nan;
  np(2) = sum(sum(isnan(P)))/nn;
  subplot(2,3,3)
  pcolor(P); shading flat
  axis off
  title(['Missing ' num2str(np(2)*100) '%'])
  set(gca,'pos',[.68 .46 .31 .38])

  P = fillmiss(P);
  subplot(2,3,6)
  pcolor(P); shading flat
  axis off
  title('Restored')
  set(gca,'pos',[.68 .01 .31 .38])

  % Title
  at = axes('pos',[0 0 1 1]);
  t1 = text(.5,.97,'Filling  missing  values  with  FILLMISS');
  set(t1,'horizontal','center','fontsize',18)
  axis off
  colormap jet

  set(gcf,'color',[.1 .1 .5])
return, end


% ==================== QUADTREE =========================
% === Adaptive division with QUADTREE program ===========
name = 'quadtree';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))
  clg

  % Parameters ..................................
  np = 400;  % Number of points
  clr = 'ygmc';
  sty = '.*xo';
  mksz = 5;

  x = randn(np,1);
  y = randn(np,1);
  s = ones(size(x));   % Auxillary vector
  n0 = 40;             % Maximal allowed number of points

  [ind,bx,by,Nb,lx,ly] = quadtree(x,y,s,n0);
  nbl = size(Nb,1);
  Sp = sparse(ind,1:np,1,nbl,np);

  % Number of points in each block ...............
  npb = full(sum(Sp'));

  isup = npb<n0/4;    % Mask for underpopulated blocks
  [ii,ib] = sort(-npb);

  % Find a "representative" block 
  % (with some neighbouring blocks underpopulated)
  is = 0;
  jj = 0;
  while ~is
    jj = jj+1;
    jc = ib(jj);
    i_nb = find(Nb(jc,:));
    is = any(isup(i_nb));
  end

  i_up = i_nb(isup(i_nb));
  a = zeros(1,nbl);
  a(i_nb) = ones(size(i_nb));
  a = ~a & any(Nb([i_up i_up(1)],:));
  i_sn = find(a);
  i_nb = i_nb(i_nb~=jc);

  % Plot boundaries of divided regions:
  close
  xb = lx(:,[1 2 2 1 1])';
  yb = ly(:,[1 1 2 2 1])';
  lb = plot(xb,yb,'w');
  set(lb,'linewidth',2)

  % Plot all points
  l = line('xdata',x,'ydata',y,'zdata',-ones(size(x)));
  set(l,'linestyle',sty(1))
  set(l,'color',clr(1),'markersize',10)

  % Plot points in a current block
  ii = find(ind==jc);
  lc = line('xdata',x(ii),'ydata',y(ii),'linestyle',sty(2));
  set(lc,'color',clr(2),'markersize',mksz)

  % Plot points in neighbouring blocks
  ii = find(any(Sp(i_nb,:)));
  ln = line('xdata',x(ii),'ydata',y(ii));
  set(ln,'linestyle',sty(3))
  set(ln,'color',clr(3),'markersize',mksz)

  % Plot points in "secondary neighb" blocks
  ii = find(any(Sp(i_sn,:)));
  ln = line('xdata',x(ii),'ydata',y(ii),'linestyle',sty(4));
  set(ln,'color',clr(4),'markersize',mksz)

  axis off
  set(gca,'pos',[0 0 1 1])

  set(0,'defaultlinemarkersize',mksz)
  set(0,'defaulttextfontweight','bold')
  al = legend([sty(2) clr(2)],'current block',...
    [sty(3) clr(3)],'neighbouring blocks',...
    [sty(4) clr(4)],'secondary neighb.');
  set(al,'color',[.2 .2 .4])
  posal = get(al,'pos');
  posal(1:2) = [0 0];
  set(al,'pos',posal)

  % Title
  at = axes('pos',[0 0 1 1]);
  t1 = text(.5,.97,'Division with QUADTREE');
  set(t1,'horizontal','center','fontsize',16)
  axis off 

  set(gcf,'color',[.1 .1 .5])
  refresh
  axes(al)

return, end


% =========== OBJMAP ====================================
% === Objective mapping with error estimation
name = 'objmap';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))

  clg
  np = 200;        % Number of points
  err = .1;        % Error scale
  x = randn(1,np);
  y = randn(1,np);
  z = peaks(x,y)+err*randn(1,np);

  vx = linspace(-2,2,50);
  vy = linspace(-2,2,60);
  [xi,yi] = meshgrid(vx,vy);

  [zi,em] = objmap(x,y,z,xi,yi,[],.1);

  % Error map first .................................
  colormap hot
  ac = subplot(1,2,2);
  cc = contourf(vx,vy,em,[.02 .05 .1 .2 .4 .6 .8 1]);
  set(gca,'pos',[.57 .05 .4 .8])
  lpe = line('xdata',x,'ydata',y,'zdata',zeros(size(x))+1);
  set(lpe,'linestyle','.','color','c','markersize',10)
  caxis([-5 6])
  title('Error map')
  clabel(cc,'manual')
  t = findobj(gca,'type','text');
  set(t,'fontweight','bold','fontsize',12,'color','b')
  for jj = 1:length(t)
    pos = get(t(jj),'pos'); pos(3) = 1;
    set(t(jj),'pos',pos)
  end
  set(get(gca,'title'),'color','w')

  % Surface plot
  as = subplot(1,2,1);
  surf(xi,yi,zi);
  %set(gca,'pos',[-.0 .0 .6 1])
  set(gca,'pos',[-.15 -.2 .85 1.3])
  view([-30 55])
  lps = line('xdata',x,'ydata',y,'zdata',z+.05);
  set(lps,'linestyle','.','color','c','markersize',14)
  caxis([-15 10])
  axis off

  % Global title ............
  at = axes('pos',[0 0 1 1]);
  t1 = text(.5,.97,'Objective mapping with OBJMAP');
  set(t1,'horizontal','center','fontsize',16)
  axis off
  t2 = text(.05,.05,['Relative error: ' num2str(err/mean(std(z)))]);
  set(t2,'fontsize',15)

  set(gcf,'color',[.1 .1 .5])
return, end

% ============ POLYHD =============================
% === Points inside and outside of 3-d polyhedron
name = 'polyhd';
lm = min(length(flag),length(name));
if strcmp(flag(1:lm),name(1:lm))

  clg
  nv = 25;
  ni = 15;
  no = 15;
  Rv = eqdsph(nv);
  Ri = randisph(ni,3)*.8;
  Ro = randsph(no)*1.2;

  % Calculate convex hull ................
  [N,Nrm] = convexh(Rv);
  p = surftri(N,Rv);

  % Make forward facets transparent ......
  [az,el] = view;
  az = (az-90)/180*pi;
  el = el/180*pi;
  [xv,yv,zv] = sph2cart(az,el,1);
  dirv = [xv yv zv]';
  ii = find(Nrm*dirv>0);
  set(p,'edgecolor','w')
  set(p(ii),'facecolor','none',...
     'linewidth',3,'edgecolor','w')


  % Plot points - vertices, in, out
  hold on
  lv = plot3(Rv(:,1),Rv(:,2),Rv(:,3),'oc');
  li = plot3(Ri(:,1),Ri(:,2),Ri(:,3),'or');
  lo = plot3(Ro(:,1),Ro(:,2),Ro(:,3),'oy');
  set(lv,'markersize',7)
  set(li,'markersize',7)
  set(lo,'markersize',7)


  % Call INPOLYHD
  R_all = [Rv; Ri; Ro];
  is = inpolyhd(R_all,Rv,N);

  % Plot points according to results
  ii = find(is==0.5);
  Rc = R_all(ii,:);
  lv1 = plot3(Rc(:,1),Rc(:,2),Rc(:,3),'*c');

  ii = find(is==1);
  Rc = R_all(ii,:);
  li1 = plot3(Rc(:,1),Rc(:,2),Rc(:,3),'.r');
  set(li1,'markersize',17)

  axis off, axis square
  set(gca,'pos',[-.25 -.35 1.6 1.7])

  % Legends ...............................
  al1 = legend([lv li lo lv1 li1]',str2mat(...
  'vertices','in','out','bound. pts. from INPOLYHD',...
  'inside pts. from INPOLYHD'));
  set(al1,'pos',[0 0 .4 .18])
  lli1 = findobj(al1,'type','line','linestyle','.');
  set(lli1,'markersize',16)

  col = pink(64);
  colormap(col(20:40,:))

  % Global title ............
  at = axes('pos',[0 0 1 1]);
  t1 = text(.5,.97,'Inside/out with INPOLYHD');
  set(t1,'horizontal','center','fontsize',16)
  axis off

  set(gcf,'color',[.1 .1 .5])

return, end


 % If still continuing, unknown name
disp(['Name  ' upper(flag) '  is not found'])

