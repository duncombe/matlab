function Tlist=alldepfuns(Top) % {{{
%ALLDEPFUNS - 	Find function dependencies, ignoring Mathworks toolboxes
% 
%USAGE -	Tlist=alldepfuns(Top)
%
%EXPLANATION -	Top - function name to examine (string)
% 		Tlist - list of dependencies (cell array of strings)
% 
% 		Relies on being able to determine the Matlab source
% 		directories from the shell environment variable MATLAB
% 		using GETENV.
% 		To return Mathworks functions called use DEPFUN
%
%SEE ALSO -	DEPFUN, GETENV
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-08-06
% 
%	$Revision: 1.5 $
%	$Date: 2013-03-20 09:19:48 $
%	$Id: alldepfuns.m,v 1.5 2013-03-20 09:19:48 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2013-03-20 
% 	Edits to help text (on R/V Endeavor)
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



% Top='doallthefigures.m';

tlist=depfun(Top,'-toponly','-quiet');

% discard the cell that contains the top level script
J=regexp((tlist),Top); K=find(cellfun(@isempty,J));
Tlist=tlist(K);

% generate a full Top
K=find(~cellfun(@isempty,J));
Top=tlist(K);

% discard cells that contain Mathworks functions
MATLAB=getenv('MATLAB');
J=regexp(Tlist,MATLAB); K=find(~cellfun(@isempty,J));
Tlist(K)=[];

CTlist=Tlist;

for i=1:length(Tlist),
	Slist=alldepfuns(Tlist{i});
	CTlist=[CTlist; Slist];
end

% add back in Top
CTlist=[Top; CTlist];

% cull duplicates and sort
Tlist=unique(CTlist);

