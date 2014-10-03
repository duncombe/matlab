function  ntasdatacompare(A,B)	% {{{
%NTASDATACOMPARE - compare two data structures
% 
%USAGE -	ntasdatacompare(Ain,Bin)	
%
%EXPLANATION -	The purpose of NTASDATACOMPARE is to answer the question
% 		``Are these two data structures identical?'', and, if they
% 		are different, possibly to also answer ``Are they just a
% 		little bit different, or are they two completely different
% 		things?''.  The precursor of this function is NTASCOMPARE
% 		which is intended to compare two different current meter
% 		records and to plot spectra and time series of both records
% 		on the same axes to aid analysis. 
%
%SEE ALSO -	ntascompare
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2012-07-20 
%	$Revision: 1.1 $
%	$Date: 2012-07-20 13:59:27 $
%	$Id: ntasdatacompare.m,v 1.1 2012-07-20 13:59:27 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 	adding to help text
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

% NO!
% % Check these are clean data sets. Also deals with if they are filenames
% % instead of structures
% do not check here. MUST call with prechecked structures. (Will allow
% recursive use of function.)
% A=ntascheckmat(Ain);	
% B=ntascheckmat(Bin);	

if isstruct(A)~=1 || isstruct(B)~=1
	error('Compare structures only')
end


Aflds=fieldnames(A);
Bflds=fieldnames(B);

Cflds=intersect(Aflds,Bflds);
[c,ai,bi]=setxor(Aflds,Bflds);
if ~isempty(ai), 
	disp('Fields that are in A but not in B: ');
	disp(Aflds(ai));
end

if ~isempty(bi), 
	disp('Fields that are in B but not in A: ');
	disp(Bflds(bi));
end

for i=1:length(Cflds)
	if isstruct(A.(Cflds{i}))
		ntasdatacompare(A.(Cflds{i}), B.(Cflds{i}));
	else
		if A.(Cflds{i})~=B.(Cflds{i})
			disp([Cflds{i} ' differ in A and B']);
		end
	end
end


