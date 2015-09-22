p=initParameter;


if(exist('data.mat','file'))
    a=load('data.mat');oldLoc=a.loc;
%     oldImIdx=a.imIdx;
end
imIdx=81:80:801;
h=figure;
loc=cell(1,numel(imIdx));
loc(1:numel(oldLoc))=oldLoc;
for i=1:numel(imIdx)
    img_name = 'frames/seq_%.6d.jpg';
    im = imread([p.datasetDir sprintf(img_name,imIdx(i))]);
    imshow(im);
    hold on;
    XY=loc{i};
    if(~isempty(XY))
        plot(XY(:,1),XY(:,2),'r*');
    end
    [x,y]=getpts(h);
    newXY=[x y];
    loc{i}=[XY;newXY];
    save('data','loc','imIdx');
end
