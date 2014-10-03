function  R = rotmat3(ang,ax)
% ROTMAT3  3-dimensional rotation matrix.
%	R = ROTMAT3(ANG,AX) returns matrix R which
%	is the product of successive rotations 
%	through angles ANG = [A1,A2,A3,...] about
%	axes AX = [AX1,AX2,AX3,...].
%	ANG must be a vector and AX must be either
%	a vector of the same length as ANG or matrix
%	3 by length(ANG) where each column specifies
%	vector of rotation axis.
%	Axes also can be specified as a string such as
%	'xyz', so that
%	R = ROTMAT3(ANG,'xyz')  is equivalent to
%	ROTMAT3(ANG,[1 2 3]) or  ROTMAT3(ANG,eye(3)).
%
%	R = ROTMAT3(ANG,'euler')     or
%	R = ROTMAT3(ANG,'cardinal') 
%	where ANG = [THETA PSI PHI] returns matrices
%	of rotations through Euler or Cardinal angles
%	respectively.
%
%	R = ROTMAT3('rand') uses rotations at random
%	angles in the range [-pi pi] around x,y,z
%	axes successively (so that it is equivalent
%	to R=rotmat3(pi*(2*rand(1,3)-1),[1 2 3]) )

%  Copyright (c) 1995 by Kirill K. Pankratov
%       kirill@plume.mit.edu
%       01/23/95, 05/22/95

 % Handle input ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
if nargin==0, help rotmat3, return, end
aax = [];
if nargin==1     % 'rand' or default axes
  if isstr(ang) & strcmp(ang,'rand')
    ang = pi*(rand(3,1)*2-1);
    aax = eye(3);
  end
end

la = length(ang);
c = cos(ang);
s = sin(ang);

if nargin==2

  if isstr(ax)   % "Named" angle systems ..........
    % Euler axes - y, old z, new z
    if ax(1)=='e'
      if la~=3
      error('Euler angles must be a 1 by 3 vector')
      else
        aax = [0 -s(1) 0; 1 0 0; 0 c(1) 1]; 
      end
    % Cardinal angles - y, new x, new z
    elseif ax(1)=='c'
      if la~=3
      error('Cardinal angles must be a 1 by 3 vector')
      else
        aax = [0 1 0; 1 0 0; 0 0 1];
      end
    elseif all(ax>='x') & all(ax<='z')  % 'xyz'
      aax = abs(ax-'w');
    else
      error(' Unidentified angle type')
    end

  else        % "Numerical" axes ..................
    aax = ax;
  end

end  % End nargin==2

 % If axes not specified, cycle through (1,2,3)
if aax==[], aax = rem(0:la-1,3)+1; end

if size(aax,2)~=la
  error([' Length of angle vector must be equal to '...
         'number of columns of axes matrix'])
end

 % If axes is a vector, make 3 by length(ang) matrix
if any(size(aax)==1) ...............
  v = aax(:);
  nn = v+(0:la-1)'*3;
  aax = zeros(3,la);
  aax(nn) = v;
end


 % Normalize axes vectors ..........
nrm = sqrt(sum(aax.^2));
aax = aax./nrm(ones(3,1),:);

c1 = 1-c;   % Auxillary 1-cos(a)

 % Make a product of rotations around each axes ....
for jj = 1:la

  ax_c = aax(:,jj);    % Current axis vector
  v = ax_c*s(jj);      % sin(a) * [nx,ny,nz]
  R_c = [c(jj)   v(3)  -v(2);
         -v(3)  c(jj)  v(1);
          v(2)  -v(1)  c(jj)];
  R_c = R_c+(c1(jj)*ax_c)*ax_c'; % Current rotation

  % Initialize R or multiply by R_c
  if jj==1, R = R_c;
  else,  R = R_c*R;
  end

end

