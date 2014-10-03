function mn = runmean(v,N,param)
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
% 		median and interquartile range)
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

% call runstats appropriately

if exist('param')~=1, param=[]; end;
if isempty(param), param='param'; end;
if ~any(strcmp(param,{'param','robust'})), 
	error('Choice of statistics is "param" or "robust"')
end;
mn=runstats(v,N,param,'location');

return;
