function [b, rmse, inx] = iregress(x, y, tol, order, iterlimit, conlimit)

% IREGRESS iterative Model I least squares solution.  Robust wrt NaN.
%
% [B,RMSE] = IREGRESS(X,Y,[TOLERANCE],[ORDER],[ITERLIMIT],[CONLIMIT]);
%
%           IREGRESS estimates y = b*X for b where the model
%           is y_est = b(1)*x^n + b(2)*x^(n-1) + .... + b(n+1)
%
%           IREGRESS iterates the regression up to ITERLIMIT
%           times until CONLIMIT is reached.
%
% INPUT ARGUMENTS
%           X:  THE X-DATA
%           Y:  THE Y-DATA
%           TOLERANCE: tolerance for envelope of "good" observations
%
%             y_est - RMSE*TOL < y < y_est + RMSE*TOL
%
%           ORDER: order of the model.
%             0 for a constant model (y = b(1))
%             1 for a linear model (y = b(1)*x + b(2))
%             2 for a quadratic model (y = b(1)*x^2 + b(2)*x + b(3))
%             etc
%
%           ITERLIMIT: limit of iterations (default = 1000)
%           CONLIMIT: limit of convergence (default = eps)
%
% OUTPUT ARGUMENTS
%           B: model solution
%           RMSE: rms error of the model applied to all data
%                 (not only those used in model determination).
%           INX:  index of points used in determination of B.
%
%
% For the solution to the archetypical (non-iterative) linear least
% squares equation, use IREGRESS with a tolerance of Inf and an
% iteration limit of 1.
%
% SEE ALSO: lsq
%
% Deirdre Byrne, dbyrne@umeoce.maine.edu, 2004/04/01

if nargin < 2
  disp('usage: iregress(x,y,[tolerance],[model order],[iteration limit],[convergence limit])')
  return
end
  
if nargin < 6
  conlimit = eps;
  disp('iregress: convergence limits set to eps')
  if nargin < 5
    iterlimit = 1000;
    disp('iregress: iteration limit set to 1000')
    if nargin < 4
      order = 1;
      disp('iregress: using linear (order 1) model')
      if nargin < 3
	tol = 1;
	disp('iregress: tolerance 1 std. err.')
      end
    end
  end
end

x = x(:); y = y(:);
if length(x) ~= length(y)
  disp('IREGRESS: size(x) ~= size(y)')
  return
end

% find good data points
i = find(~isnan(x) & ~isnan(y));

% create X matrix of desired order for model
X = ones(length(x),1);
for n = 1:order
  X = [x.^n X];
end

% perform initial regression
[Q, R] = qr(X(i,:), 0);
b = R\(Q'*y(i));

% now recurse until convergence or limit of iterations
iter = 1;
converged = 0;
while iter < iterlimit
  old_b = b;
  
  % now compute model
  model = zeros(length(x),1);
  for n = 1:order
    model = model + X(:,n)*b(n);
  end
  model = model + b(order+1);
  
  % now compute stderr (normalized by N-1)
  stderr = std(y(i) - model(i),0);
  
  % from this, the lower and upper limits for
  % boundaries of "good" data (scaled by the tolerance)
  llim = model-stderr*tol;
  ulim = model+stderr*tol;

  % find data that fall within the boundaries and are non-NaN
  i = find(y > llim & y < ulim & ~isnan(x));

%%%%%%% *****************************************
% points outside are bad and must be discarded
  j = find(y <= llim | y >= ulim | isnan(x) | isnan(y));
  x(j)=j.*nan;
%%%%%%% *****************************************
  
  if ~isempty(i)
    [Q, R] = qr(X(i,:), 0);
    b = R\(Q'*y(i));
  else
    disp('Warning: no valid points left within range. Ceasing iteration.')
    break
  end


  if all(abs(old_b - b) < conlimit)
    converged = 1;
    break
  end
  
  iter = iter + 1;
end

if nargout > 1
  % preserve selected points used in model
  inx = i;
  i = find(~isnan(x) & ~isnan(y));
  model = zeros(length(x),1);
  for n = 1:order
    model = model + X(:,n)*b(n);
  end
  model = model + b(order+1);
  rmse = std(y(i) - model(i),0);
end

if ~converged
  disp('Warning: iteration did not converge')
end

return
