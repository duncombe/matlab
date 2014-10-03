function [p,order] = filltetr(R4,cdata,shade)
% FILLTETR  Plotting a tetrahedron.
%	FILLTETR(R) Plots a tetrahedon with coordinates
%	of 4 vertices given by a matrix R (4 by 3).
%	FILLTETR(R,CDATA,SHADE) Can also specify color
%	data and shading (such as 'flat' or 'interp')
%	of tetrahedral facets.

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	11/30/94

 % Defaults and parameters .........................
cdatadflt = (0:3)'*16+1;  % Spans 64-colormap
shadedflt = 'flat';

 % Handle input .....................................
if nargin<3, shade = shadedflt; end
if nargin<2, cdata = cdatadflt; end
if isstr(cdata)
  shade = cdata;
  cdata = cdatadflt;
end

 % Auxillary ........
o3 = ones(3,1); zr3 = zeros(1,3);
v3 = 0:2;
N = [2 3 4; 1 3 4; 1 2 4; 1 2 3]';

 % Get figure and axes parameters
clim = get(gca,'clim');
view_v = get(gca,'view')*pi/180;
szcm = size(get(gcf,'colormap'),1);

if size(cdata,1)==1, cdata = cdata'; end
if size(cdata,1)<4, cdata = cdatadflt; end
if size(cdata,2)==3, shade = 'interp'; end
if strcmp(shade,'interp')&size(cdata,2)==1
  cdata = reshape(cdata(N'),4,3);
end
set(gca,'climmode','manual')
%set(gca,'drawmode','fast')
 % Set to caxes limits
cdata = clim(1)+cdata*(clim(2)-clim(1))/szcm;

 % Calculate the view vector
[xv,yv,zv] = sph2cart(-pi/2+view_v(1),view_v(2),1);
view_v = [xv,yv,zv];

 % Compute drawing order of plane segments
shift_R = max(R4);
shift_R = shift_R+sign(shift_R).*(shift_R-min(R4));
R4s = R4+shift_R(ones(4,1),:);
for jj = 1:4
  norm(:,jj) = R4s(N(:,jj),:)\o3;  % Normal
end
sgn_v = sign(view_v*norm);
sgn_4 = sign(diag(R4s*norm)-1)';
sgn_4 = -sgn_4.*sgn_v;

[sgn_4,order] = sort(sgn_4);
N = N(:,order);
cdata = cdata(order,:);

 % Create a patch
ch = get(gca,'child');
if ch==[], p0=patch(zr3,zr3,zr3,'w'); end
p = patch('facecolor',shade,'cdata',cdata(1,:)); drawnow

 % Paint all 4 facets successively with one patch
set(p,'erasemode','none')
for jj = 1:4
  R3 = R4(N(:,jj),:);
  set(p,'xdata',R3(:,1),'ydata',R3(:,2),'zdata',R3(:,3));
  set(p,'cdata',cdata(jj,:))
  drawnow
end

