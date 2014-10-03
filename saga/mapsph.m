function [Ro,z] = mapsph(Ri,rad,r0)
%  MAPTSPH  Mapping d-dimensional cartesian set
%	on a surface of a d+1 - dimensional sphere.
%	RO = MAPTSPH(RI) Maps dataset RI on a surface
%	of a sphere of dimension higher by one.
%	MAPSPH(RI,RAD,R0) accepts also radius RAD
%	of the sphere and center R0 of the dataset.
%	if RAD<0, it is interpreted as a multiple
%	for approximate radius of a set, that is 
%	actual radius of a sphere is -RAD*R_set.

%  Used in DELAUNAY tesselation program and plots of
%  triangulated surfaces.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

rad_dflt = 2; % Default for curvature radius
              % (relative to the set radius)

 % Handle input .....................................
[n_pts,d] = size(Ri);  % Input size
if nargin<3, r0 = mean(Ri);  end   % Origin
if nargin<2, rad = -rad_dflt; end % Curvature coefficient

 % Auxillary
opts = ones(n_pts,1);
od = ones(d,1);

 % Calculate approximate center and the diameter of a set
Ro = Ri-r0(opts,:);
r = sqrt(sum((Ro.^2)'))';
a = max(r);    % Approximate radius

 % Choose the radius of curvature n_rad times
 % larger than the radius of a set
if rad<0,  rad = -rad*a; end

 % Map a set on a sphere of d+1 dimension .........
Ro = Ro./r(:,od);
r = r/rad;
z = cos(r);
s = sin(r);
Ro = Ro.*s(:,od);  % Add "vertical" dimension

 % Output .....................
if nargout==1, Ro = [Ro z]; end

