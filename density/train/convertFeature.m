function imFtr=convertFeature(imPrimaryFeature,pr)
[m,n,p]=size(imPrimaryFeature);
X=zeros(m*n,p);
for i=1:p
    X(:,i)=reshape(imPrimaryFeature(:,:,i),1,[]);
end
leafPredicted=zeros(pr.nTrees,size(X,1));
for i=1:pr.nTrees
    [~,leafPredicted(i,:)]=predict(pr.Forest{i},X);
end

dataFtr=zeros(size(imPrimaryFeature,pr.nTrees),size(X,1));
for i=1:pr.nTrees
    leafMapTreei=pr.leafMap(i,:);
    dataFtr(i,:)=leafMapTreei(leafPredicted(i,:));
end
% convert datfeature to [MxNxL] MxN is image size and L is number of
% non-zero element
imFtr=zeros(m,n,pr.nTrees);
for i=1:pr.nTrees
    imFtr(:,:,i)=reshape(dataFtr(i,:),m,n);
end
end