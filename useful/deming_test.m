% script
% - 	
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.6 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: deming_test.m,v 1.6 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
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

x=rand(20,1).*5+2.4;
y=x.*3+10;


 xa=x+(randn(size(x)).*0.4);
 ya=y+(randn(size(y)).*2.3);

% huh?
vx=var(detrend(sort(xa)));                       
vy=var(detrend(sort(ya)));


% [X,Y]=deming(xa,ya,vx,vy);
[beta,delta]=deming_fit(xa,ya,vx,vy);
[X,Y]=deming_calc(xa,ya,beta,delta);

uc =  sum( (ya - (xa .* beta(2) + beta(1) ) ).^2 ) ./ (length(xa)-2);

UC =  sum( (ya - Y ).^2 ) ./ (length(xa)-2);


[SL,IN,N,RSQ,STERR]=regress(xa,ya);

% york fit
[a, b, sig_a, sig_b, save_b]=york_fit(xa.',ya.',vx,vy);
uncertain =  sum( (ya - (xa .* b + a ) ).^2 ) ./ (length(xa)-2);

sterr=sqrt(uncertain);

figure; h1=plot(x,y,'.');
	hold on; 
	h2=plot(xa,ya,'r.'); 
	plot(X,Y,'g.');

	% deming regression
	h3=regrplot(beta(2),beta(1),uc,'g');

	% std linear regression
	h4=regrplot(SL,IN,STERR,'b');
	% york_fit regression
	h5=regrplot(b,a,sterr,'m');
	% h6=regrplot(b-sig_b,a-sig_a,[],'c'); set(h6,'linewidth',4);
	% h7=regrplot(b+sig_b,a+sig_a,[],'c'); set(h7,'linewidth',4);

legend([h1(1),h2(1),h3(1),h4(1),h5(1)],{'True data','Measured data', 'Deming', 'Simple LSR', 'York Fit'},'location','best');


