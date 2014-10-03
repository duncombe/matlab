function stp=sjctd(fn)
% SJCTD -	Loads CTD data from Seward JOhnson Cruise
%
% USAGE -	stpo=sjctd(filename)
%
% EXPLANATION -	stpo - salinity temperature pressure oxygen
%		filename - filename to open

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
var=fgetl(fid);
I=findstr(9,var);
nvars=length(I)+1;
fspec=[];
for i=1:nvars-1,
	fspec = [fspec '%g\t'];
end;
fspec=[fspec '%g\n'];
[D,C] = fscanf(fid,fspec,[nvars,inf]);
% D=D';
stp=D([8,2,1,10],:)';
fclose(fid);
return;
