% set up some initial variables. This is run from startup and when `clear'
% has been used, to reset variables.

% HOSTNAME is not always set, so get the hostname from the command
[status,HOST]=system('hostname'); HOST=strtrim(HOST);

HOME=fullfile(getenv('HOME'),'');
% if HOME(length(HOME))~=filesep, HOME=[HOME filesep]; end;

MATLAB=fullfile(getenv('MATLAB'),'');

LOGDIR=fullfile(HOME,'matlab','log','');

clear status

