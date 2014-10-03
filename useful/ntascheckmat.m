function  [NTAS,changed]=ntascheckmat(FILE,varargin)	% {{{
%NTASCHECKMAT - checks data file for consistent format	
% 
%USAGE -	 [NTAS,changed]=ntascheckmat(FILE,verb)
%
%EXPLANATION -	
% 		FILE: filename or data structure
% 		NTAS: data structure
% 		changed: did any element of FILE get changed? (boolean)
% 		verb: string or boolean silent/quiet=0 verbose=1 (default)
% 		stealth: make entry in meta field boolean 1/0 (default)
% 
% 	The data specified in file is loaded if it is a filename,
% 	and used as a structure if it is a structure. An error is
% 	generated otherwise. The structure is checked for time
% 	variables yday, mday, jday and any not present are
% 	generated if possible.  The structure is checked for
% 	currents variables north, east, spd, dir, and vel and any
% 	not present are generated if possible.  
% 	spd is current magnitude
% 	dir is direction (degrees)
% 	vel is complex = east+i*north
% 	the structure is check for position, latitude longitude.
% 	Any not present are generated if possible. position is
% 	complex = longitude + i*latitude.
% 
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-08-10 
%	$Revision: 1.27 $
%	$Date: 2012-11-29 21:14:11 $
%	$Id: ntascheckmat.m,v 1.27 2012-11-29 21:14:11 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2011-12-15 
% 	Directions must be oceanographic convention: clockwise from north.
% 	Calculations to and from dir appeared not to be taking this into
% 	account. 
%  2012-02-03 
% 	Check for position
%  2012-03-30 
% 	return a boolean flag to show whether anything was changed. Do not
% 	add to the meta information if nothing was changed.
%  2012-04-16 
% 	more repairs to the logic of whether we changed a field or not
%  2012-08-28 
% 	- check if position fields we are given are empty
% 	- add option to not update meta fields (some programs are calling
% 	  ntascheckmat multiples of times resulting in unnecessary
% 	  proliferation of meta data fields.
%  2012-11-27 
% 	correct bug in assigning complex to position and real to Position. 
% 	ensure that lat and lon are fields when returning
% }}}

% License {{{
% -------
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
% }}}


changed=0;

meta.dataload_program = mfilename('fullpath'); %'get_sbe_39.m';
meta.dataload_program_run = datestr(now);
meta.dataload_program_version =  ...
	regexprep('$Revision: 1.27 $','^\$\w*:\s*([^\s]*)\s*\$','$1');

verb=1; stealth=0;
if length(varargin)==1 
	if ~ischar(varargin{1}), verb=varargin{1}; end
end 

for i=1:length(varargin)
	inverb=varargin{i};
	% if exist('verb','var')~=1, verb=[]; end
	% if isempty(verb), verb=1; end
	if ischar(inverb),
		switch inverb
		case {'silent', 'quiet'}, verb=0;
		case 'verbose', verb=1; 
		case {'stealth','stealthy','secret','nometa'}, stealth=1;
		end
	end
end

if exist('FILE','var')~=1, help(mfilename); return; end
if isstruct(FILE), NTAS=FILE;
elseif ischar(FILE), NTAS=load(FILE); 
% elseif iscell(FILE), ????
else  error('Pass correct data type');
end

% check case of fieldnames 

Fnames={'North','East','Depth'};
fnames={'north','east','depth'};

for i=1:length(Fnames)
    if ~isfield(NTAS,fnames{i}), 
	if isfield(NTAS,Fnames{i}),
		NTAS.(fnames{i})=NTAS.(Fnames{i});
		if verb, disp([fnames{i} ' was created']); end 
		changed=1;
	end
    end
end

% check dates and times: these are fields to be encountered
% mday: matlab datenumber
% jday: julian day
% yday, year: yearday
% 
% 

flags=struct('yday',false,'mday',false,'jday',false,'year',false);
% there=struct('yday',false,'mday',false,'jday',false,'year',false);

if isfield(NTAS,'mday'), [NTAS,flags]=makefieldsfrommday(NTAS,flags); end
if isfield(NTAS,'yday'), [NTAS,flags]=makefieldsfromyday(NTAS,flags); end
if isfield(NTAS,'jday'), [NTAS,flags]=makefieldsfromjday(NTAS,flags); end
if isfield(NTAS,'mdate'), 
	if ~isfield(NTAS,'mday'), 
		NTAS.mday=NTAS.mdate;  flags.mday=true; 
		[NTAS,flags]=makefieldsfrommday(NTAS,flags); 
	end
end
if ~isfield(NTAS,'mday'), error('unable to find a known time field'); end 

if any(struct2array(flags)), changed=1; end

flgfn=fieldnames(flags);
if verb,
    for i=1:length(flgfn), 
	if flags.(flgfn{i}), disp([ flgfn{i} ' was created']); end
    end
	% if flags.mday, disp('mday was created'); end;
	% if flags.jday, disp('jday was created'); end;
	% if flags.year, disp('year was created'); end;
end

% N is length of mday. Current usage seems to favor having all
% data fields in rows, i.e., MxN matrices.
% Turns out though, that Nan and Al prefer data fields in
% columns, i.e., NxM matrix. So...
%% comment: Matlab accesses matrices columnwise so NxM means that if M==3
%	and N==2100, NxM matrix plot goes by long columns using only 3 colors,
%	instead of short columns using 2100 colors 

N=length(NTAS.mday);
fn=fieldnames(NTAS);
for i=1:length(fn),
	I=find(size(NTAS.(fn{i}))==N);
	if I==2,
		NTAS.(fn{i})=NTAS.(fn{i}).';
		if verb, disp([fn{i} ' was transposed']); end
		changed=1;
	end
end

%%%%%%%%% end time check %%%%%%%%

%%%%%%%%% speed check %%%%%%% 
if isfield(NTAS,'vel') && ~isfield(NTAS,'north'),
	NTAS.north=imag(NTAS.vel);
	if verb, disp('north was created'); end
	changed=1;
end
if isfield(NTAS,'vel') && ~isfield(NTAS,'east'),
	NTAS.east=imag(NTAS.vel);
	if verb, disp('east was created'); end
	changed=1;
end

if isfield(NTAS,'north') && isfield(NTAS,'east'),
    if ~isfield(NTAS,'vel'),
    	NTAS.vel=NTAS.north.*1i+NTAS.east;
	if verb, disp('vel was created'); end
	changed=1;
    end
    if ~isfield(NTAS,'spd'), 
	NTAS.spd=abs(NTAS.vel);
	if verb, disp('spd was created'); end
	changed=1;
    end
    if ~isfield(NTAS,'dir'),
% 
	NTAS.dir=90-angle(NTAS.vel).*180./pi;
	if verb, disp('dir was created'); end
	changed=1;
    end
end

if isfield(NTAS,'dir') && isfield(NTAS,'spd'),
    [east,north]=pol2cart(pi/180*(90-NTAS.dir),NTAS.spd);
    if ~isfield(NTAS,'north'), 
	NTAS.north=north;
	if verb, disp('north was created'); end
	changed=1;
    end
    if ~isfield(NTAS,'east'),
	NTAS.east=east;
	if verb, disp('east was created'); end
	changed=1;
    end
    if ~isfield(NTAS,'vel'),
    	NTAS.vel=north.*1i+east;
	if verb, disp('vel was created'); end
	changed=1;
    end
end
% disp(changed);

if isfield(NTAS,'spd'),
	I=find(NTAS.spd==0);
	if ~isempty(I)
		if any(NTAS.dir(I))
			NTAS.dir(I)=0;
			changed=1;
		end
	end
end

%%%%%%%%%%% position check %%%%%%%%%%%%%%
lat=[]; lon=[]; pos=[]; we_have_position=0; 

% check for valid positions
posfields={'lat','lon','latitude','longitude','pos','position','Position'};
for i=1:length(posfields)
	if isfield(NTAS,posfields{i})
		if isempty(NTAS.(posfields{i})), NTAS=rmfield(NTAS,posfields{i}); end
	end
end

if isfield(NTAS,'pos'), 
	if ~isempty(NTAS.pos), pos=NTAS.pos; we_have_position=1; end
end
if isfield(NTAS,'lat'), lat=NTAS.lat; end
if isfield(NTAS,'lon'), lon=NTAS.lon; end
if ~isempty(lat) && ~isempty(lon), we_have_position=1; end

% if we have complex position, transfer it to Position and vv
if isfield(NTAS,'Position') && ~isfield(NTAS,'position') 
	if ~isreal(NTAS.Position)
		NTAS.position=NTAS.Position;
		NTAS.Position=c2m(NTAS.position);
		if verb, disp('Position was changed'); end
	else
		NTAS.position=m2c(NTAS.Position);
		if verb, disp('position was created'); end
	end
	changed=1;
	we_have_position=1;
elseif isfield(NTAS,'position') && ~isfield(NTAS,'Position')
	if isreal(NTAS.position)
		NTAS.Position=NTAS.position;
		NTAS.position=m2c(NTAS.Position);
		if verb, disp('position was changed'); end
	else
		NTAS.Position=c2m(NTAS.position); % Position is real, position is complex
		if verb, disp('Position was created'); end
	end
	changed=1;
	we_have_position=1;
end

if isfield(NTAS,'position'), 
    if ~isempty(NTAS.position)
	if ~isreal(NTAS.position), 
		lat=imag(NTAS.position);
		lon=real(NTAS.position);
	else
		i=find(size(NTAS.position)==2);
		pos=shiftdim(NTAS.position,i);
		lat=pos(:,1);
		lon=pos(:,2);
	end
	we_have_position=1;
    end
else
	if isfield(NTAS,'latitude') && isfield(NTAS,'longitude')
		NTAS.position=NTAS.latitude*1i + NTAS.longitude;
		we_have_position=1;
	else 
		NTAS.position=[];
	end
	if verb, disp('position was created'); end
	changed=1;
end

if ~isfield(NTAS,'longitude') && isfield(NTAS,'position')
	NTAS.longitude=lon;
	if verb, disp('longitude was created'); end
	changed=1;
end

if ~isfield(NTAS,'latitude') && isfield(NTAS,'position')
	NTAS.latitude=lat;
	if verb, disp('latitude was created'); end
	changed=1;
end

if isempty(NTAS.position) &&  isfield(NTAS,'latitude') && isfield(NTAS,'longitude') 
	NTAS.position=NTAS.latitude*1i+NTAS.longitude;
	changed=1;
end

% do this again because by now we might have created position but still
% have no Position
if isfield(NTAS,'Position') && ~isfield(NTAS,'position') 
	NTAS.position=m2c(NTAS.Position);
	if verb, disp('position was created'); end
	changed=1;
elseif isfield(NTAS,'position') && ~isfield(NTAS,'Position')
	NTAS.Position=c2m(NTAS.position);
	if verb, disp('Position was created'); end
	changed=1;
end

% and likewise for lat and lon

if ~isfield(NTAS,'lat') && ~isempty(lat)
	NTAS.lat=lat; 
	if verb, disp('lat was created'); end
	changed=1;
end

if ~isfield(NTAS,'lon') && ~isempty(lon)
	NTAS.lon=lon; 
	if verb, disp('lon was created'); end
	changed=1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mfn=fieldnames(meta);

if ~stealth
if changed
    if isfield(NTAS,'meta')
        if iscell(NTAS.meta), 
	    pmeta=NTAS.meta; 
	    NTAS=rmfield(NTAS,'meta');
	    NTAS.meta.meta=pmeta; 
        end
	% keyboard
        for i=1:length(mfn), 
	    NTAS.meta.(new_fieldname(NTAS.meta,mfn{i}))=meta.(mfn{i});
        end
    elseif isfield(NTAS,'META')
        if iscell(NTAS.META), 
	    pmeta=NTAS.META; 
	    NTAS=rmfield(NTAS,'META');
	    NTAS.META.meta=pmeta; 
        end
        for i=1:length(mfn),  
	    NTAS.META.(new_fieldname(NTAS.META,mfn{i}))=meta.(mfn{i});
        end 
    else
	    NTAS.meta=meta;
    end % if isfield(NTAS,'meta')
end % if changed
end % if ~stealth

return

% end of main
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function nfn=new_fieldname(meta,mfn)
	nfn=mfn;
	j=0;
	while isfield(meta,nfn)
		% create new fieldname
		j=j+1;
		nfn=[mfn '_' num2str(j)];
	end
return

function [B,flags]=makefieldsfromyday(A,flags)
	B=A; 
	if ~isfield(B,'year'), 
		if isfield(B,'startyear'), 
			B.year=B.startyear;
			flags.year=true;
		else
			if isfield(B,'mday'),
				V=datevec(B.mday(1)); 
				B.year=V(1); 
				flags.year=true;
			end
		end
	end
	if ~isfield(B,'mday'), 
		if isfield(B,'mdate'), 
			B.mday=B.mdate; 
			flags.mday=true; 
		else
			if isfield(B,'year'),
				B.mday=B.yday+datenum(B.year,1,0); 
				flags.mday=true; 
			end
		end
	end
	if ~isfield(B,'jday'), 
		B.jday=julian(datevec(B.mday)); 
		flags.jday=true; 
	end
return

function [B,flags]=makefieldsfrommday(A,flags)
	B=A; 
	if ~isfield(B,'year'), 
		if isfield(B,'startyear'), 
			B.year=B.startyear;
			flags.year=true;
		else
			V=datevec(B.mday(1)); B.year=V(1); 
			flags.year=true;
		end
	end
	if ~isfield(B,'yday'), 
		B.yday=B.mday-datenum(B.year,1,0); 
		flags.yday=true;
	end
	if ~isfield(B,'jday'), 
		B.jday=julian(datevec(B.mday)); 
		flags.jday=true;
	end
return

function [B,flags]=makefieldsfromjday(A,flags)
	B=A; 
	if ~isfield(B,'mday'), 
		B.mday=datenum(gregorian(B.jday)); 
		flags.mday=true;
	end
	if ~isfield(B,'year'), 
		if isfield(B,'startyear'), 
			B.year=B.startyear;
			flags.year=true;
		else
			V=datevec(B.mday(1)); B.year=V(1); 
			flags.year=true;
		end
	end
	if ~isfield(B,'yday'), 
		B.yday=B.mday-datenum(B.year,1,0); 
		flags.yday=true;
	end
return



