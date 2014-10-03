function [velox,veloy,U,V,Z,T,A,Ig]=adcpvert(fil,position,timeslot,Ig)
%ADCPVERT -	Plots data from ADCP files at a position of over time
%		Uses GMT programs by shell calls
%
%USAGE -	[velox,veloy,U,V,Z,T,A,Ig]=adcpvert(fil,position,timeslot,Ig)
%
%EXPLANATION -	velox - grid of east velocity component
%		veloy - grid of north velocity component
%		U - east current velocity (individual points)
%		V - north current velocity (individual points)
%		Z - depth bin (individual points)
%		T - time coordinate (individual points)
%		A - plot axis
%		fil - filename of data in the form
% [latitude,longitude,magnitude,direction,depthbin,unixtimestamp,shipsheading]
%		position - position at which to make a timeseries
%		timeslot - timespan over which to plot currents
%		Ig - grid spacing for the plot
%		timeunit - 'days', 'hours' or 'minutes'
%		
%
%SEE ALSO -	gmt
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2000-06-06 
%
%PROG MODS -	
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

%%%%%%  Data processing %%%%%%

var=strtok(fil,'.');
load(fil);
eval(['data=' var ';' ]);

% Clean up the bad values

I=find(data(:,3)>32000);
data(I,:)=[];

if ~exist('position'), position=[]; end;
if isempty('position'),
	position=[min(data(:,2))+min(data(:,1)).*i, max(data(:,2))+max(data(:,1)).*i];
end;

if ~exist('timeslot'), timeslot=[]; end;
if isempty(timeslot),
	timeslot=[min(data(:,6)), max(data(:,6))];
end;

% if ~exist('timeunit'), timeunit=[]; end;
% if isempty(timeunit),
%	 timeunit='secs';
% end;

x=real(position);x=sort(x);
y=imag(position);y=sort(y);

I=find(data(:,2)<x(2)&data(:,2)>x(1)&data(:,1)<y(2)&data(:,1)>y(1));
data=data(I,:);

I=find(data(:,6)<timeslot(2)&data(:,6)>timeslot(1));
data=data(I,:);

X=data(:,2);
Y=data(:,1);
R=data(:,3);

% Discard values outside 2 standard deviations
[m,v,n]=stats(R);
I=find( R-m > 2.*sqrt(v) );
R(I)=NaN.*I;

th=data(:,4);
V=R.*sin(th.*pi./180);
U=R.*cos(th.*pi./180);

% timefactor=1;
% if timeunit(1)=='d', timefactor=1./(24.*60.*60); end;
% if timeunit(1)=='h', timefactor=1./(60.*60); end;
% if timeunit(1)=='m', timefactor=1./(60); end;

% T=data(:,6).*timefactor;
T=data(:,6);
Z=data(:,5);

% Write the data to files for gridding 

fid=fopen('velox.dat','w');
fprintf(fid,form(3),[T,Z,U]');
fclose(fid);

fid=fopen('veloy.dat','w');
fprintf(fid,form(3),[T,Z,V]');
fclose(fid);

figure;
	plot(T,Z,'.');
	hold on;
	title(['ADCP Currents data distribution']);
	set(gca,'ydir','reverse');
A=axis;
if ~exist('Ig'), Ig=[500,5];
end;

Range=sprintf('%010.f/%010.f/%010.f/%010.f',A');
Igrid=sprintf('%g/%g',Ig');

unix(['blockmean velox.dat -R' Range ' -I' Igrid '  > velox.blk']);
unix(['surface velox.blk -R' Range ' -I' Igrid '  -Gvelox.grd']);
unix(['grd2xyz velox.grd -R' Range '  > velox.xyz']);
unix(['blockmean veloy.dat -R' Range ' -I' Igrid '  > veloy.blk']);
unix(['surface veloy.blk -R' Range ' -I' Igrid '  -Gveloy.grd']);
unix(['grd2xyz veloy.grd -R' Range '  > veloy.xyz']);

load velox.xyz
load veloy.xyz

Vy=reshape(veloy(:,3),((A(2)-A(1))./Ig(1))+1, ((A(4)-A(3))./Ig(2))+1);
Ty=reshape(veloy(:,1),((A(2)-A(1))./Ig(1))+1, ((A(4)-A(3))./Ig(2))+1);
Zy=reshape(veloy(:,2),((A(2)-A(1))./Ig(1))+1, ((A(4)-A(3))./Ig(2))+1);
Vx=reshape(velox(:,3),((A(2)-A(1))./Ig(1))+1, ((A(4)-A(3))./Ig(2))+1);
Tx=reshape(velox(:,1),((A(2)-A(1))./Ig(1))+1, ((A(4)-A(3))./Ig(2))+1);
Zx=reshape(velox(:,2),((A(2)-A(1))./Ig(1))+1, ((A(4)-A(3))./Ig(2))+1);

% Scale velocities to fit the plot
% Um=velox(:,3).*0.01;
% Vm=veloy(:,3).*0.01;
% Xm=velox(:,1);
% Ym=velox(:,2);

return;

