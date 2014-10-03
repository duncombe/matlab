function [s]=form(n,f,w)
% FORM -	builds a format specifier of the specified length n
%
% USAGE -	[S]=form(N,f,w)
%		returns (N-1)*(f+w)+f\n
%		default f=%g
%		default w=\t
%

%
% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED - (very long ago, probably around 1994/5)
%	$Revision: 1.6 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: form.m,v 1.6 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
% 
% PROG MODS -	
%  2009/02/25
% 	* expand so that white space can also be
% 	specified
%  2009/04/06 
% 	* treat specific case of LaTeX table
% 
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
% 

nl='\n';
if nargin==1, f='%g'; end;
if nargin<=2, w='\t'; end;
if strcmp(w,'tex'),
	w=' & ';
	nl='\\\\\n';
end;

% fo=[f '\t'];
fo=[f w];
[i,m]=size(fo);
s=[ setstr(reshape( [fo]'*ones(1,(n-1)),1,(n-1).*m)) f nl ];
return;

