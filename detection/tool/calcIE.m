function [I,E]=calcIE(r1,r2)
a1=boxArea(r1); a2=boxArea(r2);
ints=boxIntersect(r1,r2);%intersection
I=ints/a2;
union=a1+a2-ints;
E=(union-ints)/union;
end