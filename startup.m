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
path( path, fullfile(HOME,'matlab','neutral','') );

% m2html generates documentation for mfiles 
path( path, fullfile(HOME,'matlab','m2html','') );

% this is for seawater equation of state functions
path( path, fullfile(HOME,'matlab','seawater','') );

% the equation of state has been updated. TEOS10.
path( path, fullfile(HOME,'matlab','gsw','') ); 

% this is for mapping functions
path( path, fullfile(HOME,'matlab','m_map','') );

% I don't think I ever used stixbox for anything
path( path, fullfile(HOME,'matlab','stixbox','') );
% path( path, [HOME 'matlab/mysignal'] );

% I don't think I ever used saga for anything
path( path, fullfile(HOME,'matlab','saga','') );

% I am definitely using LIBRA, for AOML CTD data reports
path( path, fullfile(HOME,'matlab','LIBRA','') ); 

% circular statistics toolbox
% path( [HOME 'matlab' filesep 'circStat2009'], path );
path( fullfile(HOME,'matlab','CircStat',''), path );

% best straight line regression (york et al)
path( fullfile(HOME,'matlab','york_curve_fit_0_01',''), path );


% % Directional Analysis toolbox (Not for runtime! IOW, kak!)
% path( [HOME 'matlab' filesep 'DirectionalAnalysis'], path );

% this is my useful functions
path( fullfile(HOME,'matlab','useful',''), path );

% this is for working with netcdf files (jain/hdmodel/hgui)
path( fullfile(HOME,'matlab','mexcdf','mexnc',''), path );
path( fullfile(HOME,'matlab','mexcdf','snctools',''), path );
if isempty(javachk('jvm'))
	javaaddpath(fullfile(HOME,'matlab','mexcdf','netcdfAll-4.1.jar'));
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
path( path, fullfile(HOME,'matlab','ctdcal','') );
path( path, fullfile(HOME,'matlab','ctdcal','CMDR','') );

% Now working at WHOI on wave data analysis; other data processing
path( path, fullfile(HOME,'matlab','Wave_Software','') );
path( path, fullfile(HOME,'matlab','WHOI_Data_Proc','') );
path( path, fullfile(HOME,'matlab','WHOI_Data_Proc','RDI_processing','') );
path( path, fullfile(HOME,'matlab','WHOI_Data_Proc','Nortek','') );

% For tidal analysis trying to use Rich Pawlowicz T_TIDE toolbox
path( path, fullfile(HOME,'matlab','t_tide','') );


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
diary(fullfile(LOGDIR, [ 'matlab.' sprintf('%04d%02d%02d-%02d%02d%07.4f',datevec(now)) '.log']));

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

