function  fi = invdisti(R,Ri,f,opt)
% INVDISTI Inverse distance interpolation.
%	FI = INVDISTI(R,RI,F) Interpolates multi-
%	dimensional set with coordinates R (N by D) 
%	where N is the number of points and D - 
%	dimension and values F to points with
%	coordinates RI.
%	Returns interpolated values FI at points RI.
%
%	FI = INVDISTI(R,RI,F,W) allows also W -
%	vector of coefficients (relative weights)
%	for combining results from interpolation
%	with different power law in the form:
%	FI = F1*W1+F2*W2+ ..., where F_i - estimates
%	of interpolation with weiths proportional to
%	R^(-D-i), (D - dimension).
%	Default W = 3 which is equivalent to W=[1 1 1]
%	is an equal-weight combination of estimates
%	from R^(-D-1), R^(-D-2), R^(-D-3) laws.
%		
%	Uses inverse distance interpolation method.	

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/20/95

 % Defaults and parameters .............
tol = 1e-10;  % Substitute for zero distance
l_ch = 200;   % Chunk length
opt_dflt = 3; % 3 estimates (r^(-d-1), r^(-d-2),
              % r^(-d-3)


 % Handle input ........................
if nargin==0, help invdisti, return, end
if nargin<3
  error('  Not enough input arguments')
end
if nargin<4, opt = opt_dflt; end

 % Sizes and dimensions ................
sz = size(R);
szi = size(Ri);
if sz(1)==szi(1) & sz(2)~=szi(2)
   R = R'; Ri = Ri';
elseif sz(1)==szi(2) & sz(2)~=szi(1)
   R = R';
elseif sz(2)==szi(1) & sz(1)~=szi(2)
   Ri = Ri';
end
[npb,d] = size(R);
[npi,d] = size(Ri);

 % Option .........
if length(opt)>1
  comp_coef = opt(:);
else
  opt = max(opt,1);
  comp_coef = ones(ceil(opt),1);
end
comp_coef = comp_coef/sum(comp_coef); 
n_comp = length(comp_coef);

szf = size(f);
is_trp = 0;
if szf(2)==npb & szf(1)~=npb,
  f = f'; is_trp = 1;
end

 % Number of chunks
n_chi = ceil(npi/l_ch);
n_chb = ceil(npb/l_ch);


 % Initialize summation matrices ..........
Sf = zeros(n_comp,npi); Sw = Sf;

 % Begin calculating distance matrices between
 % chunks of basis points and chunks of interpolation
 % points
 % For each chunk find distance matrix **************
for ji = 1:n_chi % Chunks of interp. points `````````0

  % Get current chunk
  li = min(ji*l_ch,npi);
  i_chi = (ji-1)*l_ch+1:npi;
  ochi = ones(size(i_chi));

  Rchi = Ri(i_chi,:);
  r2si = sum((Rchi.^2)');

  for jb = 1:n_chb % Chunks of basis points ```````1

    % Get current chunk
    lb = min(jb*l_ch,npb);
    i_chb = (jb-1)*l_ch+1:npb;
    ochb = ones(size(i_chb));

    Rchb = R(i_chb,:);
    r2sb = sum((Rchb.^2)')';

    % D2 - squared distance matrix
    D2 = r2si(ochb,:)+r2sb(:,ochi);
    D2 = D2-2*(Rchb*Rchi');

    ind0 = find(D2<tol);
    D2(ind0) = tol(ones(size(ind0)));
    D2 = 1./D2;

    D = sqrt(D2);
    if d>2, D2 = D2.^(d/2); end

    % For each power law component .........
    for j1 = 1:n_comp
      D2 = D2.*D;
      Sf(j1,i_chi) = Sf(j1,i_chi)+f(i_chb)'*D2;
      Sw(j1,i_chi) = Sw(j1,i_chi)+sum(D2);
    end

  end  % End chunks of basis points ''''''''''''''1

end  % End chunks of interpolation points '''''''''''0

 % Interpolation itself ....................
Sf = (Sf./Sw)';    % Divide by weights
fi = Sf*comp_coef;

 % Transpose if necessary ..................
if is_trp, fi = fi'; end

