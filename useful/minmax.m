function y = minmax(x)
% MINMAX      find the minimum and maximum of a vector or a matrix
%             Robust with respect to NaN.
%
% USAGE       MINMAX(x)
%

%  Deirdre Byrne: 18 Jan 1995

if nargin == 1
  if any(any(isnan(x)))
    i = find(~isnan(x));
    y = [min(min(x(i))) max(max(x(i)))];
  else
    y = [min(min(x)) max(max(x))];
  end
end
clear x i
return;
