function [X,Y,R,th,U,V,T,Xm,Ym,Um,Vm]=adcpview(fil,bindepth)
%
% Plots the data from ADCP data files
% Uses GMT by system calls
%

% fil='bin32.dat';
% fil='bin16.dat';
% fil='bin48.dat';

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

if ~exist('bindepth'), bindepth=[]; end; 
if isempty(bindepth), bindepth=data(1,5); end;

% extract the bindepth 

I=find(data(:,5)~=bindepth);
data(I,:)=[];

% Clean up the bad values

I=find(data(:,3)>32000|data(:,3)<-32000|data(:,4)>32000|data(:,4)<-32000);
data(I,:)=[];
I=find(data(:,1)>90|data(:,1)<-90);
data(I,:)=[];
I=find(data(:,2)>360|data(:,2)<-360);
data(I,:)=[];


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

T=data(:,6);



% Write the data to files for gridding 


fid=fopen('velox.dat','w');
fprintf(fid,form(3),[X,Y,U]');
fclose(fid);

fid=fopen('veloy.dat','w');
fprintf(fid,form(3),[X,Y,V]');
fclose(fid);

figure;
	quiver(X,Y,U,V);
	hold on;
	title(['ADCP Currents at ' num2str(bindepth) 'm']);
A=axis;

Range=sprintf('%g/%g/%g/%g',A');

unix(['blockmean velox.dat -R' Range ' -I0.05  > velox.blk']);
unix(['blockmean veloy.dat -R' Range ' -I0.05  > veloy.blk']);

load velox.blk
load veloy.blk
% Scale velocities to fit the plot
Um=velox(:,3).*0.01;
Vm=veloy(:,3).*0.01;
Xm=velox(:,1);
Ym=velox(:,2);


	quiver(Xm,Ym,Um,Vm,0,'r');
	coast('f');
	axis('equal');
	a=axis;
	b(1)=a(2)-(a(2)-a(1))./10;
	b(2)=a(4)-(a(4)-a(3))./10;
	quiver(b(1),b(2),-0.1,0,0,'r');
	text(b(1),b(2),'10cm/s');
	zoom on;


return;

