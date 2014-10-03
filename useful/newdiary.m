function  [NDF,ODS]=newdiary(NDF)	% {{{
%NEWDIARY -  close the old diary and opena a new one with default name	
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-11-30 
%	$Revision: 1.1 $
%	$Date: 2012-11-30 13:10:38 $
%	$Id: newdiary.m,v 1.1 2012-11-30 13:10:38 duncombe Exp $
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

if exist('NDF','var')~=1, NDF=[]; end
if isempty(NDF)
	NDF=[ getenv('HOME') filesep '.matlab.' datestr(now,'yyyymmdd-HHMMSS.FFF') '.log'];
end

ODS=get(0,'diary');
DF=get(0,'diaryfile'); 

disp([DF ' closed']);
diary off;
diary(NDF);

