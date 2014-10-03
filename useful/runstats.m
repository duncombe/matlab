function varargout = runstats(v,N,param,stat)
%RUNSTATS - 	running mean and std deviation of a series
% 
%USAGE -	 [mn,st]=runstats(v,N,param)
%
%EXPLANATION -	mn - N point running mean (median)
%		st - std deviation of N-point running mean (or
%		MAD)
%		v - data vector
%		N - filter size
% 		param - parametric or robust statistics ('param'
% 		returns mean and stddev; or 'robust' returns
% 		median and interquartile range; or 'percentiles'
% 		returns median and 25 and 75 percentiles)
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2001-02-12
%
%PROG MODS -
%   2007-09-11
% 	problem: N must be odd to work.
%   2011/01/14 
% 	This uses a non-vectorized algorithm for creating the
% 	working matrix. Now pre-allocating the working matrix,
% 	instead of growing it. Runs much quicker for large
% 	vectors. Not sure why, but growing v (in line MARKED
% 	below) works quicker than preallocating v as well as V
%  2011/01/19 
% 	Add robust statistics
%  2012-07-18 
% 	formalize warning, giving it a MSGID identifier
%
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
%
if nargout>2, error('Too many output arguments'); end;

if exist('stat')~=1, stat=[]; end;
if isempty(stat), stat={'location','variability'}; end;

if exist('param')~=1, param=[]; end;
if isempty(param), param='param'; end;
if ~any(strcmp(param,{'param','percentiles','robust'})), 
	error('Choice of statistics is "param", "percentiles", or "robust"')
end;

[m,n]=size(v); 
% if v is a long row, make it a tall column
if m==1, v=v.'; end;
len=max(n,m);
% if N is even, then N++, print warning
if mod(N,2)==0,
       N=N+1; 
       warning('useful:runstats:filterWindowEven', ...
	['filter window must be odd, setting N=', num2str(N)]);
end;
% nf is the window size 
nf=2.*(N-1);
% pad top and bottom with shaped windows
v=[ 2.*v(1)-v(nf+1:-1:2) ; v ; 2.*v(len)-v((len-1):-1:(len-nf)) ];
% v=[ zeros(N-1,1) ; v ; zeros(N-1,1) ];
%
% V=v;
V=NaN.*ones(length(v)+N-1,N);
V(1:length(v),1)=v;
for i=2:N,
	v=[NaN;v]; % MARKED: growing v is faster than preallocating and shifting it!
	% [vm,vn]=size(V);
	% V=[V; ones(1,vn).*NaN];
	% V=[V v];
	V(1:length(v),i)=v;
end;

% Calculate the statistics
if strcmp(param,'robust'),
	if any(strcmp(stat,'location')), mn=median(V.'); end;
	% iqr and mad from matlab stats toolbox take a v. long
	% time to run with big data sets (500k+ data points). 
	% Simple myiqr function is quicker, because I'm not
	% concerned about niceties here. myiqr sorts the columns
	% and extracts the 25 and 75 percentiles. Difference is
	% iqr. Return IQR as the statistic f variability.
	if any(strcmp(stat,'variability')), st=myiqr(V.'); end;
elseif strcmp(param,'percentiles'),
	if any(strcmp(stat,'location')), mn=median(V.'); end;
	if any(strcmp(stat,'variability')), st=myqrtl(V.'); end;
else
	if any(strcmp(stat,'location')), mn=mean(V.'); end;
	if any(strcmp(stat,'variability')), st=std(V.'); end;
end; 

lop=(N-1)./2;
if any(strcmp(stat,'location')), 
	mn([1:(nf+floor(lop)) len+nf+ceil(lop)+(1:(nf+ceil(lop)))])=[]; 
	% if v was a long row make the output also a long row
	if n==1, mn=mn.'; end;
end;
if any(strcmp(stat,'variability')), 
	st(:,[1:(nf+floor(lop)) len+nf+ceil(lop)+(1:(nf+ceil(lop)))])=[];
	% if v was a long row make the output also a long row
	if n==1, st=st.'; end;
end;

if nargout==2,
	varargout={mn,st};
elseif any(strcmp(stat,'location')),
	varargout={mn};
elseif any(strcmp(stat,'variability')),
	varargout={st};
end;

return;

function y=myiqr(x)
% simple interquartile range: returns iqr of columns of x
[m,n]=size(x);
X=sort(x);
i=round(size(X,1).*[0.25, 0.75]);
y=diff(X(i,:));
return;

function y=myqrtl(x)
% returns 25 and 75 percentiles of columns of x
[m,n]=size(x);
X=sort(x);
i=round(size(X,1).*[0.25, 0.75]);
y=X(i,:);
return;

