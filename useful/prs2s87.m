function STP=prs2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt,Nfilt)
% PRS2S87 -	Loads CTD data from OceanSoft .prs file and outputs to S87 file
%
% USAGE -	prs2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt,Nfilt,la,lo,dd,ddt) 
%
%		fromfn - file to read from (reqd)
%		tofn - file to write to [stdout]
%		TCCPP - NODC identifier code ['C9199'] (see s87.doc for details)
%		CRUISE - cruise name or comment ['NotKnown']
%		slope - of the salinity correction regression [1] 
%			If scalar applied only to salt, else a vector applied 
%			to all variables.
%		intcpt - of the salinity correction regression [0]
%			If scalar applied only to salt, else a vector applied 
%			to all variables.
%		Nfilt - median filtersize [3] 
%		la - latitude [99.999]
%		lo - longitude [99.999]
%		dd - date [9999 99 99]
%		ddt - time [99 99 99]
%
% SEE ALSO -	prsload
%


% PROGRAM - 	MATLAB code by c.m.duncombe rae, 98-11-20, sfri
%
% PROG MODS -	99-02-16 rewrite to handle .prs format
%		99-09-07 correction vectors for all params
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

%
% test the input arguments and set up defaults
disp('Program may be malfunctioning. Check bottom pressures.');
	PNAME='PRS2S87';
	if ~exist(fromfn),
		disp('Data file does not exist'); 
		return; 
	end;
	fid=1;
	if exist('tofn'),
		if ~isempty(tofn), 
			if strcmp(tofn,fromfn),
				disp('Fromfile is same as Tofile');
				return;
			else
				fid=fopen(tofn,'wt'); 
			end;
		end; 
	end;
	if ~exist('TCCPP'), TCCPP='C9199'; elseif isempty(TCCPP), TCCPP='C9199'; end;     % 'CTD station, platform unknown'
	if ~exist('CRUISE'), CRUISE='NotKnown'; elseif isempty(CRUISE), CRUISE='NotKnown'; end; 
	if ~exist('Nfilt'), Nfilt=[]; end; 	% No median filtering
% Hold over setting defaults for the slope and intercept until
% after we have loaded the data
	grid=999;

%
% load using prsload
	[STP,pos,dt,stn,sndg,id]=prsload(fromfn);
	[m,n]=size(STP);
%
% Rationalize the variable
	PTS=STP(:,[3,2,1,4:n]);

	if ~exist('slope'), 
		slope=ones(1,n);	% No change in the salinity
	else
		nn=size(slope,2);
		while nn<n, slope=[slope 1]; nn=size(slope,2); end;
	end;
	if ~exist('intcpt'),
		intcpt=zeros(1,n); 
	else
		nn=size(intcpt,2);
		while nn<n, intcpt=[intcpt,0]; nn=size(intcpt,2); end;
	end;	%

	yd=date2day(dt); 
%
%	disp(fid, TCCPP,stn,grid,la,lo,dd,yd(2),ddt(1:2),CRUISE);

	fprintf(fid,'%s %s %d %g %g %d/%02d/%02d %03d %02d:%02d %s\n',...
		TCCPP,stn,grid,imag(pos),real(pos),dt(1:3),yd(2),dt(4:5),CRUISE);
	fprintf(fid,'& ZZ=%g\n',sndg);

	time=clock;

% Can use presfilt to remove reversals and interpolate to standard intervals
%	PTS=presfilt(PTS);
%	fprintf(fid,'# %s %02d:%02d: Pressure reversals removed (PRESFILT)\n',date,time(4:5));
%
% Can use medfilt1 to median filter the data
	if ~isempty(Nfilt),
		PTS=medfilt1(PTS,Nfilt); 
		fprintf(fid,'# %s %02d:%02d: Order-%d median filtered (%s)\n',date,time(4:5),Nfilt,PNAME);
	end;

% Decompose the variables 
	L=id;i=0;
	VNAME=[];
	[junk,L]=strtok(L);
	while ~isempty(junk),
		VNAME=[VNAME;junk(1:2)];
		[junk,L]=strtok(L);
		i=i+1;
	end;
	VNAME=VNAME(2:i-1,:);

	PTS=PTS.*(ones(m,1)*slope) + ones(m,1)*intcpt;

	for i=1:n,
		if slope(i)~=1 & intcpt(i)~=0,
			fprintf(fid,'# %s %02d:%02d: %s correction applied by %s: y=%gx+%g\n',...
			date,time(4:5),VNAME(i,:),PNAME,slope(i),intcpt(i));
		end;
	end;
	
	fprintf(fid,'@');
	for i=1:size(VNAME,1)-1, fprintf(fid,'%s\t',VNAME(i,:)); end;
	fprintf(fid,'%s\n',VNAME(size(VNAME,1),:));
	fprintf(fid,form(size(STP,2)),PTS');
%
% Rationalise again the variable
	STP=PTS(:,[3,2,1,4:n]);
	if exist('tofn') , if ~isempty(tofn), fclose(fid);  end; end;

return;

