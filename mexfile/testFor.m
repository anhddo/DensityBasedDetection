n=7000;
a=randi(100,n);
b=randi(100,n);
x1=0;
tic;
x1=testmex(a,b);
toc;
disp(x1);
x2=0;
tic;
for i=1:n
    for j=1:n
        x2=x2+a(i,j)/b(i,j);
    end
end
toc;
disp(x2);
tic;
x3=sum(sum(a./b));
toc;
disp(x3);
