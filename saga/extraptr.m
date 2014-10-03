function  ze = extraptr(x,y,z,N,xe,ye)
% EXTRAPTR Extrapolation beyond the convex hull of a 
%	triangulated domain.
%	ZE = EXTRAPTR(X,Y,Z,N,XE,YE) Performs extrapolation
%	of Z data from triangles having edges along the
%	convex hull of data set X, Y (their indices are
%	stored in matrix N (3 by ntr, where nc - number of
%	edges of the convex hull).
%
%	See also INTERPTR, TRIANGUL, CONVEX2.

% Copyright (c)  Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/12/95, 09/15/95

pwr = 3;        % Power index (inverse) for weights
show_trng = 0;  % Is to plot triangles used in extrap.

 % Handle input .........................
if nargin==0, help extraptr, return, end
if nargin < 6
  error('  Not enough input arguments')
end

szxe = size(xe);
if any(~szxe), ze = xe; return, end
x = x(:); y = y(:); z = z(:);
xe = xe(:)'; ye = ye(:)';
szN = size(N);
if szN(1)>3 & szN(2)==3
   N = N'; szN = fliplr(szN);
end

[w,ze] = adjspx(N);
s1 = sum(~ze);
i1 = find(s1>=1);
i2 = find(s1==2);
i_new = max(w(:,i2));
N(:,i2) = N(:,i_new);
ze(:,i2) = ze(:,i_new);

Ne = N(:,i1);
nNe = size(Ne,2);
x2 = 1:nNe;
x2 = x2(ones(3,1),:);
cc = max(max(Ne))+2;
s1 = sparse(Ne,x2(ones(3,1),:),1,cc,nNe);

 % Show triangles
if show_trng
  cla
  for jj=1:size(Ne,2)
    c_t = Ne(:,jj);patch(x(c_t),y(c_t),z(c_t(1)));
  end
  drawnow
end

s2 = sparse(ze(1:2,i1),x2(ones(2,1),:),10,cc,nNe);
x2 = s1+s2;
[s1,s2,s3] = find(x2);
s3 = -s3-s1/cc;
x2 = reshape(s3,3,nNe);
x2 = abs(sort(x2));
Ne = round((x2-floor(x2))*cc);

 % Check areas of triangles
s1 = reshape(x(Ne),3,nNe);
s2 = reshape(y(Ne),3,nNe);
s = (s1(2,:)-s1(1,:)).*(s2(3,:)-s2(1,:));
s = s-(s1(3,:)-s1(1,:)).*(s2(2,:)-s2(1,:));
i1 = find(s<0);    % Clock-wise triangles

 % Make all triangles anticlockwise and make the
 % first edge "external"
Ne([1 2],i1) = Ne([2 1],i1); 
s = abs(s);


 % Auxillary ..........
oe = ones(length(xe),1);
oc = ones(1,nNe);

 % Triangle coordinate vectors ..........
x1 = x(Ne(1,:));
x2 = x(Ne(2,:));
x3 = x(Ne(3,:));

y1 = y(Ne(1,:));
y2 = y(Ne(2,:));
y3 = y(Ne(3,:));

 % Calculate (signed) area of triangles formed
 % by all outer edges with all points of
 % extrapolation
 % Auxillary differences
s1 = x1(:,oe)-xe(oc,:);
s2 = x2(:,oe)-xe(oc,:);

 % Areas themselves
s3 = s1.*(y2(:,oe)-ye(oc,:));
s3 = s3-s2.*(y1(:,oe)-ye(oc,:));


 % Find those pairs (triangles, extrap. points)
 % for which area is negative ...........
ze = find(s3>0);  % These are to be excluded
s3(ze) = zeros(size(ze));
[i1,i2,s3] = find(s3);

%for jj=1:length(xe)
%plot(xe(jj),ye(jj),'o'); hold on
%fnd = find(i2==jj);  ij = i1(fnd);
%fill(X(:,ij),Y(:,ij),'r'), hold off, pause,end

 % Calculate relevant coordinate differences
x1 = x1(i1)-xe(i2)';
x2 = x2(i1)-xe(i2)';
x3 = x3(i1)-xe(i2)';

y1 = y1(i1)-ye(i2)';
y2 = y2(i1)-ye(i2)';
y3 = y3(i1)-ye(i2)';

w = (x1.^2+y1.^2)+(x2.^2+y2.^2)+(x3.^2+y3.^2);
w = w.^(-pwr);

 % Calculate areas of triangles formed by internal
 % edges with extrapolation points ........
s1 = x2.*y3-x3.*y2;
s2 = x3.*y1-x1.*y3;

 % Now get Z data (label them y for memory economy)
y1 = z(Ne(1,:));
y2 = z(Ne(2,:));
y3 = z(Ne(3,:));

y1 = y1(i1);
y2 = y2(i1);
y3 = y3(i1);


 % Sum of all areas = area of basis triangles
x1 = s(i1)';

 % Extrapolation from all relevant triangles
x2 = (y1.*s1+y2.*s2+y3.*s3)./x1;

x2 = x2.*w;  % Multiply by weights

 % Add together extrapolations from relevant 
 % triangles ........
S = sparse(1:length(i2(:)),i2,x2);

ze = full(sparse(1,i2,x2));

 % Add together weights
x3 = full(sparse(1,i2,w));

 % Divide sum of extrapolations by sum of weights
ze = ze./x3;

 % Reshape to the input size ........
ze = reshape(ze,szxe(1),szxe(2));
