function [FLOW,HEADS]=srvdisp(filename,N,plotyn,S,plotlog)
%SRVDISP - 	display SERVICE format file 
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2007-07-15
%
%PROG MODS -	2007-08-31: choice of imagesc(log(v)) or imagesc(v)
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

% display service file 

if ~exist(filename),
	disp(['File ' filename ' not found']);
	return;
end;

if ~exist('N'), N=1; end; 
if isempty(N), N=1; end;

if ~exist('S'), S=[]; end; 

if ~exist('plotyn'), plotyn=1; end;
if ~exist('plotlog'), plotlog=1; end;

fid=fopen(filename,'r','ieee-be');

ibuff=2; 

for i=1:N,

	ihead=fread(fid,8,'int');
% 	disp(ihead);
	buff=fread(fid,ibuff,'int'); 
% 	disp(buff);

	if isempty(ihead), 
		disp(['Only ' num2str(i-1) ' pages available']); 
		return;
	end;

	nx=ihead(6); ny=ihead(7);
	
	flow=fread(fid,[nx,ny],'real*4');
	buff=fread(fid,ibuff,'int');

	flow=fliplr(rot90(flow,-1));  

	disp(['Grid size:  ', num2str([nx,ny])]);
	disp(['[Min, max]: ',num2str(minmax(flow))]);
	if plotyn,
	   figure;
		if plotlog,
	   imagesc(log(abs(flow)));
		else
	   		imagesc(flow);
		end;
	
	   if exist('S'),
	   	if ~isempty(S),
	   		hold on;
			% fborg=90; fscal=0.5; florg=-180;
	   		plot(2.*S(:,1)+360,[180-2.*S(:,2)],'k');
	   	end;
	   end;
	end;

	HEADS{i}=ihead;
	FLOW{i}=flow;
end;

fclose(fid);

return;

