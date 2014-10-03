function S=stringpos(P)	% {{{
%STRINGPOS - 	returns a string representing the given position
% 
%USAGE -	S=stringpos(P)
% 
%
%EXPLANATION -	P is a complex position vector (1i * latitude + longitude)
% 		S is a cell array with two strings DD MM.MMM H
% 
%
%SEE ALSO -	PARSEPOS
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2013-03-06 
%	$Revision: 1.3 $
%	$Date: 2013-04-01 06:28:49 $
%	$Id: stringpos.m,v 1.3 2013-04-01 06:28:49 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2013-03-22 
% 	Edits to help text
%  2013-03-31 
% 	make it work on a vector
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

n=length(P);

S=cell(n,2);

for i=1:length(P)

	h='';
	long=real(P(i));
	if long<0, h='W'; elseif long>0, h='E'; end
	dd=fix(abs(long)); mm=(abs(long)-dd)*60;

	LONG=sprintf('%03d %06.3f %s',dd,mm,h); 

	h='';
	lati=imag(P(i));
	if lati<0, h='S'; elseif lati>0, h='N'; end
	dd=fix(abs(lati)); mm=(abs(lati)-dd)*60;

	LATI=sprintf('%02d %06.3f %s',dd,mm,h); 

	S(i,:)={LONG,LATI};

end

