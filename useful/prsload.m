function [ stp, pos, dt, stn, snd, id, dat ] = prsload( fn )
% PRSLOAD - 	loads data from OCEANSOFT .PRS file
%
% USAGE -	[stp,pos,dt,stn,snd,id,dat] = prsload(fn)
%
% EXPLANATION -	stp - sorted in stp order
%		stn - station number
%		pos - complex position
%		dt - date vector
%		id - identifier line
%		dat - data as found
%		snd - sounding
%
% SEE ALSO - 	prs2s87
%		


% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1999-01-22: Africana V150 CMDR
%
% PROG MODS -	1999-07-13: Africana V155 - use of parsepos.m
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

dt=[];
pos=[];
rec=[];
if ~exist(setstr(fn)), disp(['File ' fn ' not found']); 
else 
	fid=fopen(fn);
	while isempty(rec), rec=fgetl(fid); end;
	while ~feof(fid) & ~( rec(1)=='-' & ~any(diff(abs(rec))) ),
		if findstr('Sta.#:',rec),
			stn=deblank(rec(10:23)); 
			while stn(1)==' ',
				stn=stn(2:length(stn)); 
			end;
		elseif findstr('|    Date:',rec),
			M=['JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC'];
			m = (findstr(rec(38:40),M)+2)./3;
			dt = [str2num(rec(42:45)) m str2num(rec(35:36)) dt];
		elseif findstr('St.Time:',rec),
			dt = [dt str2num(rec(11:12)) str2num(rec(14:15)) str2num(rec(17:18))];
		elseif findstr('St.Lat.:',rec),
			pos=sum([pos sqrt(-1).*parsepos(rec(10:23))] );
		elseif findstr('St.Long:',rec),
			pos=sum([pos parsepos(rec(10:23))]);
		elseif findstr('Depth:',rec),
			snd=str2num(strtok(rec(10:23)));
		end;
		rec=fgetl(fid);
	end; 
	if ~feof(fid), 
		rec=fgetl(fid); 
		id=rec;
		i=0;
		[l,id]=strtok(id);
		while ~isempty(l), 
			[l,id]=strtok(id); 
			i=i+1; 
			forma=[forma,'%g,'];
		end;
		forma(length(forma))='\';
		forma=[forma,'n'];
%
%  this is going to have to change
%	formt=['%g,%g,%g,%g,%g,%g,%g,%g\n'];
		dat = [fscanf(fid,forma,[i,inf])]';
% sort in S,T,P,O,Fluor,Trans order
		stp=[dat(:,[4,3,2,5:i])];
	end;
 	fclose(fid);
end;
return;

%			pos = sum([pos sqrt(-1).*(2.*(~isempty(findstr('N',rec(10:22))))-1).*(str2num(rec(10:12))+str2num(rec(15:19))./60)]);
%			pos = sum([pos (2.*(isempty(findstr('W',rec(10:22))))-1).*(str2num(rec(10:12))+str2num(rec(15:19))./60)]);
