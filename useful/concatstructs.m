function  A=concatstructs(varargin)	% {{{
%CONCATSTRUCTS - concatenate inconsistent structure arrays
% 
%USAGE -	A=concatstructs(B,C,...)
%
%EXPLANATION -	B,C,... - structure arrays that may have differing
%			fieldnames. Function may be called with any number
%p			of arguments.
% 		A - structure array that concatenates B,C,... filling
% 			fields that do not exist in the other arrays with
% 			empty elements. The order of the fields is taken
% 			from the first argument.
% 			E.g.,	B = 1x4 struct array with fields: d e
% 				C = 1x3 struct array with fields: f e g
% 			then 	A = 1x7 struct array with fields: d e f g 
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-11-25 
%	$Revision: 1.1 $
%	$Date: 2012-12-10 15:06:02 $
%	$Id: concatstructs.m,v 1.1 2012-12-10 15:06:02 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
% }}}

% License {{{
% -------
%
%     This program is free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of
% the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be
% useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public
% License along with this program.  If not, see
% <http://www.gnu.org/licenses/>.
% 
% See accompanying script gpl-3.0.m
% 
% }}}


% varargin


if nargin>2
	% A=concatstructs((varargin{2:end}));
	A=concatstructs(varargin{1},concatstructs(varargin{2:end}));
elseif nargin==2

	B=varargin{1};
	C=varargin{2};

	bfn=fieldnames(B);
	cfn=fieldnames(C);

	dfn=setdiff(bfn,cfn); for i=1:length(dfn), [C.(dfn{i})]=deal([]); end
	dfn=setdiff(cfn,bfn); for i=1:length(dfn), [B.(dfn{i})]=deal([]); end

	A=[B,orderfields(C,B)];

else
	warning([ mfilename ' should be called with more than 1 argument' ]);
	A=varargin{1};
end

