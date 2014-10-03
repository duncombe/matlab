function [D,P]=sjxbt(fn)
% SJXBT -	Loads Seward Johnson XBT data
%
% USAGE -	[D,P]=sjxbt(fn)
%	

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	
%
% PROG MODS -	
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
fid=fopen(fn);
I=[];
while isempty(I),
	var=fgetl(fid);
	I=findstr(9,var);
	if size(I,1)>0, 
		if I(1)~=1, 
			I=[]; 
		end;
	end;
	while findstr('  ',var), var=strrep(var,'  ',' '); end;
	if var(1)~='/',
		J=findstr('Latitude',var);
		if ~isempty(J), 
%			disp(J);
%			disp(var);
			J=findstr(' ',var);
			if length(J)<4, 
				disp([fn ' is no good (Latitude)']); 
			else
				lat = str2num(var(J(2):J(3))) + str2num(var(J(3):J(4)))./60; 
				if var(length(var))=='S' | var(length(var))=='s', lat=-lat; end;
%				disp(lat);
			end;
		end;
		J=findstr('Longitude',var);
		if ~isempty(J),
%			disp(var);
%			disp(J);
			J=findstr(' ',var);
			if length(J)<4,
				disp([fn ' is no good (Longitude)']);
			else
				lon = str2num(var(J(2):J(3))) + str2num(var(J(3):J(4)))./60; 
				if var(length(var))=='W' | var(length(var))=='w', lon=-lon; end; 
%				disp(lon);
			end;
		end;
	end;
end;
if exist('lat') & exist('lon'), P=lon+sqrt(-1).*lat; else P=NaN; end;
if length(I)<2, 
	while ~isempty(findstr(var,'  ')), 
		var=strrep(var,'  ',' '); 
	end; 
	var=strrep(var,' ',9); 
	I=findstr(9,var);
end;
d=[str2num(var(I(1):I(2))), str2num(var(I(2):length(var)))];
fspec=['\t%g\t%g\n'];
[D,C] = fscanf(fid,fspec,[2,inf]);
D=[d; D'];
fclose(fid);
return;
