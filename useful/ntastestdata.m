function  ntastestdata(DATA)	% {{{
%NTASTESTDATA - does some basic QC checks on data structure	
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-07-19 
%	$Revision: 1.2 $
%	$Date: 2012-08-22 12:49:06 $
%	$Id: ntastestdata.m,v 1.2 2012-08-22 12:49:06 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
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

% assume that the structure is a valid data structure that has been passed
% through, e.g., ntascheckmat, so that all required vars are here

if exist('DATA','var')~=1, % we are called with no argument
	help(mfilename);
	return
elseif exist(DATA,'file')==2, % we have a filename
	DATA=ntascheckmat(DATA);
elseif ~isstruct(DATA), % we have something we don't recognise
	error('Called with unrecognized argument');
end

% make some vars easy to work with
yday=DATA.yday;
mday=DATA.mday;
dt=diff(mday);
temp=DATA.temp;

% see how badly the timebase is fucked up
figure; plot(mday);

figure; plot(diff(mday)); 

figure; boxplot(mday);

t=tabulate(dt);

I=find(t(:,1)<0); 
if ~isempty(I),
	disp(['There are ' num2str(sum(t(I,2))) ' time reversals']);
end

figure; plot(t(:,1),t(:,2),'.-');
	xlabel('time differences (days)');
	ylabel('occurrences');


% lets look at everything else

FNS={ 'east', 'north', 'temp', 'press', 'depth', 'spd', 'dir' };

for i=1:length(FNS)
	if isfield(DATA,FNS{i}),
	    if size(DATA.(FNS{i}))==size(yday),
		figure; plot(yday,DATA.(FNS{i}));
			% datetick;
			title(FNS{i});
			xlabel('Date');
			ylabel([ FNS{i} ]);

		figure; plot(ave(yday),diff(DATA.(FNS{i})));
			% datetick;
			title(FNS{i});
			xlabel('Date');
			ylabel([ '\Delta' FNS{i} ]);
	    end
	end
end


