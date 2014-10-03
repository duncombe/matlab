function showme(DATA,name,detail)
%SHOWME - displays the data structure, does some first look plotting
% 
%USAGE -	 showme(DATA,name,detail)
%
%EXPLANATION -	DATA - structure
% 		name - provide a name for the structure for
% 			consistent naming.
% 		detail - to plot arrays or not ['plot'|'noplot'].
% 			default is to 'plot'
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2010/12/09 
%	$Revision: 1.10 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: showme.m,v 1.10 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2011/01/24 
% 	specify not to plot (in case structure very large, all memory will be
% 	used up)
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
% 

% trying to set the default interpreter
set(0,'DefaultTextInterpreter','none');

if exist('name')~=1, name=[]; end;
if isempty(name), name=inputname(1); end;

if exist('detail')~=1, detail=[]; end;
if isempty(detail), detail='plot'; end;

if strcmp(detail,'plot'),
	qual=[];
else
	qual='not ';
end;

% if exist('plottype')~=1, plottype='plain'; end; 

if isstruct(DATA),
	% test if DATA is an array
	fnames=fieldnames(DATA);
	[m,n]=size(DATA);
	if max([m,n])>1,
		disp([name ' is a structure array (' num2str(m) 'x' num2str(n) ')' ]);
		% try to turn the structure array into a numeric matrix
		for f=1:length(fnames),
		  B=arrayfun(@(x)(x.(fnames{f}).'),DATA,'UniformOutput',false);
		  showme([B{:}].', [name '.' fnames{f}], detail);
		end;
	else
	    for f=1:length(fnames),
		% try
		  showme(DATA.(fnames{f}), [name '.' fnames{f}], detail);
		% catch 
		  % disp([name '.' fnames{f}]);
		  % rethrow(lasterror)
		% end
		
	    end;
	end;
elseif ischar(DATA),
	[m,n]=size(DATA);
	if min([m,n])>1, 
		fprintf('%s = char array(%d,%d)\n', name, m, n);
	else
		disp([name ' = ' DATA]);
	end;

elseif iscell(DATA),
	% disp([name ' =  cell (WTF do I do now?)']);
	for f=1:length(DATA),	
		showme(DATA{f},[name '{' num2str(f) '}'], detail);
	end;

else
	% class(DATA)
	if max(size(DATA))==1,
		disp([name ' = ' num2str(DATA) ] );
	else
	    [m,n]=size(DATA);
	    if isreal(DATA),
		disp([name ' = real array(' num2str(m) ',' num2str(n) ') ' qual 'plotted'] );
		if strcmp(detail,'plot'),
			figure;
				plot(DATA);
				title(name);
		end;
	    else
		disp([name ' = complex array(' num2str(m) ',' num2str(n) ') ' qual 'plotted'] );
		if strcmp(detail,'plot'),
			figure;
				subplot(2,2,1);
					plot(DATA);
					title('complex')
				subplot(2,2,2);
					plot(imag(DATA));
					title('imaginary part')
				subplot(2,2,3);
					plot(real(DATA));
					title('real part')
				mtit(name);
		end;
	    end;
	end;
end;

return;

