function SHBML=shbml(draw)
%SHBML - 	Loads positions of the SHBML
% 
%USAGE -	SHBML=shbml(draw)
%
%EXPLANATION -	SHBML - positions of St Helena Bay Monitoring Line stations
%		draw - plot on current axes [1|0]
% 		SHBML stations (St Helena Bay Monitoring Line)
% 		SARP stations (Sardine Anchovy Recruit Program)
%		GWB stations (Geoff Bailey low oxygen monitoring
%		stations)
%
%SEE ALSO -	geoplot, asttex
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2004-02-20
%
%PROG MODS -	
%  2008/10/02 CMDR
%	* rearrange the stations in order to emphasize the SHBML,
%	GWB and SARP components.
%  2008/10/06 
% 	* correcting positions
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

% these positions are a repeat, average them
%	-32.7442 16.4333
%	-32.7462 16.4328

SHBML=[
% SHBML line
	-32.7452 16.43305
	-32.7078 16.62
	-32.6628 16.808
	-32.6187 16.9887
	-32.5705 17.2007
	-32.5057 17.4282
	-32.4598 17.6172
	-32.4128 17.8122
	-32.3705 17.9927
	-32.3298 18.1797
	-32.3093 18.2738
	-32.3002 18.3123
	-32.6658 18.0897
	-32.6827 17.7715
% GWB stations
	-34.5637 17.2378
	-34.5393 17.2918
% SARP line
	-34.5192 17.3538
	-34.4920 17.4072
	-34.4743 17.4650
	-34.4523 17.5205
	-34.4262 17.5682
	-34.4257 17.5687
	-34.3997 17.625
	-34.3728 17.6802
	-34.3538 17.7383
	-34.3338 17.7933
	-34.3152 17.85
	-34.2948 17.9122
	-34.2753 17.9652
	-34.2553 18.0207
	-34.2317 18.0757
	-34.2133 18.1303
	-34.1925 18.188
	-34.1728 18.2427
	-34.1555 18.2917 ];

SHBML=fliplr(SHBML);

if exist('draw'),
	hold on; 
	geoplot(SHBML,'*');
	% text(LP(:,1),LP(:,2),LS);
	end;
return;

