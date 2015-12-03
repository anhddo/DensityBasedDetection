% load(fullfile('matfile','newOriData.mat'));
% nhat=newOriData;
% load(fullfile('matfile','newOriData_anh.mat'));
% newOriData=[newOriData;nhat];
% ind=newOriData(:,1)>0;
% newOriData=newOriData(ind,:);
% [~,ind]=sort(newOriData(:,1));
% newOriData=newOriData(ind,:);
% save('groundtruth','newOriData');

mkdir('temp','bbgt');
v2struct(mallDetectionParameter);
load(fullfile(matDir,'groundtruth.mat'));
imIdx=unique(newOriData(:,1));
for i=imIdx
    fnm=fullfile(framesDir,sprintf('seq_%06d.jpg',i));
    im=imread(fnm);
    row=newOriData(i,:);
    subIm=im(row(4):row(6),row(3):row(5));
    imshow(subIm);
end