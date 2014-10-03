function [m,mt,ft]=sizeof(var)
%SIZEOF - 	returns the size in bytes of the argument
% 
%USAGE -	m=sizeof(var)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2007/09/21   
%
%PROG MODS -	
%  2012-01-13 
% 	This function can easily be replaced by a simple ML command. So I
% 	am not sure why it was written this way which is a convoluted,
% 	difficult algorithm for doing something akin to:
% 		a=whos('var'); m=a.bytes; 
% 	There is possibly a reason for it, but right now I don't remember
% 	what. So I am replacing the function. Possibly there is a need for
% 	the type names to be obtained which are not so easily replaced.
% 	Anyway if anythinhg breaks, you know what to do! (Fix it, of
% 	course!)
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

mtypes={ 'uchar', 'schar', 'int8', 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64', 'single', 'float32', 'double', 'float64'};
fctypes={ 'unsigned char', 'signed char', 'integer*1', 'integer*2', 'integer*4', 'integer*8', 'integer*1', 'integer*2', 'integer*4', 'integer*8', 'real*4', 'real*4', 'real*8', 'real*8'};

a=whos('var');
m=a.bytes;
mt=a.class;
I=find(strcmp(a.class,mtypes));
if ~isempty(I),
	ft=fctypes{I};
else	
	ft=[];
end


% byte=8;
% 
% mtypes={ 'uchar', 'schar', 'int8', 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64', 'single', 'float32', 'double', 'float64'};
% fctypes={ 'unsigned char', 'signed char', 'integer*1', 'integer*2', 'integer*4', 'integer*8', 'integer*1', 'integer*2', 'integer*4', 'integer*8', 'real*4', 'real*4', 'real*8', 'real*8'};
% sizes= [ 8 , 8 , 8 , 16 , 32 , 64 , 8 , 16 , 32 , 64 , 32 , 32 , 64 , 64 ];
% 
% % array size
% n=numel(var);
%  
% for i=1:length(sizes),
%        if isa(var,mtypes{i}) || isa(var,fctypes{i}),
%               m=n.*sizes(i)./byte;
%               mt=mtypes{i};
%               ft=fctypes{i};
%               return;
% %        elseif isa(S,'struct') || isa(S,'cell')
% % 		
%        end;
% end;
% disp('type of ''arg1'' not found');
% return;
% 
% 
