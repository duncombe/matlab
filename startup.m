% startup routine
%%%%%%%%
% 
% a note on starting up
% 	to use netcdf, you need to have java engine, therefore cannot use
% 	option -nojvm when starting. Can still use -nosplash to avoid
% 	waiting for the splash screen and -nodesktop to force a launch to
% 	the terminal instead of the graphic interface.  If you do not need
% 	netcdf, then you need to change this startup to not call the
% 	javaaddpath to avoid an error condition.
%%%%%%%%
% 
% Add some directories to the path
%
%path( path, '/usr/local/src/matlab/toolbox/extras' );

initialize

% neutral density programs required by AOML/ctdcal
% path( path, [HOME 'matlab/neutral/gamma/matlab-interface'] );
PATHADDITION=fullfile(HOME,'matlab','neutral','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
else
	disp([PATHADDITION ' does not exist'])
end

% m2html generates documentation for mfiles 
PATHADDITION=fullfile(HOME,'matlab','m2html','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
else
	disp([PATHADDITION ' does not exist'])
end

% this is for seawater equation of state functions
PATHADDITION=fullfile(HOME,'matlab','seawater','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
else
	disp([PATHADDITION ' does not exist'])
end

% the equation of state has been updated. TEOS10.
PATHADDITION=fullfile(HOME,'matlab','gsw','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION ); 
else
	disp([PATHADDITION ' does not exist'])
end

% this is for mapping functions
PATHADDITION=fullfile(HOME,'matlab','m_map','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
else
	disp([PATHADDITION ' does not exist'])
end

% I don't think I ever used stixbox for anything
PATHADDITION=fullfile(HOME,'matlab','stixbox','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
else
	disp([PATHADDITION ' does not exist'])
end

% path( path, [HOME 'matlab/mysignal'] );

% I don't think I ever used saga for anything
% PATHADDITION=fullfile(HOME,'matlab','saga','');
% if exist(PATHADDITION,'dir')
% 	path( path, PATHADDITION );
% else
% 	disp([PATHADDITION ' does not exist'])
% end

% I am definitely using LIBRA, for AOML CTD data reports
PATHADDITION=fullfile(HOME,'matlab','LIBRA','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION ); 
else
	disp([PATHADDITION ' does not exist'])
end

% circular statistics toolbox
% path( [HOME 'matlab' filesep 'circStat2009'], path );
PATHADDITION=fullfile(HOME,'matlab','CircStat','');
if exist(PATHADDITION)
	path( PATHADDITION, path );
else
	disp([PATHADDITION ' does not exist'])
end

% best straight line regression (york et al)
PATHADDITION=fullfile(HOME,'matlab','york_curve_fit_0_01','');
if exist(PATHADDITION,'dir')
	path( fullfile(HOME,'matlab','york_curve_fit_0_01',''), path );
else
	disp([PATHADDITION ' does not exist'])
end


% % Directional Analysis toolbox (Not for runtime! IOW, kak!)
% path( [HOME 'matlab' filesep 'DirectionalAnalysis'], path );

% this is my useful functions
PATHADDITION=fullfile(HOME,'matlab','useful','');
if exist(PATHADDITION)
	path( PATHADDITION, path );
else
	disp([PATHADDITION ' does not exist'])
end

% this is for working with netcdf files (jain/hdmodel/hgui)
PATHADDITION=fullfile(HOME,'matlab','mexcdf');
if exist(PATHADDITION)
	path( fullfile(PATHADDITION, 'mexnc',''), path );
	path( fullfile(PATHADDITION, 'snctools',''), path );
	if isempty(javachk('jvm'))
		javaaddpath(fullfile(PATHADDITION,'netcdfAll-4.1.jar'));
	end
else
	disp([PATHADDITION ' does not exist'])
end
% 

path( fullfile(HOME,'matlab',''), path );

% path( path, [HOME 'matlab/acklam_utils/datautil'] );
% path( path, [HOME 'matlab/acklam_utils/fileutil'] );
% path( path, [HOME 'matlab/acklam_utils/graphutil'] );
% path( path, [HOME 'matlab/acklam_utils/imgutil'] );
% path( path, [HOME 'matlab/acklam_utils/mathutil'] );
% path( path, [HOME 'matlab/acklam_utils/matutil'] );
% path( path, [HOME 'matlab/acklam_utils/numutil'] );
% path( path, [HOME 'matlab/acklam_utils/polyutil'] );
% path( path, [HOME 'matlab/acklam_utils/statutil'] );
% path( path, [HOME 'matlab/acklam_utils/strutil'] );
% path( path, [HOME 'matlab/acklam_utils/sysutil'] );
%
% Please leave a note if you find out why I wanted to use acklam_utils
% And this is now commented out of the path so that what breaks will 
% remind me why I need it.
%
% path( path, [HOME 'matlab/acklam_utils/timeutil'] );

% % ctd data calibrations for AOML; We are done with these, remove them from the path
% path( path, [HOME 'WORK/AOML/CTD/ctdcal'] );
% path( path, [HOME 'WORK/AOML/CTD/ctdcal/CMDR'] );
% setpref('ctd_calibration','dir',[HOME 'WORK/AOML/CTD/CALIBRATIONS']);
PATHADDITION=fullfile(HOME,'matlab','ctdcal','');
if exist(PATHADDITION)
	path( path, PATHADDITION );
end

PATHADDITION=fullfile(HOME,'matlab','ctdcal','CMDR','');
if exist(PATHADDITION)
	path( path, PATHADDITION );
end

% Now working at WHOI on wave data analysis; other data processing
PATHADDITION=fullfile(HOME,'matlab','Wave_Software','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
end

PATHADDITION=fullfile(HOME,'matlab','WHOI_Data_Proc','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
end

PATHADDITION=fullfile(HOME,'matlab','WHOI_Data_Proc','RDI_processing','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
end

PATHADDITION=fullfile(HOME,'matlab','WHOI_Data_Proc','Nortek','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
end

% For tidal analysis trying to use Rich Pawlowicz T_TIDE toolbox
PATHADDITION=fullfile(HOME,'matlab','t_tide','');
if exist(PATHADDITION,'dir')
	path( path, PATHADDITION );
end


% path( '/home/asttex/matlab' , path );
% path( path , '/home/asttex/matlab' );

% Modifications for working with deirdre's software and the asttex data.
% Must put the asttex routines and scripts first
%% Remember these useful commands
% rmpath  /home/asttex/matlab
% addpath /home/asttex/matlab
addpath /usr/bin

%
%
% whitebg( 0, 'w' );
%
% Note: use set(0, 'default*') to get an inkling what can be set
%
% FIGURE defaults
set( 0, 'DefaultFigurePosition', [520 166 497 576]);
% set( 0, 'DefaultFigurePaperType', 'a4letter' );
set( 0, 'DefaultFigurePaperType', 'usletter' );
%
% AXES defaults
set( 0, 'DefaultAxesXGrid', 'on' );
set( 0, 'DefaultAxesYGrid', 'on' );
set( 0, 'DefaultAxesZGrid', 'on' );
%
set( 0, 'DefaultAxesLineWidth', 1 );
set( 0, 'DefaultAxesBox', 'on' );
%
% LINE defaults
set( 0, 'DefaultLineLineWidth', 1 );
set( 0, 'DefaultLineMarkerSize', 12 );
%
% TEXT defaults (Helvetica is proportional, Courier is fixed)
set( 0, 'DefaultTextFontName', 'Helvetica');
% set( 0, 'DefaultTextFontName', 'Courier');
% 
% PATCH defaults 
set(0, 'DefaultPatchEdgeColor','none'); % to set default shading flat 
					% for surface and pcolor

% start a diary with some kind of unique name, and put them all in one place.
LOGFILE=fullfile(LOGDIR, [ 'matlab.' sprintf('%04d%02d%02d-%02d%02d%07.4f',datevec(now)) '.log']);
diary(LOGFILE);

% if we have some local requirements, put them in an mfile in
% the cwd. 

if exist(fullfile('.','local.m')), local; end;

% now tell where we are (so that the logging file knows), and say
% something about the toolboxes etc.
% ver is going to give a lot of information that we don't want to
% look at right away. Turn off more's stop/start nonsense.
more off;

ver
disp(['Running on host: ' HOST]);
disp(['Starting in directory: ']);
disp(pwd);

% functions do not have access to the library functions in the
% toplevel space. Revert to mfile functions.
% disp('loading library functions');
% funlib

disp('done with startup');

more on;

% vi: se nowrap tw=0 :

