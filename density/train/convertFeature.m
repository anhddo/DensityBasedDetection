function imFtr=convertFeature(imPrimaryFeature,opts)
[m,n,p]=size(imPrimaryFeature);
X=zeros(m*n,p);
for i=1:p
    X(:,i)=reshape(imPrimaryFeature(:,:,i),1,[]);
end
leafPredicted=zeros(opts.pDen.nTrees,size(X,1));
for i=1:opts.pDen.nTrees
    [~,leafPredicted(i,:)]=predict(opts.pDen.Forest{i},X);
end

dataFtr=zeros(size(imPrimaryFeature,opts.pDen.nTrees),size(X,1));
for i=1:opts.pDen.nTrees
    leafMapTreei=opts.pDen.leafMap(i,:);
    dataFtr(i,:)=leafMapTreei(leafPredicted(i,:));
end
% convert datfeature to [MxNxL] MxN is image size and L is number of
% non-zero element
imFtr=zeros(m,n,opts.pDen.nTrees);
for i=1:opts.pDen.nTrees
    imFtr(:,:,i)=reshape(dataFtr(i,:),m,n);
end
end