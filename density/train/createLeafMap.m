function [nLeaves,leafMap]=createLeafMap(p)
nLeaves=0;
leafMap=zeros(numel(p.Forest),10000);
for i=1:numel(p.Forest)
    T=p.Forest{i};
    isBranch=T.IsBranch;
    c=0;
    for j=1:numel(isBranch)
        if(isBranch(j)==0),c=c+1;leafMap(i,j)=nLeaves+c;end;
    end
    nLeaves=nLeaves+sum(isBranch==0);
end
end