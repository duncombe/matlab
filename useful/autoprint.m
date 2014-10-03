function filename=autoprint(fn)
%AUTOPRINT - print a figure to a file with a unique name	
% 
%USAGE - filename=autoprint(fn)
%
%EXPLANATION -	a requirement to print a figure quickly without
%	fussing about what to call it or whether a file of the
%	same name already exists.
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.5 $
%	$Date: 2011-12-12 13:46:14 $
%	$Id: autoprint.m,v 1.5 2011-12-12 13:46:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
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
%A

if exist('fn','var')~=1, fn=[]; end;
if isempty(fn), fn=gcf; end;

for i=1:length(fn),
    filename{i}='/dev/null';
    while exist(filename{i})==2, 
        filename{i}=['fig_' sprintf('%4d%02d%02dT%02d%02d%09.6f',clock) '.eps'];
    end;

    print(fn(i),'-depsc',filename{i})
end

if length(filename)==1, filename=filename{i}; end

return

