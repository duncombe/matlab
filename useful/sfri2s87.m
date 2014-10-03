function STP=sfri2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt,Nfilt)
% SFRI2S87 -	Loads SFRI ascii CTD data and outputs to S87 file
%
% USAGE -	sfri2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt) 
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
% PROG MODS -	2001-02-15: introduce test for unchanged salinity values
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

% test the input arguments and set up defaults
%
	PNAME='SFRI2S87';
	if ~exist(fromfn),
		disp('Data file does not exist'); 
		return; 
	end;
	fid=1; if exist('tofn') , if ~isempty(tofn), fid=fopen(tofn,'wt'); end; end;
	if ~exist('TCCPP'), TCCPP='C9199'; elseif isempty(TCCPP), TCCPP='C9199'; end;     % 'CTD station, platform unknown'
	if ~exist('CRUISE'), CRUISE='NotKnown'; elseif isempty(CRUISE), CRUISE='NotKnown'; end; 
	if ~exist('slope'), slope=1; end;
	if ~exist('intcpt'), intcpt=0; end;
	if ~exist('Nfilt'), Nfilt=3; end;

% load using sfriload
	[STP,stn,grid,dd,dt,la,lo,sndg]=sfriload(fromfn);
	yd=date2day(dd);
	N=Nfilt;
	STP(:,1)=medfilt1(STP(:,1),N);
	STP(:,1)=STP(:,1).*slope+intcpt;
%	disp(fid, TCCPP,stn,grid,la,lo,dd,yd(2),dt(1:2),CRUISE);

	fprintf(fid,'%s %s %d %g %g %d/%02d/%02d %03d %02d:%02d %s\n',...
		TCCPP,stn,grid,la,lo,dd,yd(2),dt(1:2),CRUISE);
	fprintf(fid,'& ZZ=%g\n',sndg);
	time=clock;
	fprintf(fid,'# %s %02d:%02d: Salinity order-%d median filtered (%s)\n',date,time(4:5),Nfilt,PNAME);

	if slope==1 & intcpt==0,
		fprintf(fid,'# %s %02d:%02d: No salinity correction applied by %s\n',...
		date,time(4:5),PNAME);
	else
		fprintf(fid,'# %s %02d:%02d: Salinity correction applied by %s: y=%gx+%g\n',...
		date,time(4:5),PNAME,slope,intcpt);
	end;
	
	fprintf(fid,'@PR\tTE\tSA\n');
	fprintf(fid,form(size(STP,2)),fliplr(STP)');
	if exist('tofn') , if ~isempty(tofn), fclose(fid);  end; end;

	return;

