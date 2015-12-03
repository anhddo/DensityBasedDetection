function [nLeaves,leafMap]=createLeafMap(opts)
nLeaves=0;
leafMap=zeros(numel(opts.pDen.Forest),10000);
for i=1:numel(opts.pDen.Forest)
    T=opts.pDen.Forest{i};
    isBranch=T.IsBranch;
    c=0;
    for j=1:numel(isBranch)
        if(isBranch(j)==0),c=c+1;leafMap(i,j)=nLeaves+c;end;
    end
    nLeaves=nLeaves+sum(isBranch==0);
end
end