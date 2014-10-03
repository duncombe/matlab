function [HEADER, STPC, EOD, BOTTLE, EOB, TAILER] = sfripart(str)
% SFRIPART -	Loads SFRI ascii CTD data and splits into into 
%		constituent parts. Each SFRI CTD data file 
%		consists of parts: 
% 			a header block, 
%			a CTD data block, 
%			an EOD marker ([-1 -1 -1 -1]), 
%			bottle data, 
%			an EOD marker ([-2 -2 -2 -2]), and 
%			a tailer block.
%
% USAGE - 	[header, STPC, EOD, bottle, EOB, tailer] = sfripart(str)
%		Input:	str - filename string
%		Output:	header - ascii string containing header block
%			STPC - Salt, temp, pressure matrix
%			EOD - -2 -2 -2 -2
%			
%			
%			
%			
%			
%			
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 96-09-05, sfri
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
% 


% open data file

	fidd = fopen(str);
	HEADER = []; 
	STPC = [];
	EOD = [];
	EOB = [];
	BOTTLE = [];
	TAILER = [];

% get first header from file

	for i = 1:17, 
		rec=fgets(fidd); 
		HEADER = [ HEADER, rec ]; 
	end;

% load the data into D

	mark=0;	
	rec = fgetl(fidd);

	while ~mark,
		D = sscanf(rec,'%g');
		if ( size( find(D==-1),1) >=4) | ( size( find( D==-2 ),1 ) >=4 ), 
			mark = 1;
			EOD = rec;
		else
			[STPC,D] = samerows(STPC,D);
			STPC = [STPC,D];
			rec = fgetl(fidd);
		end;
	end;

	BOTTLE = [];
	mark = 0;	

	rec = fgets(fidd);
	if rec(1)~='#',
		while ~mark,
			D = sscanf(rec,'%g');
			if (size(find(D==-1),1) >=4), 
				mark=1;
				EOB=rec;
				rec=fgets(fidd);
			else
				[BOTTLE,D] = samerows(BOTTLE,D);
				BOTTLE=[BOTTLE,D];
				rec=fgetl(fidd);
			end;
		end;
	end;

	while ~feof(fidd),
		TAILER = [TAILER, rec];
		rec=fgets(fidd);
	end;

end;


% go back

	fclose(fidd);
	return;

