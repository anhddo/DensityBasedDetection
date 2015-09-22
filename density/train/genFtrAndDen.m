function [ftrs,denGts,ims]=genFtrAndDen(p)
ims=cell(1,p.nTrnIm);
ftrs=cell(1,p.nTrnIm);
denGts=cell(1,p.nTrnIm);
delete('temp/*.png');
for i=1:p.nTrnIm
    id=p.imIdx(i);
    imName=fullfile(p.datasetDir,'frames',sprintf('seq_%06d.jpg',id));
    im=getIm(imName,p);
    %     imPrev=getIm(imIdx-1,p);
    imwrite(im,sprintf('temp/im_%.6d.png',id));
    ims{i}=im;
    ftrs{i}=extractFeature(im,p);
    [m,n,~]=size(im);
    
    denGt=zeros(m,n);
    bbs=p.loc{i};
    for j=1:size(bbs,1)
        bb=bbs(j,:);
        gauss=createGauss(bb(4)-bb(2)+1, bb(3)-bb(1)+1);
        denGt(bb(2):bb(4),bb(1):bb(3))= denGt(bb(2):bb(4),bb(1):bb(3))+gauss;
    end
    imwrite(mat2gray(denGt),sprintf('temp/den_%.6d.png',i));
    
    denGts{i}=denGt;
end
end
function gauss=createGauss(u,v)
sx=1000;sy=1000;xichma=100;
gauss=fspecial('gaussian',[sx sy],xichma);

gauss=imresize(gauss,[u v]);

gauss=gauss/sum(gauss(:));
end