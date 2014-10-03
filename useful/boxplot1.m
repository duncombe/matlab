function [ med,qu,outl,range ] = boxplot1(X)
% BOXPLOT1 -	Draws a box-whisker plot of the data and returns the 
%		median, quartiles, outlier limits and range for the matrix X
%
% USAGE - 	[ M, Q, O, R ] = boxplot1(X)
% 
% EXPLANATION -	X:	matrix of which data are examined columnwise
%		M:	median
%		Q:	quartiles
%		O:	outlier limits (1.5*interquartile range)
%		R:	range ( max(X)-min(X) )
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae, 95-01-10, sfri & ldeo
%
% PROG MODS -	
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

[sX,XI]=sort(X);
l=size(sX,1);
if rem(l,2) == 0, 
	med = sX(l/2,:); 
	uq=l/2;
	lq=l/2;
else 
	med=(sX(fix(l/2),:)+sX(fix(l/2)+1,:))/2;
	uq=fix(l/2)+1;
	lq=fix(l/2);
end;
if rem(lq,2) == 0, 
	qu(1,:)=sX(lq/2,:); 
	qu(2,:)=sX(l-lq/2,:);
else  
	qu(1,:)=(sX(fix(lq/2),:)+sX(fix(lq/2)+1,:))/2; 
	qu(2,:)=(sX(fix(l-lq/2),:)+sX(fix(l-lq/2)+1,:))/2; 
end;

range = sX(l,:)-sX(1,:);
iqr =qu(2,:)-qu(1,:);
outl = [ qu(1,:)-1.5*iqr; qu(2,:)+1.5*iqr ];
%keyboard
figure;
x = [ 1:size(X,2) ];
lx = x-0.20; 
ux = x+0.20;
plot([lx;ux], [med'*ones(1,2)]');

hold on;
plot([lx;ux], [qu(1,:)'*ones(1,2)]');
plot([lx;ux], [qu(2,:)'*ones(1,2)]');

plot([lx'*ones(1,2)]', qu);
plot([ux'*ones(1,2)]', qu);

% plot([x'*ones(1,2)]',[outl(1,:); qu(1,:)]);
% plot([x'*ones(1,2)]',[outl(2,:); qu(2,:)]);

outp=[];
for i=1:size(X,2),
	op=find(sX>=outl(1,i)); outp(1,i)=sX(op(1));
	op=find(sX<=outl(2,i)); outp(2,i)=sX(op(length(op)));
end;
plot([x'*ones(1,2)]',outp,'o');
plot([x'*ones(1,2)]',outp);

% plot([x'*ones(1,2)]',outl,'o');
% plot([x'*ones(1,2)]',outl);

COL=['ymcrgb'];
for i = 1:size(X,2),
	loi = find(X(:,i)>outl(2,i));	
	plot(i*ones(length(loi),1),X(loi,i),[COL(rem(i-1,size(COL,2))+1) '+']);
	uoi = find(X(:,i)<outl(1,i)); 
	plot(i*ones(length(uoi),1),X(uoi,i),[COL(rem(i-1,size(COL,2))+1) '+']);
end;
A=axis;A(1:2)=[0 size(X,2)+1]; axis(A);

return;



	
