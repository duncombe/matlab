function  ba = bodyang(R1,R2,R3)
% BODYANG  Body (solid) angle computation.
%	BA = BODYANG(R1,R2,R3)  Calculates body
%	(solid) angle formed by 3 points with
%	coordinates R1, R2, R3 (R1=[x1 y1 z1],...)
%	as seen from origin of coordinate system.

%  Copyright (c) 1995 by Kirill K. Pankratov. 
%	kirill@plume.mit.edu
%	11/16/94, 

 % Defaults and parameters ...............................
tol = 4*eps;         % Tolerance for angles
null_value = nan;    % Value for the case of 
                     % zero-length vectors

 % Handle input ******************************************
if nargin==0, help bodyang, return, end  % Help
if nargin==1  % If input is [R1;R2;R3] or [az1 el1; .. az3,el3]
  sz = size(R1);
  if all(sz==[2 2]), R1 = [0 0; R1];
  elseif all(sz==[2 3]), R1 = R1'; end
  if all(size(R1)==[3 2])
    [R1,R2,R3] = sph2cart(R1(:,1)',R1(:,2)',1);
  end
  if all(sz==[3 3]),
    R2=R1(2,:)'; R3=R1(3,:)'; R1=R1(1,:)';
  elseif any(sz>3)|any(sz<2)
    error('  Input matrix must be 3 by 3 or 3 by 2')
  end
end
if nargin==2
  error('  Must be 1 or 3 input arguments.')
end
if nargin==3
  sz = [size(R1); size(R2); size(R3)];
  if any(diff(prod(sz')))    % Check sizes
    error('  Arguments R1,R2,R3 must have the same size')
  end
  is3 = all(any(sz'==3));
  is2 = all(any(sz'==2));
  if is3
    nn = find(sz(:,1)==3);
    for jj = 1:3
      nn = find(sz(jj,:)==3);
      if nn(1)>1
        eval(['R' num2str(jj) '=R' num2str(jj) ''';']);
      end
    end
  elseif is2
  else, error(' Input matrices must be N by 3')
  end
end


 % Auxillary ...............
o3 = ones(3,1);

 % Lengths of all vectors
normal12 = [sqrt(sum(R1.^2)); sqrt(sum(R2.^2)); sqrt(sum(R3.^2))];
numnull = find(~(any(normal12))); % Find vectors with zero length
normal12(:,numnull) = ones(3,length(numnull));

 % Make all vectors to have unit length
a23 = normal12(1,:);
R1 = R1./a23(o3,:);
R2 = R2./normal12(2*o3,:);
R3 = R3./normal12(3*o3,:);

 % Find normals
normal12 = cross(R1,R2);         % Cross product
ln12 = sqrt(sum(normal12.^2));   % Length of normal vectors
normal12 = normal12./ln12(o3,:); % Make normal unit length
normal13 = cross(R1,R3);         %   The same for R1,R3
ln13 = sqrt(sum(normal13.^2));
normal13 = normal13./ln13(o3,:);
normal23 = cross(R2,R3);         %   The same for R2,R3
ln23 = sqrt(sum(normal23.^2));
normal23 = normal23./ln23(o3,:);


 % Angles between planes 
ang1 = acos(abs(sum(normal12.*normal13)));  % (0,1,2),(0,1,3)
ang2 = acos(abs(sum(normal12.*normal23)));  % (0,1,2),(0,2,3)
numnorm = find(ang1+ang2>=pi-tol);

 % Calculate projection of R3 into plane (0,R1,R2)
prjn = sum(R3.*normal12);        % Scalar product with normal
R3prj = R3-normal12.*prjn(o3,:); % Projection into (0,1,2) plane
a12 = sqrt(sum(R3prj.^2));
a12(numnorm) = ones(size(numnorm));
R3prj = R3prj./a12(o3,:);

 % Plane angles in the (0,1,2) plane
a12 = acos(sum(R1.*R2));      % Between (0,1) and (0,2)
a13 = acos(sum(R1.*R3prj));      % (0,1) and (0,3prj)
a23 = acos(sum(R2.*R3prj));      % (0,2) and (0,3prj)

 % Partial body angles .......
ba = a13>pi/2;  % Is span more than pi/2
ba1 = abs(2*ang1.*ba-asin(sin(ang1).*sin(a13)));
ba = a23>pi/2;  % Is span more than pi/2
ba2 = abs(2*ang1.*ba-asin(sin(ang2).*sin(a23)));


 % Find if projection of R3 is between  R1 and R2 (ba = ba1+ba2)
 % or outside (ba = |ba1-ba2|)
ln13 = (a12+a13+a23)>=(2*pi-tol);  % If sum of 3 angles is 2*pi
ln12 = ~ln13&(a13>a12|a23>a12);
ln12 = ln12*2-1;

 % Composite body angle ......
ba = abs(ba1-ba2.*ln12);      % ba1+ba2 or |ba1-ba2|
ba(ln13) = 2*pi-ba(ln13);     % When encircling the North pole

 % Special cases ..............
ba(numnorm) = a12(numnorm);   % When R3 is normal to (0,R1,R2)
ba(numnull) = ba(numnull)*null_value;  % Zero-length vectors
