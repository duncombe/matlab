% TREEDEMO   Demonstration program for QUADTREE.M

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	01/30/95

echo on

%  Hello!
% This is a short demonstration of the QUADTREE routine.
% This program divides a 2-dimensional region containing
% a set of points (x,y), into smaller rectangular regions
% containing no more than a specified number of points.
% QUADTREE calculates indices showing which region
% each point of a set belongs to and "binary address"
% bx, by  of each region.
% The program also returns the "Adjacency matrix" Nb
% which is 1 if (i,j) regions are neighbours and
% 0 otherwise.

 pause    % Hit any key to continue ...

 % Generate  a set of points x, y
np = 400;
x = randn(np,1);
y = randn(np,1);

% Let's divide the plane (x,y) into non-intersecting
% rectangular regions so that each of them will contain
% no more than 40 points:

s = ones(size(x));   % Auxillary vector
n0 = 40;             % Maximal allowed number of points

 pause    % Hit any key to continue ...

% Call QUADTREE:

 [ind,bx,by,Nb,lx,ly] = quadtree(x,y,s,n0);

% Plot boundaries of divided regions:
 close
 xb = lx(:,[1 2 2 1 1])';
 yb = ly(:,[1 1 2 2 1])';
 plot(xb,yb,'w')


% Now plot point belonging to each of these regions
% and also points adjacent in adjacent regions

 pause    % Hit any key to continue ...

% For each region .......
for jj = 1:size(Nb,2)

  nn = find(ind==jj);
  if jj==1
    l = line('xdata',x(nn),'ydata',y(nn));
    set(l,'linestyle','o','erasemode','xor')
    set(l,'color','y','markersize',7)
    ln = line('xdata',x(nn),'ydata',y(nn));
    set(ln,'linestyle','.','erasemode','xor')
    set(ln,'color','c','markersize',10)
  else
    set(l,'xdata',x(nn),'ydata',y(nn));
  end

  % Now show neighbouring regions:
  xn = []; yn = [];
  for jjn = find(Nb(jj,:)); % For each neighbour ....
    nnn = find(ind==jjn);
    xn = [xn; x(nnn)];
    yn = [yn; y(nnn)];
    set(ln,'xdata',xn,'ydata',yn);
    drawnow
  end

  pause(1)
end

echo off

