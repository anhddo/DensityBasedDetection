clearvars;

p=mallInitParameter;
v2struct(p);
gtDir='gt1801-2000';
load('groundtruth1801-2000old');
[gt,~]=bbGt('loadAll',gtDir);
count=0;
for i=1:numel(testFiles)
    im=loadImage(testFiles{i},imageType);
    [~,fnm,~]=fileparts(testFiles{i});
    imshow(im);
    bbApply('draw',[gt{i}(:,1:4) (count+1:count+size(gt{i},1))'],'r',1,'--');
    count=count+size(gt{i},1);
    print(fullfile('temp','gt',fnm),'-dpng');
end
rmInd=[3 19 41 35 39 51 71 98 100 102 ];
ind=newOriData(:,1)>0;
newOriData=newOriData(ind,:);
[~,ind]=sort(newOriData(:,1));
newOriData=newOriData(ind,:);
save('groundtruth1801-2000new','newOriData');
