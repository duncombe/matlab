function  sagawcm
% SAGAWCM "Welcome" figure for SaGA toolbox.
%	Can be used as a demonstration of various
%	plotting functions in SaGA toolbox.

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       05/10/95

 % Figure itself .........................
clg
set(gcf,'pos',[60 300 550 490])
set(gcf,'color',[.15 .15 .5])
colormap jet
brighten(.6)


 % Torus and ellipsoid ...................
st = torus(1.9);
se = ellipsd([1 1 5]);
view(3)
lim = 4;
axis([-1 1 -1 1 -1 1]*lim);
azel = [20 20];
ang = -20;
rotate(st,azel,ang)
rotate(se,azel,ang)
set(se,'edgecolor','c')
set(st,'edgecolor','c')
set(gca,'pos',[-.06 .58 .41 .45])
caxis([-2 1.5])
axis off


 % Knot with a TUBE function .............
akn = axes;
skn = knots(3,'',.2);
set(skn,'edgecolor',[1 .3 .7])
axis square, axis equal, axis off
caxis([-.8 1.5])
set(gca,'pos',[.01 .3 .31 .33])


 % Circles ...............................
acr = axes;
s3 = sqrt(3);
r0 = [0 2; -s3 -1; s3 -1]/2;
circle(1,r0(:,1),r0(:,2),'gbr',12)
axis([-2.5 2.5 -2.5 2.5])
axis square, axis equal,axis off
set(gca,'pos',[.79 .03 .21 .21])


 % Hexagonals ...........................
ahx = axes;
n = 12;
r = (0:10)/10;
th = .7*r*2*pi;
x0 = r.*cos(th);
y0 = -r.*sin(th);
clr = hot;
clr = clr(18:3:n*4,:);
l = circle(.1+r/2,x0,y0,clr,5,6);
axis square, axis equal, axis off
axis([-1.5 1.5 -1.5 1.5])
set(gca,'pos',[.65 -.04 .25 .28])

drawnow

 % Filled contour plot .................
acf = axes;
contourf(peaks,15)
set(gca,'pos',[.34 .01 .3 .26])
set(gca,'xticklabels','','yticklabels','')


 % Triangulated plane ..................
atp = axes;
np = 24;
x = rand(1,np); y = rand(1,np);
N = triangul(x,y,2);
ii = 12:5:size(N,2);
[c,r] = circmsph([x' y'],N(:,ii));
axis(axis),circle(r,c(:,1),c(:,2),'w',2)
axis square, axis equal
set(gca,'xticklabels','','yticklabels','','box','on')
set(gca,'pos',[.71 .32 .29 .29])
caxis([-2 6])


 % Convex hull of a uniform set of points
 % on a sphere ..........................
ach = axes;
R = eqdsph(20);
N = convexh(R);
surftri(N,R,[80,60]);
%c = caxis; cm = mean(c);caxis(cm+(c-cm)*4);
caxis([-3 5])
axis square, axis equal, axis off
set(gca,'pos',[.68 .46 .36 .68])

drawnow

 % Fitting a surface by triangulation method
 % with INTERPTR function  ...............
afs = axes;
np = 300;
r = randisph(np);
x = 2*r(:,1);y=2*r(:,2);
z = peaks(x,y)+5;
[p,N] = surftri(x,y,z);
hold
 % Interpolation ........
v = linspace(-2,2,15);
[xi,yi] = meshgrid(v,v);
zi = interptr(x,y,z,xi,yi,'g',.4);
l1 = plot(xi,yi,'.y',xi',yi','.y');
set(l1,'markersize',10)
l2 = plot3(xi,yi,zi,'.w');
set(l2,'markersize',10)
axis off
set(gca,'pos',[.3 .2 .42 .54])



 % Title ************************************
att = axes('pos',[0 0 1 1]);
t(1) = text(.5,.96,'SaGA');
set(t(1),'fontsize',28,'fontweight','bold','color','y')
t(2) = text(.5,.88,'Spatial and Geometric');
set(t(2),'fontsize',20,'color','y')
t(3) = text(.5,.81,'Analysis');
set(t(3),'fontsize',20,'color','y')
t(4) = text(.5,.74,'toolbox','color','y');
set(t(4),'fontsize',16)
t(5) = text(.5,.68,'by  Kirill Pankratov');
set(t(5),'fontsize',15)
set(t,'horizontal','center')
set(t,'fontweight','bold')
axis off


 % Tetrahedron
atr = axes;
set(gca,'pos',[-.03 .0 .32 .37])
lim = [.3 1 .2 1];
axis(lim), axis off
drawnow
r = [
    0.8211    0.6936    0.3391
    0.3993    0.5835    0.4535
    0.9789    0.2175    0.4207
    0.9257    0.8527    0.1390];
filltetr(r,'interp');

