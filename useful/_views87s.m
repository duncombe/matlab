function [CTD,POS,TIM,STN,CTDindex,figs,thand]=views87s(expr,plotall,plotctds,C138,labl,rd)
%VIEWS87S -	Displays TS plots of all .s87 files in current directory.
%		Also plots all data on a single TS plot, and a track chart.
%
%USAGE -	[CTD,POS,TIM,STN,CTDindex,figs,thand] = ...
%			views87s( expr,plotall,plotctds,C138,labl,rd )
%
%EXPLANATION -	expr - regular expression or directory list filename ['*.s87'] 
%		CTD - [Salt,Temp,Pres] data
%		POS - Latitude and longitude as an array of complex numbers
%		TIM - Date/Time as a Nx5 matrix of [yr mo da hr mi]
%		STN - names of data files
%		CTDindex - index to CTD stations
%		figs - figure handles created
%		thand - text handles created
%		plotall - do a TS plot with the reference data (0)
%		plotctds - do TP,SP,TS triplet for each station (0)
%		C138 - reference station data, not plotted if empty
%		labl - label the start and end points of each station data
%		rd - randomize the labelling positions (0)
%
%BUGS -		DOS does not return a directory listing in a variable
%		and a temporary file must be created to hold the dir
%		list. Unix is OK and runs wholely inside Matlab. 
%
%		This program is becoming a bit of a portmanteau!
%		Maybe it's time to simplify and modularize it?
%


%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	1998-10-16
%
%PROG MODS -	1998-11-03: label plot
%		1998-11-04: return list of figures created
%		1998-11-05: random placement of text labels
%		2000-01-11: plot sp and tp figures as well. change some
%				defaults
%		2000-01-17: change speed calculation to use sw_dist
%		2000-02-21: more off
%		2000-02-24: change order of access to subplots when using
%				displays. this was causing changes which
%				broke stpaxis.
%		2000-05-05: fix condition for DOS matlab
%		2000-05-19: generalize: plot parameter/pressure for all
%				available data columns
%		2001-03-03: provide option to put list of files in call
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

%
% if ~exist('C138'), 
% 	load  /home/duncombe/DATA/WARM/CTD/ctddata.dat
% 	C138=ctddata(:,5:7);
% end;

% 
% inititalize parameters
%
if ~exist('C138'),
	plotref=0;
else 
	plotref=1; 
	if isempty(C138), plotref=0; end; 
end;
if ~exist('plotall'),
	plotall=0; 
else
	if isempty(plotall),
		plotall=0;
	end;
end;
if ~exist('plotctds'),
	plotctds=0; 
else 
	if isempty(plotctds), 
		plotctds=0; 
	end; 
end;

if ~exist('expr');
	expr='*.s87'; 
else 
	if isempty(expr), 
		expr='*.s87'; 
	end; 
end;


expr_exists=exist(expr);

if ~exist('labl'), labl=0; end;
if ~exist('rd'), rd=0; end;

stat=0;

% dirid=fopen('dir.txt');

% expr is a file!!
if expr_exists==2,
        f = fopen( expr );
        if f==-1,
                disp(['Cannot open file ' expr ...
		'. Disk full or permission problem?']);
	else
		stat=0;
        end;

        DIR = [fgetl(f)];
	if ~exist(DIR), 
		expr_is_not_a_list=1;
		DIR=expr;
	else
        	while ~feof(f), DIR = [DIR 10 fgetl(f)]; end;
		expr_is_not_a_list=0;
	end;
        fclose( f );
else
if strcmp(computer,'PCWIN'),
	i=-1; dn='dir.tmp'; 
	while exist(dn)==2, i=i+1; dn=['dir' num2str(i) '.tmp']; end;
        dos(['dir /b ' expr ' > ' dn ' |']);
        DIR=[];
	f = fopen( dn );
        if f==-1, 
		disp(['Cannot open file ' dn ...
		'. Disk full or permission problem?']);
	end;
        while ~feof(f), DIR = [DIR 10 fgetl(f)]; end;
        fclose( f );
	dos(['del ' dn ]);
% disp(['Cannot get directory listing with Win3.1, Win95, or Win98.' 10 ...
% 	'Please use UNIX Matlab version.']);
else
	[stat,DIR]=unix(['ls -1 ' expr ]);
	if stat & isempty(DIR),
		disp(['No files ' expr ' found in ' pwd '(' num2str(stat) ')']);
	end;
end;
% The end of the expr_exists block
end

CTD=[];J=[];K=[];
POS=[];
TIM=[];
STN=[];
figs=[];

% if ~stat,
if ~isempty(DIR),

	[rec,DIR]=strtok(DIR);

% while ~feof(dirid),
%	rec=fgetl(dirid);

	while ~isempty(rec),

		if ~exist(rec),
			disp([rec ' not found']);
		else
			more off;
			disp(rec);
			more on;
			[stp,pos,tim]=s87loads(rec);
			if isempty(pos),
				disp([rec ': Invalid position reported']); 
				pos=NaN; 
			end;
			if isempty(tim),
				disp([rec ': Invalid time reported']); 
				tim=NaN.*ones(1,5); 
			end;
			J=[J;size(CTD,1)+1];
% Be careful of this one! To get the same # of columns, we turn them 
% on their side and then turn them back again when we patch them together!
			[CTD,stp]=samerows(CTD.',stp.');
			CTD=[CTD.';stp.'];
			K=[K;size(CTD,1)];
			POS=[POS;pos];
			TIM=[TIM;tim];
			STN=str2mat(STN,rec); 
	%		disp(tim)
			if plotall,
				figs=[figs;figure]; plot(stp(:,1),stp(:,2),'.');
				hold on; 
				if plotref,
					plot(C138(1:1000,1),C138(1:1000,2),'g.');
				end;
				title(rec);
				zoom on;
			end;
			if plotctds,
				figs=[figs;figure]; 
				displays(stp);
				subplot(1,3,1); xaxis([2 25]);
				subplot(1,3,2); xaxis([34.2 35.8]); 
				title(rec); 
				subplot(1,3,3); axis([34.2 35.8 2 25]);
				zoom on;
			%	pause;
			
			end;
		end;
		[rec,DIR]=strtok(DIR);
	end;
	
	% first row of STN is blank
	STN=STN(2:size(STN,1),:);
	
	II=find( any([TIM>(ones(size(TIM,1),1)*[3000 12 31 24 60])]') );
	% size(II)
	% size(TIM)
	TIM(II',:)=ones(size(II,2),1)*[3000 12 31 24 60];
	% size(TIM)
	ytim=timefrac(TIM);

% Plot parameter/pressure plots for all parameters

Labels=str2mat('Salinity','Temperature','Pressure','Oxygen');

if size(CTD,2)>=4,
	DataCols=[1,2,4:size(CTD,2)];
else
	DataCols=[1,2]; 
end;

for dcol=DataCols,	

	figs=[figs;figure];

		plot(CTD(:,dcol),CTD(:,3),'g.');
		hold on;
		for i=1:size(J),
			plot(CTD(J(i):K(i),dcol),CTD(J(i):K(i),3),'g');
		end;
		set(gca,'ydir','reverse');
		if labl,
			thand=[thand; text(CTD(J,dcol),CTD(J,3),STN)]; 
			thand=[thand; text(CTD(K,dcol),CTD(K,3),STN)]; 
		end;
		title(pwd);
		xlabel(Labels(dcol,:));
		ylabel(Labels(3,:));
		zoom on;

end;

% 
% % Plot temperature/salinity

	figs=[figs;figure];
		if plotref, 
			plot(C138(:,1),C138(:,2),'.');
		end;
		hold on;
		plot(CTD(:,1),CTD(:,2),'g.');
		for i=1:size(J),
			plot(CTD(J(i):K(i),1),CTD(J(i):K(i),2),'g');
		end;
		if labl,
			thand=[thand; text(CTD(J,1),CTD(J,2),STN)]; 
			thand=[thand; text(CTD(K,1),CTD(K,2),STN)]; 
		end;
		title(pwd);
		xlabel(Labels(1,:));
		ylabel(Labels(2,:));
		zoom on;

% Plot positions

	figs=[figs;figure]; 
	%	m=[ 1 1./12 1./12./31 1./12./31./24 1./12./31./24./60 ];
	%	[j,I]=sort([sum([[ones(size(TIM,1),1) * m].*TIM]')]');
		[j,I]=sort(ytim);
		plot(POS(I));
		hold on;
		plot(POS(I),'o');
		if labl,
			if rd==1, 
				ax=axis;
				rofset=(ax(2)-ax(1)).*(rand(size(POS))-0.5)./500;
				iofset=(ax(4)-ax(3)).*(rand(size(POS))-0.5)./500;
			%	disp('setting the randomness');
			else
				rofset=0; iofset=0;
			end;
			thand=[thand; text(real(POS(I))+rofset,imag(POS(I))+iofset,STN(I,:))];
		end;
		title(pwd);
		zoom on;

% Plot time differences
	
	figs=[figs;figure]; 
		plot(ytim,abs(POS));
		hold on;
		plot(ytim,abs(POS),'o');
		ax=axis;
		spd=sw_dist(imag(POS),real(POS))./diff(ytim);
		tbase=ave(ytim);
		ybase=ave(abs(POS));
	
		iii=find(spd<=0);
		if ~isempty(iii),
			plot(tbase(iii),ybase(iii),'mx');
		end;
	
		iii=find(isinf(spd));
		if ~isempty(iii),
			spd(iii)=NaN.*iii;
			plot(tbase(iii),ybase(iii),'mx');
		end;
	
		plot(tbase,normaliz(spd).*(ax(4)-ax(3))+ax(3),'y');
		if labl,
			if rd==1, 
				rofset=(ax(2)-ax(1)).*(rand(size(POS))-0.5)./500;
				iofset=(ax(4)-ax(3)).*(rand(size(POS))-0.5)./500;
		%		disp('setting the randomness');
			else
				rofset=0; iofset=0;
			end;
			thand=[thand; text(ytim+rofset,abs(POS)+iofset,STN)];
		end;
		title(pwd);
		zoom on;
	%	
	%figs=[figs;figure]; 
	%	plot(ytim,normaliz(abs(POS)));
	%	hold on;
	%	plot(ytim,normaliz(abs(POS)),'o');
	%	plot(ave(ytim),normaliz(abs(diff(POS))),'go');
	%	if labl,
	%		if rd==1, 
	%			ax=axis;
	%			rofset=(ax(2)-ax(1)).*(rand(size(POS))-0.5)./500;
	%			iofset=(ax(4)-ax(3)).*(rand(size(POS))-0.5)./500;
	%		else
	%			rofset=0; iofset=0;
	%		end;
	%		thand=[thand; text(ytim+rofset,normaliz(abs(POS))+iofset,STN)];
	%	end;
	%	title(pwd);
	%	zoom on;
	%	
	CTDindex=[J,K];
end;	
return;

