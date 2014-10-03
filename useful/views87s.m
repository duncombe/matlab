function [CTD,POS,TIM,FIL,FST,CTDindex,figs,thand,STN,GRD]=...
  views87s(expr,plotall,plotctds,C138,labl,rd,omit)
%VIEWS87S -	Displays TS plots of all .s87 files in current directory.
%		Also plots all data on a single TS plot, and a track chart.
%
%USAGE -	[CTD,POS,TIM,FIL,FST,CTDindex,figs,thand,STN,GRD]=
%			views87s(expr,plotall,plotctds,C138,labl,rd,omit)
%
%EXPLANATION -	expr - regular expression or directory list filename ['*.s87'] 
%		CTD - [Salt,Temp,Pres] data
%		POS - Latitude and longitude as an array of complex numbers
%		TIM - Date/Time as a Nx5 matrix of [yr mo da hr mi]
%		FIL - pathnames of data files
%		FST - the station number derived from the filename
%		CTDindex - index to CTD stations
%		figs - figure handles created
%		thand - text handles created
%		STN, GRD - Station and grid numbers from the header lines
%		plotall - do a TS plot with the reference data (0)
%		plotctds - do TP,SP,TS triplet for each station (0)
%		C138 - reference station data, not plotted if empty
%		labl - label the start and end points of each station data
%		rd - randomize the labelling positions (0)
%		omit - plot only data deeper than omit
%
%USES -		DIRLIST, S87LOADS, SORTSTR
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
%	$Revision: 1.8 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: views87s.m,v 1.8 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%PROG MODS -
%		1998-11-03: label plot
%		1998-11-04: return list of figures created
%		1998-11-05: random placement of text labels
%		2000-01-11: plot sp and tp figures as well. change some
%			defaults
%		2000-01-17: change speed calculation to use sw_dist
%		2000-02-21: more off
%		2000-02-24: change order of access to subplots when using
%			displays. this was causing changes which
%			broke stpaxis.
%		2000-05-05: fix condition for DOS matlab
%		2000-05-19: generalize: plot parameter/pressure for all
%			available data columns
%		2001-03-03: provide option to put list of files in call
%		2001-10-08: label with only last part of filepath
%		2001-10-17: move parsing of files regex to function dirlist
%		2002-06-04: cosmetics
%		2002-06-07: Add FST to returned parameters (this may break
%			old programs)
%		2002-06-12: Tidy up (deleting commented out code replaced by
%			call to dirlist). Display number of stations
%			to be processed.
%		2002-09-12: Collect station and grid numbers, check duplicates.
%			Had to change STN (ststion derived from	filename) to
%			FST. Use new STN for station in	header line.
%		2002-11-15: checking station duplicates, rationalize and print
%			out each station name only once.
%		2002-12-06: bugfix in station duplicates, new algorithms
%		2003-10-01: Add NaNs in CTD output to separate stations
%		2003-11-25: bug fix: if there's only one station it crashes
%		2004-03-03: set axis('equal') on the cruise chart
%		2004-03-09: bugfix in plotall/plotctds section (at sea AFR190)
%			and some tidying up
% 		2009/03/03: arrange coast plotting so that the axes are made 
%	 		equal before the coast is plotted to avoid large 
% 			blank areas of no coastline.  
% 		2009/03/13: plot a temperature oxygen view also
% 

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

VERSION='2004-03-09';

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

if exist('expr')~=1,
  expr='*.s87'; 
else 
  if isempty(expr), 
    expr='*.s87'; 
  end; 
end;


if ~exist('labl'), labl=0; end;
if ~exist('rd'), rd=0; end;

disp(['VIEWS87S: version ' VERSION ]);

% disp([	10 'VIEWS87S function has changed such that it ' 10 ...
%   'may no longer be backwards compatible' 10 ]);

% We take away the parsing of the filenames and put it in a function 
% so we can use it in other programs

[DIR,N]=dirlist(expr);

disp([num2str(N) ' stations to process']);

CTD=[];J=[];K=[]; POS=[]; TIM=[]; FIL=[];
FST=[]; STN=[]; GRD=[]; figs=[]; iSTN=0; iGRD=0;
N=0; thand=[];

if ~isempty(DIR),

  [rec,DIR]=strtok(DIR);

  while ~isempty(rec),

    if ~exist(rec),
      disp([rec ' not found']);
    else
      more off;
      disp(rec);
      more on;
      [stp,pos,tim,header,stn,grd]=s87loads(rec);
      if isempty(pos),
        disp([rec ': Invalid position reported']); 
        pos=NaN; 
      end;
      if isempty(tim),
        disp([rec ': Invalid time reported']); 
        tim=NaN.*ones(1,5); 
      end;
      if exist('omit'),
        OMIT=find(stp(:,3)>=omit);
        stp=stp(OMIT,:);
      end; 
      if isempty(stn),
        disp([rec ': Invalid Station']);
        stn=NaN;
      end;
      if isempty(grd),
        disp([rec ': Invalid Grid']);
        grd=NaN;
      end;
      
      J=[J;size(CTD,1)+1];
% Be careful of this one! To get the same # of columns, we turn them 
% on their side and then turn them back again when we patch them together!
% We shlip in a NaN to keep the stations separate 
      [CTD,stp]=samerows(CTD.',stp.');
      lnans=NaN.*ones(size(stp,1),1);
      CTD=[ CTD.' ; stp.' ; lnans.' ];
	stp=stp.';
% We take away one from the pointer to make sure the added NaN is not included
      K=[K;size(CTD,1)-1];
      POS=[POS;pos];
      TIM=[TIM;tim];

      FIL=str2mat(FIL,rec); 
      FST=str2mat(FST,varname(rec));
      STN=str2mat(STN,stn);
      GRD=str2mat(GRD,grd);
%%%%%%%%%
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
        subplot(1,3,1); 
	% xaxis([2 22]);
	% yaxis([0 200]);
        subplot(1,3,2);
	% xaxis([34.0 36.0]); 
	% yaxis([0 200]);
        title(varname(rec)); 
        subplot(1,3,3); 
	% axis([34.0 36.0 2 22]);
        zoom on;
      %	pause;
      
      end;
    N=N+1;
    end;
    [rec,DIR]=strtok(DIR);
  end;


  % first row of these matrices is blank
  FIL=FIL(2:size(FIL,1),:);
  FST=FST(2:size(FST,1),:);
  STN=STN(2:size(STN,1),:);
  GRD=GRD(2:size(GRD,1),:);

mTIM=size(TIM,1);
% size(TIM)
  II=find( any([TIM>(ones(mTIM,1)*[3000 12 31 24 60])].') );

% disp('We got to here');
% pause;

  if ~isempty(II),
     TIM(II.',:)=ones(size(II,2),1)*[3000 12 31 24 60]; 
  end;

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
	%
	% wld have to find the non-NaN in CTD(J:K,dcol) to put the label 
	%
      thand=[thand; text(CTD(J,dcol),CTD(J,3),FST)]; 
      thand=[thand; text(CTD(K,dcol),CTD(K,3),FST)]; 
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
      thand=[thand; text(CTD(J,1),CTD(J,2),FST)]; 
      thand=[thand; text(CTD(K,1),CTD(K,2),FST)]; 
    end;
    title(pwd);
    xlabel(Labels(1,:));
    ylabel(Labels(2,:));
    zoom on;

% Plot temperature/oxygen

  figs=[figs;figure];
    if plotref, 
      plot(C138(:,4),C138(:,2),'.');
    end;
    hold on;
    plot(CTD(:,4),CTD(:,2),'g.');
    for i=1:size(J),
      plot(CTD(J(i):K(i),4),CTD(J(i):K(i),2),'g');
    end;
    if labl,
      thand=[thand; text(CTD(J,1),CTD(J,2),FST)]; 
      thand=[thand; text(CTD(K,1),CTD(K,2),FST)]; 
    end;
    title(pwd);
    xlabel(Labels(4,:));
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
      thand=[thand; text(real(POS(I))+rofset,imag(POS(I))+iofset,FST(I,:))];
    end;
    title(pwd);
	axis('equal');
	coast('auto');
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
       plot(tbase(iii),ybase(iii),'mx','linewidth',3);
     end;

     iii=find(isinf(spd));
     if ~isempty(iii),
       spd(iii)=NaN.*iii;
       plot(tbase(iii),ybase(iii),'mx','linewidth',3);
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
      thand=[thand; text(ytim+rofset,abs(POS)+iofset,FST)];
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
  %		thand=[thand; text(ytim+rofset,normaliz(abs(POS))+iofset,FST)];
  %	end;
  %	title(pwd);
  %	zoom on;
  %	

  CTDindex=[J,K];
  disp([ num2str(N) ' stations processed']);



  % if iSTN>0,
    % plural=[];
    % if iSTN>1,
      % plural='s';
    % end;
  % disp([num2str(iSTN),' file' plural ' with same station number as another']);
  % end;
  % if iGRD>0,
    % plural=[];
    % if iGRD>1,
      % plural='s';
    % end;
    % disp([num2str(iGRD),' file' plural ' with same grid number as another']);
  % end;



% disp(size(STN));
% disp(size(GRD));


[m,n]=size(STN);
[sSTN,l]=sortstr(STN);

% find rows which are the same: turn the strings into numbers, do
% a diff, abs the diffs (we do not want to mess with accidentally
% summing to zero!), sum (by multiplying by a ones array!), zero
% indicates two rows the same, NOT them to get ones.

if size(sSTN,1)>1,
	j=~abs(diff(abs(sSTN)))*ones(n,1);

% find rows which are duplicated: line the diffs up and OR them

	k=find([j;0]|[0;j]);

	if ~isempty(k),
% build a spacer for display
		blank=ones(size(l(k)),1).*[' '];
		more off;
		disp([10 'Station numbering duplication details']);
		disp(['-------------------------------------']);
		disp([FIL(l(k),:),blank,STN(l(k),:),blank,GRD(l(k),:)]);
		more on;
	end;
end;

% Now do the same for the grid numbers

[m,n]=size(GRD);
[sGRD,l]=sortstr(GRD);

if size(sGRD)>1,
	j=~abs(diff(abs(sGRD)))*ones(n,1);

	k=find([j;0]|[0;j]);

	if ~isempty(k),
		blank=ones(size(l(k)),1).*[' '];
		more off;
		disp([10 'Grid numbering duplication details']);
		disp(['----------------------------------']);
		disp([FIL(l(k),:),blank,STN(l(k),:),blank,GRD(l(k),:)]);
		more on;
	end;
end;


end;	

return;

