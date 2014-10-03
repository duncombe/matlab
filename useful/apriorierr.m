function [aprioriX, NX, dp] = apriorierr(param, X, deltap)
%  --------------------------------------------------------------
%  function [apriori_error] = apriori(parameter, data, [deltap]);
%
%  param   Independent organizing parameter (e.g, tau): [1xN]
%  data    Data matrix (e.g., salinity or temperature) [MxN]
%  deltap  values of the parameter difference at which to make
%          the calculation of error.  If deltap is not specified
%          the default is 50 evenly spaced values between
%          10*min(diff(param)) and max(diff(param.
%
%  This finds the station pairs that meet the difference range and 
%  computes the a priori error as:
%
%  apriori^2 = 1/2 <(Ti-Tj)^2>   for the limit as the difference
%                                in param goes to zero.
%
%  --------------------------------------------------------------

disp(nargin)
if nargin < 3
  disp('usage apriorierr(parameter, data, [deltap])')
  return
end

param = param(:); N = length(param);

if size(X, 2) ~= N
  disp('number of columns of data must equal length(parameter)')
  return
end

% strip out nulls in parameter space
j = find(~isnan(param));
param = param(j);
X = X(:,j);
N = length(param);

% now substitute zeros for nan's in data matrix
% this allows computations to proceed much more
% quickly.
j = find(isnan(X));
X(j) = 0;

% calculate the difference between each param_i and all param.
% The way this is done, differences will be reflected above and
% below the diagonal, with a sign change:
%
% pdiff(1,1) = param(1) - param(1) == 0
% pdiff(1,2) = param(1) - param(2)
% pdiff(2,1) = param(2) - param(1),  == -pdiff(1,2)
%
pdiff = param*ones(1,N) - ones(N,1)*param';

% we are only interested in the absolute value of this difference
% thus we need only keep half of this matrix, the upper triangular
% part.
pdiff = abs(pdiff);
pdiff = triu(pdiff);
indx = find(pdiff > 0);
pdiff = pdiff(indx);

if nargin < 3
  % generate a vector of param differences to examine
  minfactor = 10;
  deltap = [min(pdiff)*minfactor max(pdiff)];
  deltap = deltap(1):diff(deltap)/50:deltap(2);
  dp = deltap;
end

for i = 1:length(deltap)
  j = find(pdiff <= deltap(i));
  k = indx(j);
  % convert from single index back to row, column
  % row and column index are simply the two station numbers
  % to difference
  [rc] = i2rc(k,[N N]);
  % At a given depth:
  % apriori^2 = 1/2 <(Xi-Xj)^2>  for the limit
  % as the difference in param goes to zero.
  Xdiff=X(:,rc(:,1))-X(:,rc(:,2));
  n = (X(:,rc(:,1)) ~= 0) & (X(:,rc(:,2)) ~= 0);
  % zero out differences where one value was not valid!
  Xdiff = Xdiff.*n;
  Xap = zeros(size(Xdiff,1),1);
  if size(rc,1) > 1
    % calculate the mean of every row of Xdiff^2
    NX(:,i) = sum(n')';
    Xap = sum( ( Xdiff .^2)')' ./ NX(:,i);
    Xap=0.5 * (Xap);   
  elseif size(rc,1) == 1
    NX(:,i) = n;
    Xap = 0.5 * (Xdiff.^2) ./ n;
  else
    NX(:,i) = zeros(size(Xap,1),1);
  end
  aprioriX(:,i) = sqrt(Xap);
end
return;

