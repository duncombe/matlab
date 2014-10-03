function [lower,upper]=confid(alpha,nu)
%CONFID - confidence limits from chi-square distribution
% 
%USAGE -	[lower,upper]=confid(alpha,nu)
%
%EXPLANATION -	alpha - confidence value
% 		nu - degrees of freedom
% 		lower and upper - bounds
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	
%%c. wunsch, may 1995
%	$Revision: 1.4 $
%	$Date: 2011-09-22 16:14:39 $
%	$Id: confid.m,v 1.4 2011-09-22 16:14:39 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2011-09-09 CMDR
% 	modified to use a different chi-square function, but return the same
% 	values as Wunsch wrote.
% 
% }}}

%%follows Jenkins and Watts, p. 81 and uses Peter Shaw's chisquare
%%program 
%%confid.m alpha percent confidence limits for a chi-square variate
%%nu is number of degrees of freedom
%%for 95% confidence set alpha =.05
%%should be sigma^2/S^2 confidence bounds where sigma^2 is true variance
%%check value (J&W) is alpha =.05, nu=19, lower bound is .58
%%upper bound is 2.11

% upperv=chisquat(1-alpha/2,nu);
% lowerv=chisquat(alpha/2,nu);
% replaced with chi2inv (from Matlab statistics toolbox)
v=chi2inv([alpha./2, 1-alpha./2],nu);

lower=nu./v(2);
upper=nu./v(1);

return;

