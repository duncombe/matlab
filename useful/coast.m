function [S,Range]=coast(D,R,pen,opts)
%COAST - 	 Plots a coastline on the current plot
%
%USAGE - 	[S,Range]=coast(D,R,pen,opts)
%		S - coast points
% 		Range - range used
%		D - definition string, one of [fhilc]
%		R - range, array [W E S N]
%		If R not specified, uses the current axes limits
%		pen - usual pen indicator. pen==0, then do not
%		      plot anything
%		opts - other options for pscoast
%
%DEPENDENCY - 	Uses a system call (unix) to GMT module pscoast
%
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	2000-05-05
%
% PROG MODS -	2000-06-07: fix the path for the gmt files
%		2000-06-13: reset the axes after the plot
%		2001-02-12: make default pen colour red
%		2001-08-17: upgrade to latest slackware version breaks
%			    sscanf built-in
%		2002-03-31: Try to carry on if GMTHOME not set. Some cosmetics.
%		2002-09-18: Add test for row return from PSCOAST
%		2002-12-05: Return gracefully if PSCOAST not found.
%		2003-02-03: if there is no coast in the range, don't complain
%		2004-03-03: add option to not draw lakes, ocean only (-A0/1/1)
%		2004-09-01: test for pscoast returning longitude > 180
%		2004-11-03: fix misplaced transpose undetected for so long
%		2004-11-03: Note: upgraded to GMT4.0
%		2007-07-09: Add option not to plot, only return values
%		2007-08-19: Add opportunity to provide other
%				options for GMT, eg. -N for national borders,
%				or -I for rivers
% 		2009/01/13: improve help information 
% 		2011-02-11: GMT has been upgraded again and all
% 			calls are broken. Adjusted the arguments to GMT
% 			calls


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

GMTHOME=getenv('GMTHOME');

if isempty(GMTHOME), 
	disp('This m-script requires GMT to be installed');
	disp('and the environment variable GMTHOME to be set.');
	disp('Trying to set GMTHOME to a logical value ("/usr/local/gmt").');
	GMTHOME='/usr/local/gmt';
end;

GMTBIN=[GMTHOME '/bin/'];

if ~exist([GMTBIN 'pscoast']),
	disp('Cannot find command "pscoast". Aborting COAST');
	S=[]; Range=[];
	return;
end;
 
if ~exist('D'), D='i'; end;
if isempty(D), D='i'; end;
if exist('R')~=1, R=[]; end;
if isempty(R), R=axis; end;
if exist('pen')~=1, pen='r'; end;
if ~exist('opts'), opts=[]; end;

Range=sprintf('%g/%g/%g/%g',R);
% disp(Range)


% disp(GMTBIN);
% disp(Range);

if strcmp('auto',D),
	dopts='clihf';
else
	dopts=D;
end;

for D=dopts,
	[w,s]=unix([ GMTBIN 'pscoast -A0/1/1 -R' Range ' -D' D ' -Jx1d '...
	' -m  -W ' opts '| awk ''/^>/{print "999.999\t999.999" }!/^>|^#/{print}'' ' ]);
	if max(size(s))>5000 & max(size(dopts))>1,
		break;
	end;
end;

% disp(D);

% disp(size(s));
if max(size(s))>3000,
% search for carriage return (10) to count the records in the string
	disp([	'Scanning about ' num2str( max(size(find(s==10)))) ...
		' records. This may take long. ']);
	if D~='c', disp(['"D" is "' D '". Consider setting "D" (definition) to "c" (crude).']); end;
end;

% if the unix call worked we can calculate
if w == 0, 
	% disp('Unix call okay');
	[S,COUNT,ERRMSG,NEXTINDEX]=sscanf(s,'%g\t%g\n',[2,inf]);
%	disp(COUNT);
%	disp(size(S));

% if ERRMSG is not empty the sscanf failed; we have to try with our own sscanf
        disp(ERRMSG)
	if max(size(S))==0 & COUNT==0,
		disp('sscanf built-in broken on this operating system: using substitute');
		[S,COUNT,ERRMSG,NEXTINDEX]=sscanf_(s,'%g\t%g\n',[2,inf]);
	end;

	I=find(S>999);
	% if I is empty by now, there is no coast to plot, so we plot nothing
	if ~isempty(I),
		S(I)=NaN.*I;
		[m,n]=size(S); if n>m, S=S'; end;

		% GMT sometimes returns longitudes (S(:,1)) in the range 0:360 
		% instead of -180:180
		if R(1)>maxi(S(:,1)), S(:,1)=S(:,1)+360; end;
		if R(2)<mini(S(:,1)), S(:,1)=S(:,1)-360; end;
		hold on;

		if ~exist('pen'),
			plot(S(:,1),S(:,2));
			axis(R);
		else
			if pen~=0,
				plot(S(:,1),S(:,2),pen);
				axis(R);
			end;
		end;

	end;
else
	disp('Unix call to GMT failed');
end;

return;

