function LEVEL=ntasadcpdata(DATA,depth) % {{{
%NTASADCPDATA -  extract one depth level from ADCP data structure 
% 
%USAGE -	LEVEL=ntasadcpdata(DATA,depth) 
%
%EXPLANATION -	DATA : ADCP data structure with many depth bins	
%		depth : depth bin to extract
% 		LEVEL : ADCP data structure with only one depth bin
% 
%SEE ALSO -	ntascheckmat
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-08-11
%	$Revision: 1.5 $
%	$Date: 2012-02-28 14:17:18 $
%	$Id: ntasadcpdata.m,v 1.5 2012-02-28 14:17:18 duncombe Exp $
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


DATA=ntascheckmat(DATA);

if ~isfield(DATA,'depth')
	if isfield(DATA,'Depth'), 
		DATA.depth=DATA.Depth; 
	else
		error('No depth field');
	end
end

% ensure that DATA.depth is the right shape
[m,n]=size(DATA.depth); 
if n==1, DATA.depth=DATA.depth.'; end

N=length(DATA.depth);
if N==1, LEVEL=DATA; warning('Only one depth to extract from'); return; end

% ensure we can operate with what we are given
% ensure only one depth is returned

if exist('depth','var')~=1, depth=[]; end
if isempty(depth), depth=DATA.depth(1); end

if length(depth)==1, 
	I=find(DATA.depth==depth);
elseif length(depth)==2,
	I=between(DATA.depth,depth);
end

if isempty(I), 
	warning(['Depth ' num2str(depth) ' does not exist. ']);
	[junk,I]=min(abs(DATA.depth-depth));
	depth=DATA.depth(I);
	disp(['Closest depth is ' num2str(depth) '. Using that.']);
else
	I=I(1);
end

fn=fieldnames(DATA);

for i=1:length(fn),
	% if the DATA.(fn) is a structure, keep it as is
	if isstruct(DATA.(fn{i})), LEVEL.(fn{i})=DATA.(fn{i}); 
	% if the DATA.(fn) is a string, keep it as is 
	elseif ischar(DATA.(fn{i})), LEVEL.(fn{i})=DATA.(fn{i}); 
	else
	    % if the DATA.(fn) has the same length as (depth), extract the level
	    if size(DATA.(fn{i}),2)==N, LEVEL.(fn{i})=DATA.(fn{i})(:,I); 
	    elseif size(DATA.(fn{i}),1)==N, LEVEL.(fn{i})=DATA.(fn{i})(I,:); 
	    else, LEVEL.(fn{i})=DATA.(fn{i}); 
	    end
	end
end

return
	

