function ftr=getFtrHog(imHog,x,y,w,h,cellSize)
ftr=[];
x=x-w*cellSize/2;y=y-h*cellSize/2;
c1=round(x/cellSize); c2=c1+w-1; r1=round(y/cellSize); r2=r1+h-1;
if r1>0&&r2<=size(imHog,1)&&c1>0&&c2<=size(imHog,2)
    ftr=imHog(r1:r2,c1:c2,:);
    ftr=ftr(:);
end
end