% 
% Hints and Tips
% 
% Using variables and strings
% ---------------------------
% 
% You know that
% >> load filename.dat
% loads the file filename.dat and puts the data in the variable
% filename. Well, load('filename.dat') does exactly the same job.
% >> which command
% returns the pathname of command.m. So does which('command'), but 
% although you can do 
% fn=which('command'); 
% to access the path, matlab complains if you do fn=which command.
% 
% Generating text labels
% ----------------------
% 
% Making a string to use in text(x,y,str)
% can be a problem. Using num2str is complicated and confusing.
% Better is str=[reshape(sprintf('%3d',labels),3,size(labels,1))]';
% This will give the right matrix.
% 
% Dealing with defaults
% ---------------------
%
% get(0,'default*') gets the default settings at the appropriate level
% 
%
% Referencing matrix elements
% ---------------------------
% 
% A script like [I,J]=find(X) returns vectors of row and column
% indices. To refer back to the X(I,J) in a usable manner use
% (J-1).*m+I where [m,n]=size(X); 
% 
% Miscellaneous
% -------------
%
% clc - clear the command screen
%
% 
% Contour matrix
% --------------
%
% is a vector of C(2,:). C(1,1) specifies the level of the
% contour, C(2,1) specifies how many points follow.
% C(:,2:C(2,1)+2) then define that contour. 
% Contours lines i can be calculated by looping through 
%     j=j+1; i(j)=C(2,sum(i(1:j-1))+j);
%     



% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% CREATED -	
%
% PROG MODS -	
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
help hints
return;
