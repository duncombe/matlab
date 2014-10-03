function ntaspeaktable(peaks,peakfname)

if exist('peaks')~=1, 
	error('need peak data to create table');
end

if exist('peakfname') ~=1, peakfname=[]; end
if isempty(peakfname), peakfname=1; end 

if ischar(peakfname),
	fid=fopen(peakfname,'w');
	[fpath,fname,fext,fvers]=fileparts(peakfname);
else
	fid=peakfname;
	[fpath,fname,fext,fvers]=deal('');
end;

fpeaks=peaks.f;
pkhgt=peaks.dens;
dpth=peaks.depth;

%       f(cpd)	T(d)	T (h)	I 
if ~isempty(fid),
	if regexp(fext,'tex'),
	    fprintf(fid,'\\begin{tabular}{cccc}\n');
 	    fprintf(fid,['\\multicolumn{4}{c}{Top 15 Peak Frequencies (']);
		if isfield(peaks,'experiment')
			fprintf(fid,[peaks.experiment ' ']);
		end
		if isfield(peaks,'instrument')
			fprintf(fid,[peaks.instrument ' ']);
		end
	    fprintf(fid,[num2str(dpth) ' m)} \\\\\n' ...
		' f (cpd) &  T (day) & T (hr) & PeakHgt ($\\textrm{cm}^2\\cdot\\textrm{s}^{-2}$) \\\\\n' ] );
 	    fprintf(fid,['%9.5f & %10.5f & %10.5f & %6.3f\\\\\n'],  ...
	 	[fpeaks(1:15), 1./fpeaks(1:15), ...
		24./fpeaks(1:15), pkhgt(1:15)].');
	    fprintf(fid,'\\end{tabular}\n');
	else
 	    fprintf(fid,['Top 15 Peak Frequencies\n  f (cpd)\t' ...
		'   T (day)\t    T (hr)\tPeakHgt (cm^2/s^2)\n' ] );
 	    fprintf(fid,['%9.5f\t%10.5f\t%10.5f\t%6.3f\n'],  ...
	 	[fpeaks(1:15), 1./fpeaks(1:15), ...
		24./fpeaks(1:15), pkhgt(1:15)].');
	end
end 

if fid>2, fclose(fid); end

    %[ W   	1./W  	24./W	10.^Z ];


