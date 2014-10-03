% here I am looking for a way to calculate the median quickly,
% quicker than circ_median, which has a loop through all data.
% 

A=[2.*pi+3.5-randn(200,1).*pi./6; pi+1.5-randn(200,1).*pi./6];
b=median(wrapToPi(A));
c=circ_median(wrapToPi(A));


[wrapToPi(c)-wrapToPi(b)];

figure; polar(A,ones(size(A)),'.'); 
hold on; 
h1=plot(cos(b),sin(b),'ro');
b1=size(find(wrapToPi(A-b)>=0),1);
b2=size(find(wrapToPi(A-b)<=0),1);

x=cos(c);
y=sin(c);

h2=plot(x,y,'go');
plot([x;-x],[y,-y],'g');

c1=size(find(wrapToPi(A-c)>=0),1);
c2=size(find(wrapToPi(A-c)<=0),1);
legend([h1,h2],{[num2str(b1) ' ' num2str(b2)], [num2str(c1) ' ' num2str(c2)]});





