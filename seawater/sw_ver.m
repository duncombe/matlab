function [V] = sw_ver()

% SW_VER     Version number of SEAWATER library
%=========================================================================
% SW_VER    $Id: sw_ver.m,v 1.2 2012-10-15 14:24:19 duncombe Exp $
%           Copyright (C) CSIRO, Phil Morgan 1994
%
% sw_ver
%
% DESCRIPTION:
%    Returns version number of the SEAWATER library
%
% AUTHOR:  Phil Morgan, Lindsay Pender (Lindsay.Pender@csiro.au)
%
% DISCLAIMER:
%   This software is provided "as is" without warranty of any kind.
%   See the file sw_copy.m for conditions of use and licence.
%
%=========================================================================
% disp('SEAWATER Version 3.3')
V = ('SEAWATER Version 3.3');
if nargout==0
	disp(V);
	clear V
end

