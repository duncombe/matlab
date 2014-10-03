function STP=cnv2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt,Nfilt)
%CNV2S87 - 	converts seasoft CNV files to s87 format files
% 
%USAGE -	STP=cnv2s87(fromfn,tofn,TCCPP,CRUISE,slope,intcpt,Nfilt)
%
%EXPLANATION -	fromfn: from filename
%		tofn:	to filename
%		TCCPP:	platform identifier
%		CRUISE:	cruise name
%		slope:	regression slope to apply to salinity
%		intcpt:	regression intercept to apply to salinity
%		Nfilt:	number of points filter to use
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
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

PNAME='CNV2S87';
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
if ~exist('TCCPP'),
	TCCPP='C9199';
elseif isempty(TCCPP),
	TCCPP='C9199';
end;

if ~exist('CRUISE'),
	CRUISE='NotKnown';
elseif isempty(CRUISE),
	CRUISE='NotKnown';
end; 

if ~exist('slope'), slope=[]; end;
if ~exist('intcpt'), intcpt=[]; end;
if ~exist('Nfilt'), Nfilt=3; end;
if ~exist('la'), la=99.999; end;
if ~exist('lo'), lo=99.999; end;
if ~exist('dd'), 
        yd=[9999 999]; 
        dd=[9999 99 99];
else 
        yd=date2day(dd); 
end;
if ~exist('ddt'), ddt=[99 99 99]; end;


% [STP,vars,pos,header,time,stn]=seasoftn(fromfn);
[STP,vars,pos,time,stn]=seasoftn(fromfn);

% put the data into individual vectors

nvars=size(vars,1);

clear te pr sa de ox; 
for ii = nvars:-1:1,
	eval( [ vars(ii,:) '= STP(:,ii);']);
end;

if exist('pr'), STP=[STP, pr]; end;
if exist('te'), STP=[STP, te]; end;
if exist('sa'), STP=[STP, sa]; end;
if exist('ox'), STP=[STP, ox]; end;

grid=stn;

	yd=date2day(time);
	dd=time(1:3);
% disp(fromfn)
% disp(time);
	ddt=time(4:6);
	la=imag(pos);
	lo=real(pos);

fprintf(fid,'%s %s %s %g %g %d/%02d/%02d %03d %02d:%02d %s\n',...
                TCCPP,stn,grid,la,lo,dd,yd(2),ddt(1:2),CRUISE);
% fprintf(fid,'& ZZ=%g\n',sndg);
time=clock;
STP=presfilt(STP);
fprintf(fid,'# %s %02d:%02d: Pressure reversals removed (PRESFILT)\n',date,time(4:5));
if ~isempty(Nfilt),
        STP=medfilt1(STP,Nfilt); 
        fprintf(fid,'# %s %02d:%02d: Order-%d median filtered (%s)\n',date,time(4:5),Nfilt,PNAME);
end;

if ~isempty(slope) & ~isempty(intcpt),
	STP(:,1)=STP(:,1).*slope+intcpt;
	fprintf(fid,...
	'# %s %02d:%02d: Salinity correction applied by %s: y=%gx+%g\n',...
	date,time(4:5),PNAME,slope,intcpt);
end;
        
fprintf(fid,'@PR\tTE\tSA\tOX\n');
fprintf(fid,form(size(STP,2)),[STP(:,[3,2,1,4])]');
if exist('tofn') , if ~isempty(tofn), fclose(fid);  end; end;

return;
