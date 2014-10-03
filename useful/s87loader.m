function [CTD,POS,TIM,FIL,FST,CTDindex,STN,GRD]=s87loader(expr)
%S87LOADER -	Loads s87 data from files 
%
%USAGE -   [CTD,POS,TIM,FIL,FST,CTDindex,STN,GRD]=s87loader(expr)
%
%EXPLANATION -	expr - regular expression or directory list filename ['*.s87'] 
%		CTD - [Salt,Temp,Pres,Oxy] data
%		POS - Latitude and longitude as an array of complex numbers
%		TIM - Date/Time as a Nx5 matrix of [yr mo da hr mi]
%		FIL - pathnames of data files
%		FST - the station number derived from the filename
%		CTDindex - index to CTD stations
%		STN, GRD - Station and grid numbers from the header lines
% 		data - all data in the files
% 		vars - key to columns in data
%
%USES -		DIRLIST, S87LOADS, SORTSTR
%
%BUGS -		DOS does not return a directory listing in a variable
%		and a temporary file must be created to hold the dir
%		list. Unix is OK and runs wholely inside Matlab. 
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	from views87s, 2008/12/12 
%	$Revision: 1.4 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: s87loader.m,v 1.4 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
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

morestate=get(0,'more');

if exist('expr')~=1,
  expr='*.s87'; 
else 
  if isempty(expr), 
    expr='*.s87'; 
  end; 
end;

% disp(['S87LOADER: version ' VERSION ]);

% We take away the parsing of the filenames and put it in a function 
% so we can use it in other programs

[DIR,N]=dirlist(expr);

disp([num2str(N) ' stations to process']);

CTD=[];
J=[];
K=[]; 
POS=[]; 
TIM=[];
FIL=[];
FST=[];
STN=[];
GRD=[];
figs=[];
iSTN=0;
iGRD=0;
N=0;
thand=[];

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
% We shlip in a NaN as a station separator.
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

if size(CTD,2)>=4,
  DataCols=[1,2,4:size(CTD,2)];
else
  DataCols=[1,2]; 
end;

  CTDindex=[J,K];
  disp([ num2str(N) ' stations processed']);
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

more(morestate);

return;

