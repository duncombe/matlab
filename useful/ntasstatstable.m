function ntasstatstable(AD,statsfname)

if exist('AD')~=1, 
	error('need currents data structure to create table');
end

if exist('statsfname') ~=1, statsfname=[]; end
if isempty(statsfname), statsfname=1; end 

if ischar(statsfname),
	fid=fopen(statsfname,'w');
	[fpath,fname,fext,fvers]=fileparts(statsfname);
else
	fid=statsfname;
	[fpath,fname,fext,fvers]=deal('');
end;

% make up the stats vectors
% care of nans

North=[nanmean(AD.north) nanstd(AD.north) min(AD.north) max(AD.north)];
East=[nanmean(AD.east) nanstd(AD.east) min(AD.east) max(AD.east)];
Spd=[nanmean(AD.spd) nanstd(AD.spd) min(AD.spd) max(AD.spd)];

II=find(~isnan(AD.dir)); 
Dir=[	wrapTo360(d_circ_mean(AD.dir(II)))	...
	d_circ_std(AD.dir(II))	...
	min(wrapTo360(AD.dir(II)))	...
	max(wrapTo360(AD.dir(II)))];

%       f(cpd)	T(d)	T (h)	I 
if ~isempty(fid),
	if regexp(fext,'tex'),
	    fprintf(fid,'\\begin{tabular}{cccc}\n');
 	    fprintf(fid,' & & Value & StdDev & \\multicolumn{2}{c}{Range} \\\\\n');

	    fprintf(fid, [ AD.experiment '& North: & %.1f  & %.1f & %.1f & %.1f	\\\\\n' ...
		      '(' num2str(AD.depth) ' m)& East: & %.1f  & %.1f & %.1f & %.1f	\\\\\n' ...
			AD.instrument '& Spd: & %.1f  & %.1f & %.1f & %.1f	\\\\\n' ...
			'& Dir: & %.1f & %.1f & %.1f & %.1f	\\\\\n'], ...
			[North, East, Spd, Dir]) ;
	    fprintf(fid,'\\end{tabular}\n');
	else
 	    fprintf(fid,'          Value   StdDev   Min   Max \n'); 
	    fprintf(fid, [ AD.experiment ' North:  %.1f   %.1f  %.1f  %.1f	\n' ...
		      '(' num2str(AD.depth) ' m)  East:  %.1f   %.1f  %.1f  %.1f	\n' ...
			AD.instrument '  Spd:   %.1f    %.1f   %.1f   %.1f	\n' ...
			'  Dir:   %.1f   %.1f   %.1f   %.1f	\n'], ...
			[North, East, Spd, Dir]) ;
	end
end 

if fid>2, fclose(fid); end

    %[ W   	1./W  	24./W	10.^Z ];


