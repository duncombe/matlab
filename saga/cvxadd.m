function [Fo,Nrmo,afo,apo] = cvxadd(Fi,Nrmi,afi,R,api,r0)
% CVXADD Adding an outer point to a convex hull.
%	[FO,NRMO,AFO] = CVXADD(FI,NRMI,AFI,R,NP,R0),
%	   where the input parameters are:
%	FI   - List of facets indices
%	NRMI - Outer normals to these facets
%	AFI  - Boolean vector active/inactive facets
%	R    - Coordinartes of a set of points
%	API  - Boolean vector active/inactive points
%	R0   - Coordinates of a "control point" (inside an 
%	       existing convex hull.
%	   Output parameters:
%	FO   - New facets indices
%	NRMO - New outer normals
%	AFO  - Boolean vector for active/inactive facets
%	APO  - Boolean vector for active/inactive facets
%
%  Used inside CONVEXH.M (convex hull computation).

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/01/95, 05/08/95

[n_fac,d] = size(Fi);

 % Check whether a point is "internal" or "external"
 % for active facets
nn = afi(1);
c_pt = R(nn,:);        % Coordinates of added point
i_fac = Nrmi*c_pt'>1;  % Boolean (1-external)

 % Construct new facets from all facets for which the
 % point is external
ind = find(i_fac);
n_new = length(ind);
Edge = Fi(i_fac,:);    % Get facets to become inside

 % Auxillary for indexing
od = ones(d,1);
I = (1:n_new);
I = I(od,:);
I = I(:);
Edge = Edge(I,:)';

E = ~eye(d);
I = (1:d)';
I = I(:,ones(n_new,1));
I = I(:);
E = E(I,:)';
Edge = Edge(E);
Edge = reshape(Edge,d-1,n_new*d)';

 % Make a unique edge list
[Edge,ind,cnt] = unique(Edge);

 % Remove duplicated edges which would form "folded" facets 
Edge = Edge(find(cnt<2),:);
n_new = size(Edge,1);

 % Add the current outer point to form new facets
Fo = [Edge nn(ones(n_new,1))]';
Fo = sort(Fo)';

 % Calculate normals to the new facets
Nrmo = zeros(size(Fo));
for jj=1:n_new
  c_nrm = R(Fo(jj,:),:)\od;
  Nrmo(jj,:) = c_nrm';
end

 % Check sign to ensure it points outward
cnt = Nrmo*r0'>1;
ind = find(cnt);
Nrmo(ind,:) = -Nrmo(ind,:);

 % Remove outermost points of all facets from the active
 % points list
apo = api;
apo(nn) = 0;
apo(Fo) = zeros(size(Fo));
%apo0=apo;apo(Fo) = zeros(size(Fo));any(apo~=apo0)

 % Check whether new facets are active (have outer points)
ind = find(apo);
Edge = R(ind,:);
afo = zeros(n_new,1);
if Edge~=[]
  for jj=1:n_new
    c_pt = Nrmo(jj,:);
    [c_pt,nn] = max(Edge*c_pt');
    afo(jj) = nn*(c_pt>1);
  end
end

 % Map indices from active to all points
cnt = find(afo);
afo(cnt) = ind(afo(cnt));

 % Make a new list of facets and normals - combine
 % new facets and the old ones to which the current point
 % is internal
ind = find(~i_fac);  % Find remaining facets
Fo = [Fo; Fi(ind,:)];             % Facets
Nrmo = [Nrmo; Nrmi(ind,:)];       % Normals
afo = [afo; afi(ind)];  % "Active facets" mask

 % Sort output so that active facets are first
ind = [find(afo); find(~afo)];
Fo = Fo(ind,:);
Nrmo = Nrmo(ind,:);
afo = afo(ind,:);

