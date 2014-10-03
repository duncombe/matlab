function  A = standardize(B,dim,mn) 	% {{{
%STANDARDIZE - subtract mean and divide by  standard deviation
% 
%USAGE -	A = standardize(B,dim,mn) 
%
%EXPLANATION -	B matrix
% 		A standardized matrix
% 		dim dimension along which to operate
% 		mn mean to subtract, calculated if not given
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-05-16 
%	$Revision: 1.1 $
%	$Date: 2012-05-17 12:39:54 $
%	$Id: standardize.m,v 1.1 2012-05-17 12:39:54 duncombe Exp $
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

n=size(B);

if exist('dim','var')~=1, dim=[]; end
if isempty(dim), dim=1; end;
if dim==0, B=B(:); dim=1; end


if exist('mn','var')~=1, mn=[]; end
if isempty(mn), mn=nanmean(B,dim); end

st=nanstd(B,0,dim);

N=ones(1,length(n));
N(dim)=n(dim);

A=(B-repmat(mn,N))./repmat(st,N);


