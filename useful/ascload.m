function stp=ascload(fn)
% ASCLOAD - 	loads data from OCEANSOFT .ASC file
% 
% USAGE -	
%
% EXPLANATION -	
%
% SEE ALSO -	
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	2000-08-28
%
% PROG MODS -	
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
%

rec=[];

if ~exist(setstr(fn)), disp(['File ' fn ' not found']); 
else
	fid=fopen(fn);

	rec=fgetl(fid);
	rec=fgetl(fid);
% this line contains the date and time
	rec=fgetl(fid);
% get two empty lines
	rec=fgetl(fid); fgetl(fid);
% this line contains the lat and long
	rec=fgetl(fid);
% get an empty line
	rec=fgetl(fid);
% this line contains the gravity and coriolis
	rec=fgetl(fid);
% get a line of ==
	rec=fgetl(fid);
% get the column id line
	rec=fgetl(fid);
	i=0;
	[l,rec]=strtok(rec);
	forma=[]; pcol=[]; scol=[]; tcol=[]; ocol=[];
	while ~isempty(l),
	forma=[forma '%g'];
		i=i+1;
		if findstr('PRES',l), pcol=i; end;
		if findstr('TEMP',l), tcol=i; end;
		if findstr('SALT',l), scol=i; end;
		if findstr('OXYG',l), ocol=i; end;

		[l,rec]=strtok(rec);
	end;
        forma=[forma,'\n'];

	rec=fgetl(fid);
% get lines until we get a spacer line
	% while ~feof(fid) & ~( rec(1)=='=' & ~any(diff(abs(rec))) ),
	% 	rec=fgetl(fid);
	% end;
	rec=fgetl(fid);
	rec=fgetl(fid);
	dat=[fscanf(fid,forma,[i,inf])]';
	stp=[dat(:,[scol,tcol,pcol,ocol])];
	fclose(fid);
end;

return;

