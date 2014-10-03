function varargout = myboxplot( X, pl, COL, outarg )
%MYBOXPLOT -	Draws a box-whisker plot of the data and returns the 
%		median, quartiles, outlier limits and range for the matrix X
%
%USAGE - 	[ M, Q, O, E, N ] = myboxplot( X, pl, COL )
% 	 	[ handl, stats ] = myboxplot( X, pl, COL, 'handles' )
% 
%		X:	matrix of which data are examined columnwise
%		pl:	plot the figure (1) or return the values only (0) [1]
%		COL:	colour vector (default='rgbycm')
%		M:	median
%		Q:	quartiles
%		O:	outlier limits (1.5*interquartile range)
%		E:	extreme values ( max(X); min(X) )
%		N:	number of data points
%
%                  *        Extreme
%                  +        Outlier	    
%		   o        Outlier limit
%		|--|--|     Quartile
%	  	|-----|     Median
%		|--|--|	    Quartile
%		   o        Outlier limit
%                  +        Outlier	    
%		   *        Extreme
% 
% 		handl: 	vector of handles to the plots
% 		stats:  an array of cells containing the above statistics 
%


%PROGRAM - 	MATLAB code by c.m.duncombe rae, 95-01-10, sfri & ldeo
%
%PROG MODS -
%  1998-03-12
% 	Return number of data points
%  1999-08-30
% 	Cosmetics
%  2004-07-27
% 	Fix 'plotting of extremes' bug
%  2010/10/19 
% 	if X is a row vector, then boxplot does not know how to
% 	deal with it. Test X, and ensure it is in columns
%  2011/01/13 
% 	it is useful to get the handles to the plots. return them
% 	if required.
%  2011/01/14 
% 	delete boxplot and use myboxplot.m in future, to prevent
% 	conflict with other stats toolbox functions.
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

disp({	'This code is a piece of shit! If you need a boxplot, use ';
	'MATLAB:STATS:boxplot; if you need median, quartiles and ';
	'extremes, use prctile.'});
error('Do not use this function');


if any(size(X)==1), X=X(:); end;

N=sum(~isnan(X));

[y,XI]=sort(X);
x = [ 1:size(X,2) ];

if exist('pl')~=1, pl=[]; end;
if isempty(pl), pl=1; end;
% pl must be logical or convertable to logical, and length==1
if max(size(pl))>1,
	warning(['To plot or not (pl) should be logical or scalar, not an array']);
	pl=1;
end;
if exist('COL')~=1, COL=[]; end;
if isempty(COL), COL=['rgbymc']; end;
if exist('outarg')~=1, outarg='stats'; end;

% if pl, figure; end;

for i = 1:size(X,2),
	col=COL(rem(i-1,size(COL,2))+1);
	sX=y(find(~isnan(y(:,i))),i);
	l=size(sX,1);
	if l==0,
		med(i)=nan;
		qu(:,i)=[nan;nan];
		outl(:,i)=[nan;nan];
		extreme(:,i)=[nan;nan]; 
	elseif l==1,
		med(i)=sX(l);
		qu(:,i)=[sX(1);sX(l)];
		outl(:,i)=[nan;nan];
		extreme(:,i)=[sX(1);sX(l)];
	else
		if rem(l,2) == 0, 
			med(i) = sX(l/2); 
			uq=l/2;
			lq=l/2;
		else 
			med(i)=(sX(fix(l/2))+sX(fix(l/2)+1))/2;
			uq=fix(l/2)+1;
			lq=fix(l/2);
		end;
		if l==2 | l==3,
			qu(:,i)=[sX(1);sX(l)];
		else
			if rem(lq,2) == 0, 
				qu(1,i)=sX(lq/2); 
				qu(2,i)=sX(l-lq/2);
			else  
				qu(1,i)=(sX(fix(lq/2))+sX(fix(lq/2)+1))/2; 
				qu(2,i)=(sX(fix(l-lq/2))+sX(fix(l-lq/2)+1))/2; 
			end;
		end;
		extreme(:,i)=[sX(1); sX(l)];
		iqr =qu(2,i)-qu(1,i);
		% this has outlier fences correct!
		outl(:,i) = [ qu(1,i)-1.5*iqr; qu(2,i)+1.5*iqr ];
	end;

% keyboard

	lx = i-0.20; 
	ux = i+0.20;
	if pl & l>1,
	 	handl(i)=plot([lx;ux], [med(i)*ones(1,2)]', col);
		hold on;
		plot([lx;ux], [qu(1,i)'*ones(1,2)]', col);
		plot([lx;ux], [qu(2,i)'*ones(1,2)]', col);

		plot([lx'*ones(1,2)]', qu(:,i), col);
		plot([ux'*ones(1,2)]', qu(:,i), col);

		outp=[];
		op=find(sX>=outl(1,i)); outp(1)=sX(op(1));
		op=find(sX<=outl(2,i)); outp(2)=sX(op(length(op)));
% plot outlier limits
		plot([x(i)*ones(1,2)]',outp,[col 'o']);
		plot([x(i)*ones(1,2)]',outp,col);
% plot outlier points
		loi = find(X(:,i)>outl(2,i));	
		plot(i*ones(length(loi),1),X(loi,i),[col '+']);
		uoi = find(X(:,i)<outl(1,i)); 
		plot(i*ones(length(uoi),1),X(uoi,i),[col '+']);
% plot extremes
		plot([x(i)*ones(1,2)]',extreme(:,i),[col '*']);

	end;
end;
if pl,
	A=axis;
	A(1:2)=[0 size(X,2)+1]; 
	axis(A);
end;
if strcmp(outarg,'handles'),
	varargout={ handl, { med, qu, outl, extreme, N } }; 
else
	varargout={med, qu, outl, extreme, N }; 
end;
return;

