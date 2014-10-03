function [A,I]=sortstr(SM) % {{{
%SORTSTR - 	Sorts a string matrix
% 
%USAGE -	[A,I]=sortstr(SM)
%
%EXPLANATION -	SM - string matrix
%		A - sorted string matrix
%		I - index A=M(I,:)
%
%SEE ALSO -	sort, sortrows
%
%NOTE -
% 	Built-in sort sorts individual columns, making a mess of
% 	a character array arranged as strings in rows. Built-in
% 	sort does work on cell array of strings. 
% 	Algorithm is to turn each row into a base(256) number and
% 	sort the numbers. 


% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae {{{
%
%CREATED -	2002-12-05
%	$Revision: 1.5 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: sortstr.m,v 1.5 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%PROG MODS -
%  2002-12-06
% 	rewritten with a MUCH better algorithm!
%  2011-04-06 
% 	make it work for cells too
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

M=char(SM);

[m,n]=size(M);
mult=256.^[n-1:-1:0];
[a,I]=sort(abs(M)*mult.');

if iscell(SM),
	A=SM(I);
else
	A=M(I,:);
end;

return;

