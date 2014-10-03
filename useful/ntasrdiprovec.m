function  h=ntasrdiprovec(NTAS,skip)	% {{{
%NTASRDIPROVEC - draws progressive vector diagram of structure 	
% 
%USAGE -	 h=ntasrdiprovec(NTAS,skip)
%
%EXPLANATION -	NTAS - current data structure
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-09-23
%	$Revision: 1.12 $
%	$Date: 2012-05-17 12:39:54 $
%	$Id: ntasrdiprovec.m,v 1.12 2012-05-17 12:39:54 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2012-04-18 
% 	placement of the legend outside east
%  2012-04-20 
% 	provide a skip to plot every skipth bin
%  2012-05-16 
% 	add units to legend
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

if exist('skip','var')~=1, skip=[]; end
if isempty(skip), skip=1; end

NTAS=ntascheckmat(NTAS);

if ~isfield(NTAS,'east'),
	if isfield(NTAS,'East'),
		NTAS.east=NTAS.East;
	end
end

if ~isfield(NTAS,'north'),
	if isfield(NTAS,'North'),
		NTAS.north=NTAS.North;
	end
end

if ~isfield(NTAS,'depth'),
	if isfield(NTAS,'Depth'),
		NTAS.depth=NTAS.Depth;
	end
end

if ~isfield(NTAS,'vel'),
	NTAS.vel=NTAS.north.*1i+NTAS.east;
end;

if any(size(NTAS.depth)==length(NTAS.yday)),
	depth=median(NTAS.depth);
else
	% depth comes sometimes in the WRONG orientation.
	% ensure it is wide.
	% depth=NTAS.depth.';
	depth=NTAS.depth(:).';
end 

depth=round(depth*10)/10;

I=find(depth<0);
if ~isempty(I), 
	NTAS.vel(:,I)=[];
	depth(I)=[];
	warning('Some depth bins are above the surface. Discarded.');
end 

	% cumulative displacement (provec)

	% where there are nans in vel, replace with zero to avoid leaving
	% entire traces unplotted.
	I=find(isnan(NTAS.vel)); NTAS.vel(I)=0+0i;

	% our units of current speed are cm/s (subject to confirmation --
	% confirmed). convert to kilometers. mday is in units of days,
	% therefore 
PV=[ zeros(1,size(NTAS.vel,2));	...
     cumsum((ave(NTAS.vel).*    ...
     repmat(diff(NTAS.mday),1,size(NTAS.vel,2)).*24.*60.*60))./100./1000 ];

% plot only every skip bin
II=length(depth):-skip:1;
% color with a colormap; lose the end value (white)
col=colorcube(length(II)+1); col(end,:)=[];

h=figure; 
	% plot the provecs (uppy-do, so the depths in the legend read
	% shallowest to deepest)
	Hd=plot((PV(:,II))); hold on; 
	% plot the tail as a circle. first point is zero and not treated
	% properly so force it complex by adding complex eps to it
	Ho=plot((PV(1,II)+complex(eps,eps)).','o');
	% plot the head as a dot
	Hp=plot((PV(end,II)),'.');
	% label each head with the depth
	text(real(PV(end,II)),imag(PV(end,II)),[num2str(depth(II).')])

	% graphics handles should be able to be set in one go, and not have
	% to be in a loop, but I can't get it to work.
	for k=1:length(Hd)
		set(Hd(k), 'Color',col(k,:));
	end
	
	axis('equal');
	xlabel('Displacement East (km)');
	ylabel('Displacement North (km)');
	legend([num2str(depth(II).'), repmat(' m',length(II),1)],'location','eastoutside');
	grid off
	xline(0,'k:'); yline(0,'k:');

