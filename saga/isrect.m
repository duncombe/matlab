function [r,lim] = isrect(x, y)
%ISRECT True if polygon encloses a rectangular shape.
%       ISRECT(X, Y) returns 1 if X and Y are the x- and y-coordinates
%       of the vertices of a polygon that encloses a rectangular
%       shape.  Otherwise it returns 0.  X and Y must be vectors that
%       have the same length.  The input polygon must be closed; in
%       other words, X(1)==X(length(X)) and Y(1)==Y(length(Y)).  

%   Outline of the calculations:
%  1. Transform coordfinates so that if rectangle, its sides
%     will be aligned in the new x,y directions.
%  2. Find rectangle of limits ("bounding box") and check
%     if all the points belong to it.
%  3. If yes, check if neighbouring points lie on the same
%     sides of limiting rectangle.
%  4. If yes, check if all the perimeter of the limiting
%     rectangle is covered by a polygon.

%  Kirill K. Pankratov,  kirill@plume.mit.edu
%  01/20/95

tol = 1e-12;   % Tolerance
r = 1;         % "Quick return" value

 % Handle input .............................................
if nargin==0, help isrect, return, end

 % Check for complex arguments 
if nargin==1,
  y = imag(x); x = real(x);
  if all(y==0), return; end
end

 % Make sure both arguments are column vectors
x = x(:); y = y(:);
n = length(x);
 % Check the length
if n~=length(y)
  error('  Vectors x, y must have the same length')
end

 % If less than 3 points, always (degenerate) rectangle
if n < 3, return, end

 % Transform coordinates so that the longest side will be
 % aligned along a new x-direction and the perpendicular
 % direction will remain so .................................
 % Find maximum distance interval ..........
a = (x(2:n)-x(1:n-1)).^2+(y(2:n)-y(1:n-1)).^2;
[ll,n0] = max(a);

 % If degenerate (single point), quick return
if ~ll, return, end
 
 % Make longest side a new x basis vector
x = x-x(n0);
y = y-y(n0);
xx = x(n0+1);
yy = y(n0+1);
ll = xx.^2+yy.^2;
xx = xx/ll;
yy = yy/ll;

 % Perform transformation ..........
A = [xx -yy; yy xx];  % Transformation matrix
B = [x y]*A;          % New coordinates [x y]

 % Find limits and check if all points are on a line
 % lim=[min(x) min(y) max(x) max(y)] ......
lim = [min(B) max(B)];
span = lim([3 4])-lim([1 2]);
 % If on the line and closed, return 1
if any(span<tol), return, end

 % Calculate "binary" matrix B (n by 4) where each row
 % shows whether coordinates of a point equal to limits
o_n = ones(n,1);  % Auxillary indexing vector
B = abs(B(:,[1 2 1 2])-lim(o_n,:))<tol;

sumB = sum(B');   % 2 - for corner points, 1 for points
                  % on the sides, 0 - outside or inside
 % Common sides for neighbouring points:
A = B(1:n-1,:) & B(2:n,:);
                       
 % Check if all points lie on the perimeter of the limiting
 % limiting rectangle (sumB~=0) and neigbouring points
 % belong to the same sides. If not, polygon is not a 
 % rectangle:
r = all(sumB) & all(any(A'));
if ~r, return; end


 % If the routine continues, all the points lie on the
 % limiting rectangle. The last operation: check
 % if all the perimeter of this rectangle is covered.

B = B(sumB==2,:); % Extract corner points only
 % B: 1 1 0 0 for lower-left  corner
 %    0 1 1 0     lower-right
 %    0 0 1 1     upper-right
 %    1 0 0 1     upper-left

 % Now calculate "magic numbers" for connections
 % between neighbouring corner points.
 % For "lock" vector [1 4 2 6] and deductible 5
 % must give 2 - for lower side, 9 - right, 6 - upper
 % 5 - left,  1 - return to the same corner point
m_n = (B*[1 4 2 6]'-5).^2;
m_n = abs(diff(m_n))'+1;    % Magic numbers

 % Make a key with "indentures" at magic number
 % positions and match with magic number "lock" vector:
key = ones(1,10);
key([2 9 6 5]) = zeros(1,4);
key(m_n) = key(m_n)+ones(size(m_n));

 % If all the key pattern is matched, all perimeter
 % of the limiting rectangle is covered .........
r = all(key);
