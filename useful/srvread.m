function srvread(filename)
%SRVREAD - 	read service data file
% 
%USAGE -	srvread(filename)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2007/07/18
%
%PROG MODS -	
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

% fid=fopen('hdpara.srv', 'r','ieee-be');
% Note: should open the file in  the calling function, not here.
% Pass the fid instead. For simple right now, do the open here...

fid=fopen( filename , 'r','ieee-be');
	i=0;
	ierr=false;
	ihead=fread(fid,8,'int');
	while ~isempty(ihead),
		buff=fread(fid,2,'int');
		nx=ihead(6);
		ny=ihead(7);
		vari=fread(fid,[nx,ny],'real*4'); buff=fread(fid,2,'int');
		vari=fliplr(rot90(vari,-1));

		if nx==720 && ny==360,
			i=i+1;
			DATA(:,:,i)=vari;
	end;
	figure;
		imagesc(vari);



   	ihead=fread(fid,8,'int');
end;

fclose(fid);

return;


lat=fliplr(-89.5:0.5:89.5);
lon=-179.5:0.5:179.5;


fig1=figure;
set(fig1,'position',[0,200,500,500]);
fig2=figure; 
set(fig2,'position',[520,200,500,500]);
S=coast('l',[-180,180,-90,90],[0]);

for i=1:12,

flow=FLOW(:,:,i);

figure(fig1);
	clf;
	imagesc(lon,lat,log(abs(flow)+1)); hold on; 
	geoplot(S,'k');
	set(gca,'ydir','normal');

figure(fig2);
	clf;
	imagesc(log(abs(flow)+1)); hold on; 
	plot(2.*S(:,1)+360,[180-2.*S(:,2)],'k');
	set(gca,'ydir','reverse');

pause(0.5);
end;


