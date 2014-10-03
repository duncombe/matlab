function Mf = locfilt(M,arg2,arg3,arg4,arg5,arg6,arg7,arg8)
% LOCFILTR   Local 2-dimensional filtering of a matrix.
%	Performs block-processed linear or non-linear 2-d
%	filtering.
%	MF = LOCFILT(M,F)  Convolves matrix M with filter matrix F
%	( size(F) presumed much smaller than size(M) ).
%	MF = LOCFILT(M,[P Q],FUN)  performs nonlinear filtering
%	using function FUN (string) with filter window size P by Q.
%	Function FUN must have syntax V=FUN(A): accept matrix input A,
%	process it column-wise and return row vector V (can be a 
%	function such as MAX, MEAN, MEDIAN etc.).
%
%	MF = LOCFILT(M,P,'FUN') uses square window of size P.
%	MF = LOCFILT(M,'FUN') uses default window size 3 by 3.
%	MF = LOCFILT(M,[P Q],'FUN',ARG1,ARG2,...) allows to pass
%       additional arguments (up to 5) to function in the
%	form FUN(X,ARG1,ARG2,...), where X is formed out of block
%	of matrix M: each column of A consists of values of M within
%	a filter window around some element of M.
%
%	MF = LOCFILT(...,METHOD,...) also allows to choose the method
%	of treating the edges of the matrix M. The following methods
%	are available:
%	'shifted'  -  filter window is shifted towards the interior:
%	for example the filter window of the size [3 4] for M(1,1)
%	is M(1:3,1:4).
%	'padded'   -  edges are padded with 0 for min(M)<1 and 1 for
%	min(M)>=1,
%	'periodic' -  simulates infinite periodic domain.
%	Abbrerviations, such as 'sh','per' are allowed.
%	Default method is 'shifted'.
%
%	Filter window for point M(I,J) consists of portion of M:
%	M(I-FLOOR((P-1)/2):I+FLOOR(P/2),J-FLOOR((Q-1)/2):I+FLOOR(Q/2))
%	e.g. for window size [3 4] and element M(10,10) the filter
%	window is M(9:11,9:12).
%
%	Examples:
%	locfilt(M,5,'median') - 5 by 5 median filter,
%	locfilt(M,[1 2 1; 2 4 2; 1 2 1]/16,'per') - boxcar filter
%	with periodic boundary conditions,
%	locfilt(M,'mean') and  locfilt(M,ones(3)/9)  produce
%	the same results (up to a numerical accuracy).

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	1/20/94, 12/14/94

 % Defaults and parameters ......................................
szfdflt = [3 3];      % Default for filter window size
n_blocks = 32;        % Number of blocks
flagdflt = 'shifted'; % Default for flag

Flags = ['shifted '; 'periodic'; 'padded  '];


 % Handle input ....................................................
if nargin < 2
  error('  Not enough input arguments.')
end

l_fl = size(Flags,2);
n_fl = size(Flags,1);
sza = zeros(nargin,2);
iss = zeros(nargin,1);
fun_arg = 0; filt = 0; fun = []; szf = [];
 % Find FUN and FLAG
for jj = 2:nargin
  iss(jj) = eval(['isstr(arg' num2str(jj) ')']);
  if iss(jj)
    eval(['str=arg' num2str(jj) ';']);
    l_str = length(str);
    l_m = min(l_fl,l_str);
    a = str(ones(size(Flags,1),1),1:l_m)==Flags(:,1:l_m);
    iss(jj) = .5+max(all(a').*(1:n_fl));
  end
end
fnd = min(find(iss>1));
flag = floor(iss(fnd));
iss(fnd) = 0.75*ones(size(fnd));
fnd = min(find(iss==.5));
if fnd~=[]
  eval(['fun = arg' num2str(fnd) ';']);
  fun_arg = fnd;
end
main_arg = max([find(iss==.75); fun_arg; 2]); % Nmb. of main arg.

if fun_arg>2
  if iss(2), szf = szfdflt;
  else, szf = arg2;
  end
else
  filt = arg2;
  szf = szfdflt;
end
if length(szf)==1, szf = [szf szf]; end  % If square
if flag==[], flag = 1; end

 % Compose function call .........
call = [fun '(A'];
for jj = main_arg+1:nargin
  call = [call ',arg' num2str(jj-1)];
end
call = [call ')'];


 % Padded value ..................
minM = min(min(M));
maxM = max(max(M));
if minM>=1&all(floor(M)==M), m_pad = 1;
else, m_pad = 0;
end

 % Sizes .........................
szM = size(M);
if szf == [], szf = size(filt); end
if any(szM<szf)
  error('  Matrix M must be larger than filter window.')
end
lb = max(floor(szM(2)/n_blocks),szf(2));  % Nmb. col in a block
n_blocks = ceil(szM(2)/lb);
Mf = zeros(size(M));  % Initialize output matrix


 % Calculate vectors for margins ................................

 % Top and bottom ...................
oM = ones(szM(1),1);
vM = (1:szM(1))'; vMf = vM;
mg_b = floor((szf(1)-1)/2);
vM(1:mg_b) = mg_b+ones(mg_b,1);
mg_t = floor(szf(1)/2);
vM(szM(1)-mg_t+1:szM(1)) = szM(1)-mg_t+1-ones(mg_t,1);

 % Left and right ...................
mg_l = floor((szf(2)-1)/2);
img_l = (mg_l+1:-1:1)*szM(1);
img_l = img_l(oM,2:mg_l+1);
mg_r = floor(szf(2)/2);
img_r = (1:mg_r)*szM(1);
img_r = img_r(oM,:);

ib = 1:mg_b; it = szM(1)-mg_t+1:szM(1);
il = 1:mg_l; ir = lb-mg_r+1:lb;


 % Calculate indices ..............................................

 % Filter window ....................
of = ones(prod(szf),1);
[ind_fx,ind_fy] = meshgrid(-mg_l:mg_r,-mg_b:mg_t);
ind_fx = ind_fx(:);
ind_fy = ind_fy(:);
ind_f = ind_fx*szM(1)+ind_fy;

 % Block of matrix M ................
ob = ones(1,lb);
obv = ones(1,lb*szM(1));
vb = 0:lb-1;
ind_bx = vb(oM,:)+1;
ind_by = vMf(:,ob);
ind_bx = ind_bx(:)';
ind_by = ind_by(:)';
indM = vb(oM,:)*szM(1)+vM(:,ob);
indMf = vb(oM,:)*szM(1)+vMf(:,ob);
indMf = indMf(:)';

filt = filt(:)';
offset = 0;

 % Perform filtering for each block
for jj = 1:n_blocks    % Begin jj (block counting) `````````````0

  % Calculate offset for a block
  offset0 = offset;
  offset = min((jj-1)*lb,szM(2)-lb);
  offset_c = offset*szM(1);

  % Calculate indices into current block
  if flag == 1  % Shifted .................
    ind_b = indM;
    ind_b(:,il) = indM(:,il)+img_l.*(jj==1);
    ind_b(:,ir) = indM(:,ir)-img_r.*(jj==n_blocks);
    ind_b = ind_b(:)'+offset_c;

    % Index for matrix A for column-wise processing
    Ind = ind_b(of,:)+ind_f(:,obv);

  else        % Periodic or padded ........

    ind_bx = ind_bx+offset-offset0;
    Ind = ind_bx(of,:)+ind_fx(:,obv);
    A = ind_by(of,:)+ind_fy(:,obv);
    if any(jj == [1 2 n_blocks-1 n_blocks])
      ind_mgxl = find(Ind<=0);
      ind_mgxr = find(Ind>szM(2));
      ind_mgyb = find(A<=0);
      ind_mgyt = find(A>szM(1));
    end

    % Translate indices for margins
    Ind(ind_mgxl) = Ind(ind_mgxl)+szM(2);
    Ind(ind_mgxr) = Ind(ind_mgxr)-szM(2);
    A(ind_mgyb) = A(ind_mgyb)+szM(1);
    A(ind_mgyt) = A(ind_mgyt)-szM(1);

    Ind = (Ind-1)*szM(1)+A;    % Composite index
  end

  A = M(Ind);  % Get values of block of M

  % Pad values at margins for "padded" mode .........
  if flag == 3
    A(ind_mgxl) = A(ind_mgxl)*0+m_pad;  % Left
    A(ind_mgxr) = A(ind_mgxr)*0+m_pad;  % Right
    A(ind_mgyb) = A(ind_mgyb)*0+m_pad;  % Bottom
    A(ind_mgyt) = A(ind_mgyt)*0+m_pad;  % Top
  end

  % Now the actual filtering ***********************************
  if fun~=[]         % Nonlinear (call function)
    Mf(indMf+offset_c) = eval(call);
  else               % Linear (convolution)
    Mf(indMf+offset_c) = filt*A;
  end

end    %  End jj (block counting) ''''''''''''''''''''''''''''''0

