function [DIR,N]=dirlist(expr)
%DIRLIST - 	parses an expression and returns a directory listing
%		that can be used to read data from files
% 
%USAGE -	DIR=dirlist(expr)
%
%EXPLANATION -	DIR - text matrix accessible with strtok
%		expr - regular expression, filename, listing file
%
%SEE ALSO -	
%
%USED BY -	views87s
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2001-10-17
%
%PROG MODS -	2002-12-05: if expr was a directory, DIR contained inaccessible
%			filenames. A bunch of tests required.
%		2003-10-06: if expr was a text matrix, such as filenames
%			from a previous views87s, dirlist failed.
%		2003-11-25,27: bugfixes. counting files, expressions, lists
% 		2008/09/09: would return something in DIR even if
% 		there was no files matching (new matlab
% 		version?). fixed so that DIR returns empty if
% 		there are no files.
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

% If expr is not a vector then it may be an text matrix. On trying to 
% process a matrix the script will barf anyway. So we assume it's a stack of 
% filesnames in a matrix and make it into something the rest of the 
% script will process happily or barf trying.

if min(size(expr))>1,
	% F=expr.';
	disp('straightening the matrix directory listing you gave me');
	F=[ expr.'; 32+zeros(1,size(expr,1)) ];
	expr=F(:).';
end;

expr_exists=exist(expr);

if ~exist('labl'), labl=0; end;
if ~exist('rd'), rd=0; end;

stat=0;
N=0;

% dirid=fopen('dir.txt');

%%%%%%% expr is a file!!
if expr_exists==2,
        f = fopen( expr );
        if f==-1,
                disp(['Cannot open file ' expr ...
                '. Disk full or permission problem?']);
        else
                stat=0;
        end;
% if the first line of expr (a file) is another file, then expr contains a list
        DIR = [fgetl(f)];
        if ~exist(DIR),
                expr_is_not_a_list=1;
                DIR=[expr 10];
		% N=1;
        else
                expr_is_not_a_list=0;
                while ~feof(f), DIR = [DIR 10 fgetl(f) ]; end;
		DIR = [DIR 10];
		% I=find(real(DIR)==10);
		% N=max(size(I))+1;
        end;
        fclose( f );
else

%%%%%% expr is not a file!! it  must be a regex 
if strcmp(computer,'PCWIN'),
        i=-1; dn='dir.tmp';
        while exist(dn)==2, i=i+1; dn=['dir' num2str(i) '.tmp']; end;
        dos(['dir /b ' expr ' > ' dn ' |']);
        DIR=[];
        f = fopen( dn );
        if f==-1,
                disp(['Cannot open file ' dn ...
                '. Disk full or permission problem?']);
        end;
        while ~feof(f), DIR = [DIR 10 fgetl(f)]; end;
        fclose( f );
        dos(['del ' dn ]);
% disp(['Cannot get directory listing with Win3.1, Win95, or Win98.' 10 ...
%       'Please use UNIX Matlab version.']);
else
        [stat,DIR]=unix(['ls -1 ' expr ]);
        if stat & isempty(DIR),
                disp(['No files ' expr ' found in ' pwd '(' num2str(stat) ')']);
	else
	%
	% if expr is a directory name, then DIR ends up with 
	% inaccessible filenames. Rebuild DIR.
	%
		tf=strtok(DIR);
		if ~exist(tf),
			tf=[expr '/' tf]; 
			if exist(tf),
				NDIR=[];
				while ~isempty(DIR),
					[tf,DIR]=strtok(DIR);
					if ~isempty(tf), 
						NDIR=[NDIR expr '/' tf 10];
					end;
				end;
				DIR=NDIR;
				% DIR=strrep(DIR,10,[expr '/']);
			else
				disp(['Can find no files matching ' expr ]);
				DIR=[];
			end;
		end;

        end;
	% expr can be a directory which returns bad names
	% in that case we must construct good file names

end;

end;	% The end of the expr_exists block

	I=find(real(DIR)==10);
	N=max(size(I));
	
return;
% 
