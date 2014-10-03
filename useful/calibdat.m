function [SL,IN,STATS]=calibdat(DATA,NI,Z,TITLESTR,RANGE)
% CALIBDAT - 	discards outliers and returns linear regression 
%		slope and intercept for sensor calibration
% 
% USAGE -	[SL,IN,STATS]=calibdat(DATA,NI,Z,TITLESTR,RANGE)
%
% EXPLANATION -	DATA - first column sensor readings, second column
%		       calibration values
%		NI Number of iterations of discarding points
%		Z - Standard error widths to discard
%		SL - slope of the least squares best fit regression
%		     line after N iterations of discarding points
%		     lying greater than Z standard errors from 
%		     the mean
%		IN - intercept of the regression line 
%		TITLESTR - title string for the plot
%		RANGE - nominal range for the plot. If RANGE is the keyword 
% 			'salinity' or salinity is found in TITLESTR,
%			the range defaults to [34, 36]. Similarly if 
%			the keyword 'oxygen' is found in TITLESTR, or RANGE 
%			is the keyword 'oxygen' then the range defaults to 
%			[0, 10]. Otherwise RANGE should be a valid argument
%			for the 'axis' function.
%		STATS=[SL,IN,N,RSQU,STERR,SLERR,INERR] - vector returned with
%			SL slope
%			IN intercept
%			N number of points
%			RSQU - pearson correlation coefficient
%			STERR - standard error in the estimate
%			SLERR - error inn the slope
%			INERR - error in teh intercept
%
% SEE ALSO -	REGRESS, REGRPLOT
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	2000-05-30
%
% PROG MODS -	2000-06-28 Cosmetics
%		2001-01-16 Default ranges added
%		2001-12-14 Info out
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

DefaultSaltRange=[34,36,34,36];
DefaultOxyRange=[0,10,0,10]; 
x=DATA(:,1);
y=DATA(:,2); 
Nin=length(x);

if ~exist('TITLESTR'), TITLESTR=[]; end;
if exist('RANGE')~=1,
	if findstr(lower(TITLESTR),'salinity'),
		RANGE='salinity';
	elseif findstr(lower(TITLESTR),'oxygen'),
		RANGE='oxygen';
	else
	RANGE='auto';
	end;
end;

if isstr(RANGE) & strcmp(lower(RANGE),'salinity'), RANGE=DefaultSaltRange; end;
if isstr(RANGE) & strcmp(lower(RANGE),'oxygen'), RANGE=DefaultOxyRange; end;
if length(RANGE)~=4, disp('RANGE is argument for axis(). Vector must be length 4'); end;

TITLESTR=[TITLESTR ' Calibration'];

if ~exist('NI'), NI=[]; end;
if isempty(NI), NI=1; end;
if ~exist('Z'), Z=[]; end;
if isempty(Z), Z=2; end;

% Do a regression

[SL,IN,N,RSQU,STERR,SLERR,INERR]=regress(x,y);

figure; plot(x,y,'.');
	hold on; 
	% regrplot(SL,IN,STERR);

for i=1:NI,

% Remove points > 2 std error
	Est=x.*SL+IN;
	I=find(abs(y-Est)<=STERR.*Z);

% Do the regression again on the good points
	[SL,IN,N,RSQU,STERR,SLERR,INERR]=regress(x(I),y(I));
	x=x(I); y=y(I);
end;

Nout=length(x);

	plot(x,y,'g.');
	axis(RANGE);

	regrplot(SL,IN,STERR,'b');

place='topright';
if SL>=0, place='topleft'; end;
if NI==0, cyclestr=[] ; else cyclestr=[' at ' num2str(Z) ' x StdErr']; end;
H=annotate(place,[ ...
		  'Discard Cycles:  ' num2str(NI) cyclestr 10 ...
		  num2str(Nin-Nout) ' points discarded from ' num2str(Nin) ...
		  ' (' num2str(round((Nin-Nout)./Nin.*100)) '%)' 10 ...
		  'Slope:     ' sprintf('%.5f',SL) 10 ...
		  'Intercept: ' sprintf('%.5f',IN) 10 ...
		  'Std Error: ' sprintf('%.5f',STERR) 10 ...
		  'R-Square:  ' sprintf('%.4f',RSQU) 10 ...
		  'N:         ' num2str(N) 10 ...
		]);

for i=H,
	set(i,'FontName','Courier');
end;
	title(TITLESTR);
	xlabel('Sensor Reading');
	ylabel('Calibration Value');

STATS=[SL,IN,N,RSQU,STERR,SLERR,INERR];

return;

