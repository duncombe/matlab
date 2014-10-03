% DLNDEMO  Demonstration of Delaunay triangulation.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/10/95

echo on

%     Welcome to the demonstration of Delaunay 
%      triangulation/tesselation programs!
%
% In this demo we shall see how to create and 
% visualize ...

 pause  % Hit any key to continue...

% Generate a set of random points on a plane
% and triangulate it while watching the process 
% (flag 1 as a third argument):

  x = rand(100,1); y = rand(100,1);
  clg
  N = triangul(x,y,1);

 pause  % Hit any key to continue...

% Now make a similar triangulation but plot only final result
% (flag=2)
% Again generate a few random points X, Y:

  n = 8; x = rand(n,1); y = rand(n,1);

% Set flag to 2:

  clg,
  N = triangul(x,y,2);
  colormap cool
  caxis([0 5])

 pause  % Hit any key to continue...

%   How can we determine if this triangulation is a 
% Delaunay one or not?
%   One very important and useful property of Delaunay 
% triangulation/tesselation in arbitrary dimension is the 
% following: inside a circle (circumsphere) of each triangle 
% (simplex) there must be no other points.
%
%   At first let's make a visual check by plotting
% circles through all triangles. One can use a program
% CIRCMSPH to compute centers and  radii of circles or
% spheres around simplices in any dimensions:

  [c,r] = circmsph([x y],N);

%   Plot circles through each triangle. We shall use a
% routine CIRCLE to do this:

  axis(axis)
  circle(r,c(:,1),c(:,2),'y',1)

% Make proportions right:
  axis equal, axis square,

% Add title and labels
  %set(gca,'xticklabels','','yticklabels','')
  title(['Delaunay triangulation and circles around'...
       ' each triangle'],'fontsize',14)

 pause  % Hit any key to continue...

%   Now make a rigorous computational check whether this 
% is a Delaunay triangulation.
%
%  One can use the program ISDLN for this purpose.

  isdln(N,[x,y])

 pause  % Hit any key to continue...


%   Now let's try multi-dimensional DELAUNAY
% triangulation.  It is more difficult to visualize, but
% still is a very important tool for geometric analysis.
% the program DELAUNAY can perform Delaunay triangulation


%   First generate a few random points 

  R = rand(10,4);
  N = delaunay(R)

% Check if the triangulation is a Delaunay one:

  isdln(N,R)

echo off

