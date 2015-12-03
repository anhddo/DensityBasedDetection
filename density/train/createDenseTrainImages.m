function denGts=createDenseTrainImages(p,ims)
denGts=cell(1,p.pDen.nTrnIm);
for i=1:p.pDen.nTrnIm
    
    [m,n,~]=size(ims{i});
    
    denGt=zeros(m,n);
    bbs=p.pDen.loc{i};
    for j=1:size(bbs,1)
        bb=bbs(j,:);
        gauss=createGauss(bb(4)-bb(2)+1, bb(3)-bb(1)+1,1000, 1000, 100);
        denGt(bb(2):bb(4),bb(1):bb(3))= denGt(bb(2):bb(4),bb(1):bb(3))+gauss;
    end
    denGts{i}=denGt;
end
end
function gauss=createGauss(u,v,sx,sy,xichma)
gauss=fspecial('gaussian',[sx sy],xichma);
gauss=imresize(gauss,[u v]);
gauss=gauss/sum(gauss(:));
end
