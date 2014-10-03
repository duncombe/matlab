function y = date()
%DATE	Calendar.
%	S = DATE returns a string containing the date in dd-mmm-yy format.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Modified for Y2K problem by CMDuncombeRae 2000-03-24
%	To use this function it must be encountered before
%	$MATLAB/toolbox/elmat/date.m in the MATLABPATH
%

t = clock;
base = t(1) - rem(t(1),100);
months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';
          'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
y = [int2str(t(3)),'-',months(t(2),:),'-',sprintf('%02d',t(1)-base)];

