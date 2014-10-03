function mchk(a,b)
% MCHK - 	checks if multiplication of matrices will work
%
% USAGE -	mchk(a,b)
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	1995
%
% PROG MODS -	1999-09-07 Cosmetics and calculate number of elts
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

[ma,na]=size(a);[mb,nb]=size(b);
disp([	'Sizes are: [' sprintf('%i',ma) ',' ...
	sprintf('%i',na) ']*[' sprintf('%i',mb) ',' ...
	sprintf('%i',nb) ']']);


if (ma==1 & na==1) | (mb==1 & nb==1), 
	disp('Multiplication by scalar');
elseif na==mb,
	disp([	'You will get a matrix ['  ...
		sprintf('%i',ma) ',' sprintf('%i',nb) ']' ...
		' consisting of ' sprintf('%i',ma.*nb) ' element(s).' ]); 
else,
	disp('You will get an error message!');
end;

return;

