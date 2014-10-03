function [stp, pos, tim, stn] = seasofts (str)
% SEASOFTS - 	loads data from seasoft ascii file into s,t,p matrix
%
% USAGE - 	[stp, pos, tim] = seasofts(str);
% 
% EXPLANATION -	stp:	matrix of [ salt, temp, pres ];
%		pos:	position (complex, pos = longitude+sqrt(-1).*latitude )
%
% PROGRAM - 	MATLAB code by c.m.duncombe rae, 94-12-01, sfri & ldeo
% PROG MODS	94-12-20: change to give header instead of variables
%		95-03-13: return s t p in matrix
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

% str		: string for s87 data file name
% fidd		: handle to str (s87 file containing data)
% te 		: temperature data (raw from datafile)
% pr		: pressure (raw from datafile)
% sa		: salinity (raw from datafile)
% de		: depth (raw from datafile)
% rec		: string record for data from s87 datafile
% nvars		: number of variables in s87 file
% vars		: variables in s87 file
% fspec		: format specification for data input from s87 file

% get data, use seasoftn
	
	% [D,vars,pos,header,tim,stn]=seasoftn(str);
    try
	[D,vars,pos,tim,stn]=seasoftn(str);
    catch
        disp(str)
        rethrow(lasterror);
    end

% put the data into individual vectors

	nvars=size(vars,1);

	clear te pr sa de ox co 
	for ii = 1:nvars,
		eval( [ vars(ii,:) '= D(:,ii);']);
		% vars(ii,:)
	end;

	if exist('sa','var')~=1, 
		if exist('co','var')==1
			sa=sw_salt(co/sw_c3515,te,pr);
		else
			sa=nan(size(D,1),1);
		end
	end
	if exist('ox','var')~=1,
		ox=nan(size(D,1),1);
	end

	stp=[sa,te,pr,ox];


