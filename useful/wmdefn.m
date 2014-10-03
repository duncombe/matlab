function [WMCHAR,WMNS,NWM]=wmdefn(show_me)
% WMDEFN - 	
% 
%USAGE -	[WMCHAR,WMNS,NWM]=wmdefn(show_me)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2003-11-28
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

% WATER MASS DEFINITIONS
%
% WM defined by [S,theta,PressureLimits,DensityLimits]
% Limits are determined by a minmax call. To indicate
% that a Limit is not important, define it such that it
% covers the ocean range eg. [-1,10000] for P,
% [1000,1100] for density.
%
%%%%%%%%%%%%%%%%%%%%%%%%
% POTENTIAL TEMPERATURES
% The difference to the water masses by using in-situ or potential temperatures
% makes very little difference in the upper layers.
%

NWM=0;
WMNS=[];
LABALIGN=[];
WMCHAR=[];
%

% NWM=NWM+1; eval(['WMN',num2str(NWM),'=''UTW'';']);
NWM=NWM+1; eval(['WMN',num2str(NWM),'=''OSW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
% WM=[ 35.51 22;35.51 18;35.3 15.1;35.6 15.1;36.5 25;36.5 30;35.51 30;35.51 22;];
% 35.3	15.1	;
WM=[
	35.52	22	;
	35.52	18	;
	35.52	15.1	;
	35.6	15.1	;
	36.5	25	;
	36.5	30	;
	35.52	30	;
	35.52	22	;
];
eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'center');
[LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 

NWM=NWM+1;
% eval(['WMN',num2str(NWM),'=''SMW'';']);
eval(['WMN',num2str(NWM),'=''MUW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
% WM=[ 34.35 22 0 999;35.5 22 0 999;35.5 18 0 999;35.3-0.02 15 0 999;35.12-0.02 13 0 999;34.78-0.02 10 0 999;34.58-0.02 8.15 0 999;34.45-0.02 6.7 0 999;34.35-0.02 5.5 200 1100;34.35000 22 200 999;];
WM=[
	34.35	22	0	999;
	35.5	22	0	999;
	35.5	18	0	999;
	35.3-0.02	15	0	999;
	35.12-0.02	13	0	999;
	34.78-0.02	10	0	999;
	34.35	10	0	999;
	34.35000	22	200	999;
];
eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'center');
[LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 

NWM=NWM+1;
eval(['WMN',num2str(NWM),'=''HSCW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
% WM=[ 34.55 5.5;34.45 5.5;34.68 8.15;34.88 10;35.22 13;35.47 15;35.55 15;34.55 5.5;];
WM=[
	34.55	5.5	;
	34.45	5.5 ;
	34.68	8.15 ;
	34.88	10 ;
	35.22	13 ;
	35.345	14 ;
	35.4447	14 ;
	34.55	5.5 ;
];
% 	35.47	15 ;
% 	35.55	15 ;
eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'left');
[LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 


NWM=NWM+1;
eval(['WMN',num2str(NWM),'=''LSCW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
% WM=[34.35 5.5;34.42 5.5;34.65 8.15;34.85 10;35.19 13;35.315 14;35.44 15;35.3 15;35.21 14;35.12 13;34.78 10;34.58 8.15;34.45 6.7;34.35 5.5];
WM=[
	34.35	5.5	;
	34.42	5.5 ;
	34.65	8.15 ;
	34.85	10 ;
	35.19	13 ;
	35.315	14 ;
	35.21	14 ;
	35.12	13 ;
	34.78	10 ;
	34.58	8.15 ;
	34.45	6.7 ;
	34.35	5.5 ;
];
eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'right');
% [LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
LABPOS(NWM,:)=[34.6, 8];
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 

NWM=NWM+1;
eval(['WMN',num2str(NWM),'=''HSAIW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
WM=[
	34.55	3.7	;
   34.4985    4.0147 ;
   34.4774    4.1140 ;
   34.4494    4.3180 ;
   34.4318    4.5000 ;
   34.4342    4.7426 ;
   34.4377    5.0239 ;
   34.445    5.2224 ;
	34.45	5.3 ;
	34.55	5.3 ;
	34.55	3.7 ;
];
eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'left');
[LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 

NWM=NWM+1;
eval(['WMN',num2str(NWM),'=''LSAIW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
WM=[
	34.58, 3	;
	34.58, 3.6 ;
	34.55	3.7-0.1 ;
   34.4985-0.02    4.0147 ;
   34.4774-0.02    4.1140 ;
   34.4494-0.02    4.3180 ;
   34.4318-0.02    4.5000 ;
   34.4342-0.02    4.7426 ;
   34.4377-0.02    5.0239 ;
   34.445-0.02    5.2224 ;
	34.45-0.02	5.3 ;
	34.0	5.3 ;
	34.0	3 ;
	34.58	3 ;
];
eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'center');
[LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 

NWM=NWM+1; eval(['WMN',num2str(NWM),'=''NADW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
WM=[
	34.78	1.8	;
	34.78	3 ;
	34.87	3 ;
	34.87	1.8 ;
	34.78	1.8 ;
]; eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'left');
[LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 

NWM=NWM+1; eval(['WMN',num2str(NWM),'=''ABW'';']);
eval(['nam=WMN',num2str(NWM),';']); WMNS=str2mat(WMNS,[num2str(NWM),9,nam]); 
WM=[
	34.68	0.0;
	34.68	1.4 ;
	34.78	1.4 ;
	34.78	0.0 ;
	34.68	0.0 ;
]; eval(['WM' num2str(NWM) '=WM;']);
LABALIGN=str2mat(LABALIGN,'left');
[LABPOS(NWM,1),LABPOS(NWM,2)] = centroid(WM(:,1),WM(:,2));
[WMCHAR,WM]=samerows(WMCHAR.',WM.');
WMCHAR=[WMCHAR.'; NaN.*WM(:,1).' ;WM.']; 

% ESACW is a Mohrholtz WM
% NWM=NWM+1; eval(['WMN',num2str(NWM),'=''ESACW'';']);
% WM=[
% 	35.3	14.41;
% 	34.41	5.96;
% ]; eval(['WM' num2str(NWM) '=WM;']);

% SACW is a Mohrholtz WM
% [35.65, 16; 34.7,8] (1026.2 to 1027.2)
% NWM=NWM+1; eval(['WMN',num2str(NWM),'=''SACW'';']);
% WM=[
%	35.65	16;
%	34.7	8;
%]; eval(['WM' num2str(NWM) '=WM;']);

%% %% %% 
% Must regularize the names matrix WMNS
WMNS=WMNS(2:NWM+1,:);
LABALIGN=LABALIGN(2:NWM+1,:);

col=['gybmcrwwgbmcyw'];

if ~exist('show_me'),
	show_me=0;
end;

if show_me,
% figure; plot(STP(:,1),STP(:,2),'g.','erasemode','xor');
figure(gcf);
	hold on;
	for i=1:NWM,
		eval(['WM=WM' num2str(i) ';']);
		plot(WM(:,1),WM(:,2),col(i),'linewidth',3);
%		[X0,Y0] = centroid(WM(:,1),WM(:,2));
%		text(X0,Y0,deblank(WMNS(i,3:size(WMNS,2))),'HorizontalAlignment',LABALIGN(i,:),'color',col(i));
		text(LABPOS(i,1),LABPOS(i,2),deblank(WMNS(i,3:size(WMNS,2))),'HorizontalAlignment',LABALIGN(i,:),'color',col(i));
	end;
	
	zoom on;
end;

%
return;
