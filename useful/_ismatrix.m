function answer=ismatrix(varargin)
% ISMATRIX      matrix object test
% Returns a vector of logicals (1/0) for which input objects are
% matrices, and which are not (empty, single, vector and arrays). 
%
% answer = ismatrix(varargin)
% 
% See also ISVECTOR ISSINGLE ISARRAY

%Time-stamp:<Last updated on 02/05/28 at 11:43:55 by even@gfi.uib.no>
%File:<d:/home/matlab/ismatrix.m>

for i=1:length(varargin)
  size(varargin{i});
  if length(ans)<=2 & all(ans>1)	% varargin{i} is a matrix
    answer(i)=1;			
  else
    answer(i)=0;
  end
end
answer=logical(answer);