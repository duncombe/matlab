function so = callchk(si,name)
% CALLCHK  Puts expression or function name into
%	a sform to be EVALuated.
%	SO = CALLCHK(SI,NAME)

%	Called from OBJMAP, KRIGING.

%  Copyright (c) 1995 by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	05/25/95

if nargin<2, name = []; end

 % Check if a function or expression
is_fun = exist(si);
is_fun = is_fun & any(isletter(si));

if is_fun          % .. Function

  so = [si ';'];

else               % .. Expression

  % Change to array operations (.* , .^, ./) :
  n_ins = si=='*' | si=='/' | si=='^';
  nn = find(n_ins);
  n_ins = cumsum(n_ins+1);
  so = zeros(size(max(n_ins)));
  so(n_ins) = si;
  so(~so) = '.'*ones(size(nn));

  % Add output and semicolon
  so = setstr([so ';']);

end

if name~=[], so = [name '=' so]; end
