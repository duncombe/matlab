function  [DF,ODS]=diarize(DS)	% {{{
%DIARIZE - flush the diary and return the diary file	
% 
%USAGE -	[DF,ODS]=diarize(DS)
%
%EXPLANATION -	DF - diary file name
% 		ODS - original diary state
% 		DS - leave with diary in this state (on/off), or open a new
% 		diary with this filename. 
% 		After running diarize the diary will be on (default) or in
% 		the state DS. Primary use is to force a write to the diary
% 		file, for which the command without arguments is sufficient. 
%
%SEE ALSO -	DIARY
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	c. 2012-03-09
% 
%	$Revision: 1.4 $
%	$Date: 2012-11-30 13:10:38 $
%	$Id: diarize.m,v 1.4 2012-11-30 13:10:38 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 2012-07-20 
% 	fleshed out the arguments and returns
% 2012-07-23 
% 	cleaned up the help text
% 2012-11-30 
% 	explain in help text more fully
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

if exist('DS','var')~=1, DS=[]; end
if isempty(DS), DS='on'; end

ODS=get(0,'diary');
DF=get(0,'diaryfile'); 

diary off;
diary(DS);

