function STP=tape2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt,Nfilt)
% CTP2S87 -	Loads CTD data from CDS tape file and outputs to S87 file
%
% USAGE -	tape2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt,Nfilt) 
%
%		fromfn - file to read from (reqd)
%		tofn - file to write to [stdout]
%		TCCPP - NODC identifier code ['C9199'] (see s87.doc for details)
%		CRUISE - cruise name or comment ['NotKnown']
%		slope - of the salinity correction regression [1]
%		intcpt - of the salinity correction regression [0]
%		Nfilt - filtersize [3] 
%
%


% PROGRAM - 	MATLAB code by c.m.duncombe rae, 98-09-28, sfri
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
% 

%
% test the input arguments and set up defaults
	PNAME='TAPE2S87';
	if ~exist(fromfn),
		disp('Data file does not exist'); 
		return; 
	end;
	fid=1;
	if exist('tofn'),
		if ~isempty(tofn), 
			fid=fopen(tofn,'wt'); 
		end; 
	end;
	if ~exist('TCCPP'), TCCPP='C9199'; elseif isempty(TCCPP), TCCPP='C9199'; end;     % 'CTD station, platform unknown'
	if ~exist('CRUISE'), CRUISE='NotKnown'; elseif isempty(CRUISE), CRUISE='NotKnown'; end; 
	if ~exist('slope'), slope=1; end;
	if ~exist('intcpt'), intcpt=0; end;
	if ~exist('Nfilt'), Nfilt=3; end;
%
% load using tapeload
	[STP,stn,grid,dd,ddt,la,lo,sndg,airp]=tapeload(fromfn);
	yd=date2day(dd);
	sdd=sprintf('%2d/%2d/%2d',dd);sdd=strrep(sdd,' ','0');
	sddt=sprintf('%2d:%2d',ddt(1:2));sddt=strrep(sddt,' ','0');
	fprintf(fid,'%s %s %s %g %g %s %d %s %s\n',...
		TCCPP,stn,grid,la,lo,sdd,yd(2),sddt,CRUISE);
	fprintf(fid,'& ZZ=%g AP=%g\n',sndg,airp);
	time=clock;

	STP=presfilt(STP);
	fprintf(fid,'# %s %02d:%02d: Pressure reversals removed (PRESFILT)\n',date,time(4:5));
	if ~isempty(Nfilt),
		STP=medfilt1(STP,Nfilt); 
		fprintf(fid,'# %s %02d:%02d: Order-%d median filtered (%s)\n',date,time(4:5),Nfilt,PNAME);
	end;

	STP(:,1)=STP(:,1).*slope+intcpt;
	fprintf(fid,'# %s %02d:%02d: Salinity correction applied by %s: y=%gx+%g\n',...
		date,time(4:5),PNAME,slope,intcpt);
	
	fprintf(fid,'@PR\tTE\tSA\tCO\n');
	fprintf(fid,form(size(STP,2)),[STP(:,[3,2,1,4])]');
	if exist('tofn') , if ~isempty(tofn), fclose(fid);  end; end;

	return;

