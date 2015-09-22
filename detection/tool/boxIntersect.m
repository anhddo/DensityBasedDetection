function i=boxIntersect(r1,r2)
w1=r1(3,:)-r1(1,:); h1=r1(4,:)-r1(2,:);
w2=r2(3,:)-r2(1,:); h2=r2(4,:)-r2(2,:);
r1=[r1(1:2,:);w1;h1];
r2=[r2(1:2,:);w2;h2];
i=rectint(r1',r2');
end