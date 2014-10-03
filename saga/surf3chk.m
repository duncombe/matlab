function [R,cd,fc,ec] = surf3chk(d,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
% SURF3CHK  Input processing for "triangulated surface" plots.
%
%	Input:  up to 10 arguments
%
% 	Output:
%	R   - Coordinates matrix
%	CD  - Color data
%	FC  - Face color
%	EC  - Edge color

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/08/95

 % Defaults ................................................
cd = [];                              % Color data
fc = 'flat';                          % Facecolor
ec = get(0,'defaultpatchedgecolor');  % Edgecolor
nx = 0; ny = 0; nz = 1;               % Coloring axis (vertical)
is_rad = 0;                           % "Radial" mode

 % Key words.........................
Flags = str2mat('facecolor','edgecolor','interp','flat',...
        'none','radial');

ni = nargin-1;

 % Process all input arguments for size and string/number ..
sz = zeros(ni,2);
iss = zeros(ni,1);
for jj = 1:ni
  c_arg = eval(['a' num2str(jj)]);
  sz(jj,:) = size(c_arg);
  iss(jj) = isstr(c_arg);
end

 % Find string arguments ...................................
ii = find(iss);
of = ones(size(Flags,1),1);
for jj = 1:length(ii)
  jc = ii(jj);
  c_arg = eval(['a' num2str(jc)]);
  len = min(length(c_arg),length(flag));

  if len==1
    if any(c_arg=='rgbycmwk'), ec = c_arg; end

  else
    % Find coincidences with keywords
    A = Flags(:,1:len)==c_arg(of,1:len);
    nc = find(all(A'));
    if nc==3, fc = 'interp';
    elseif nc==4, fc = 'flat';
    elseif nc==5, fc = 'none';
    elseif nc==6, is_rad = 1;
    elseif nc==1, fc = eval(['a' num2str(jc+1)]);
    elseif nc==2, ec = eval(['a' num2str(jc+1)]);
    end

  end  % End if 

end  % End for 


 % Find arguments for view-vector ..........................
nrm = [];          % Initialize
ii = prod(sz')';   % Find vectors of 2 or 3 elements
ii = (ii==2 | ii==3) & ~iss;
ii = find(ii);
if ii~=[]
  ii = max(ii);
  c_arg = eval(['a' num2str(ii)]);
  nrm = c_arg(:)';
  iss(ii) = 1;
end


 % Combine coordinates input into R matrix .................
ii = find(~iss);
sz = sz(ii,:);
R = [];            % Initialize
for jj = 1:length(ii)
  c_arg = eval(['a' num2str(ii(jj))]);
  if diff(sz(jj,:))<0, c_arg = c_arg'; end
  R = [R; c_arg];
end
if size(R,1)<3, d = 2; end


 % Calculate colors ........................................

 % If view-vector is 2 number it is in [AZ EL]
 % format; transform it to cartesian - [NX,NY,NZ]
if max(size(nrm))==2
  nrm = nrm*pi/180;
  [nx,ny,nz] = sph2cart(nrm(1),nrm(2),1);

elseif max(size(nrm))==3    % [NX,NY,NZ] format
  nx = nrm(1); ny = nrm(2); nz = nrm(3);

end

 % Coordinate along color direction .........
cd = R(1,:)*nx+R(2,:)*ny;
if size(R,1)>2, cd = cd+R(3,:)*nz; end

 % If Cdata input directly ..................
if size(R,1)>3, cd = R(3+d:size(R,1),:); end

 % If "radial" coloring mode ................
if (d==2 & ~nx & ~ny), is_rad=1; end
if is_rad
  [R1,cd] = mapsph(R(1:d,:)',-.8);  % Map on a sphere
  lim = [min(cd) max(cd)];
  cd = cd';
end

 % If facecolor is "none" make sure edges are visible
if strcmp(fc,'none') & ~any(ec), ec = 'w'; end

