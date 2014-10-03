function [STN,GRD,POS,TIM,allMLDATA,topMLDATA,botMLDATA,STP]=...
			mixlayer(expr,limit,range)
%MIXLAYER - 	Water column mixed layer determination and characterisation.
% 		Finds data in s87 files.
%		Mixed layer determination is done by traversing the water
%		column, and for each depth, A, find the depths above, B,
%		and below, C, at which the parameter value is no longer within
%		the chosen limit. The mixed layer extent for depth A is the
%		difference between B and C. The mixed layer depth for the
%		water column is the maximum of all ML. Results reported with
%		the station number, grid number, position, and datetime for
%		reference with the mean temperature of the mixed layer, the
%		standard deviation of temperatures in that layer, the vertical
%		extent of the mixed layer, the depth above, and the depth
%		below. Note that the range of values of the parameter are 
%		within 2*limit.
% 
%USAGE -	[STN,GRD,POS,TIM,allMLDATA,topMLDATA,botMLDATA]=...
%			mixlayer(expr,limit,range)
%
%EXPLANATION -	expr - regex for filenames
%		limit - limits for determining mixed layer [0.01 oC]
%		range - upper and lower limit of water depth to	consider
%		STN - station numbers
%		GRD - grid numbers
%		POS - position (complex)
%		TIM - date/time vector
%
%		The following variables returning mixed layer results have 
%		the form [ML,PRtop,PRbtm,T,V]
% 		these are vertical extent of the ML, depth at the
% 		top, depth at the bottom, mean temperature,
% 		variance.
%
%		allMLDATA - most prominent mixed layer in whole water column
%		topMLDATA - most prominent mixed layer in the upper half
%		botMLDATA - most prominent mixed layer in the lower half
%
%SEE ALSO -	S87LOADS, MLD, DIRLIST
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2001-10-17
%
%PROG MODS -	2001-11-23 (Afr163) Cosmetics
% 		2008/09/09 - return also the STP data, as a cell,
% 		this so we know what we dealing with.
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

if ~exist('limit'),
	limit=[];
end;
if isempty(limit),
	limit=0.01;
end;

if ~exist('expr');
        expr='*.s87'; 
else 
        if isempty(expr), 
                expr='*.s87'; 
        end; 
end;
if exist('range')~=1, range=[]; end;

DIR=dirlist(expr);
topMLDATA=[]; botMLDATA=[]; allMLDATA=[];
% not backward compatible!
POS=[]; TIM=[]; STN=[]; GRD=[]; STP={}; N=0;
if ~isempty(DIR),
    [rec,DIR]=strtok(DIR);
    while ~isempty(rec),
        if ~exist(rec),
	    disp([rec ' not found']);
        else
            more off;
            disp(rec);
            more on;
	    [stp,pos,tim,header,stn,grd]=s87loads(rec);
    
	    % stp has stpo. find mld for each.
	    % S=mld(stp(:,1),limit(1));
	    POS=[POS;pos];
	    TIM=[TIM;tim];
	    if isempty(STN), STN=stn; else STN=str2mat(STN,stn); end;
	    if isempty(GRD), GRD=grd; else GRD=str2mat(GRD,grd); end;

	    [ML,PRtop,PRbtm,T,V]=mld(stp(:,2),stp(:,3),limit,range);

	N=N+1;
	% not backward compatible!
	STP(N)={[stp; NaN.*stp(end,:)]};
	

	% if ~isnan(range),
	% 	I=find(stp(3)>range(1) & stp(3)<=range(2));
	% else
	% 	I=1:size(stp,1);
	% end;
	% MLDATA=[ML,PRtop,PRbtm,T,V];
	% eval([ P(i) '=MLDATA;']);

	    mid=round(length(ML)./2);
	    [x,topML]=max(ML(1:mid));
	    [x,botML]=max(ML(mid:length(ML))); botML=botML+mid-1;
	    [x,allML]=max(ML);

            topMLDATA=[topMLDATA; ...
		ML(topML),PRtop(topML),PRbtm(topML),T(topML),V(topML)];
            botMLDATA=[botMLDATA; ...
		ML(botML),PRtop(botML),PRbtm(botML),T(botML),V(botML)];
            allMLDATA=[allMLDATA; ...
		ML(allML),PRtop(allML),PRbtm(allML),T(allML),V(allML)];

	end;


% Res=['# Mixed Layer Characteristics (Criterion = ' num2str(limit) 'C)' 10 ...
% '# Station Grid Lati Long Date Time MLTemp SDev  MLExti  From  To' 10 ...
% '#                                   (C)    (C)  (dbar) (dbar) (dbar)' 10];
% I=find(PRtop<=100);
% Res=[Res, [ sprintf('%s',[abs(stn),' ',abs(grd)]) ...
%   sprintf(' %0.3f %0.3f',[imag(pos),real(pos)]) ...
%   sprintf(' %04d-%02d-%02d %02d:%02d',[fix(tim(1:5))]) ...
%   sprintf(' %5.2f %5.3f %0.0f %0.0f %0.0f\n', ...
% 	[T(topML),sqrt(V(topML)),ML(topML),PRtop(topML),PRbtm(topML)]) ] ];
% 
% 			% if (size(stp,2)>=4), O=mld(stp(:,4),limit(4)); end;

        [rec,DIR]=strtok(DIR);
    end;
end;

% disp(Res)
return;

