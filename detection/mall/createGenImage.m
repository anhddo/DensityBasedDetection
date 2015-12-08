function createGenImage(imgFolder,opts)
% v2struct(pGen);
groundTruth=opts.gtFile;
ind=groundTruth(:,1)>0;
boxes=groundTruth(ind,:);
boxes=boxes(:,[1 3:6]);
ind=unique(boxes(:,1));
n=numel(ind);

imPath=cell(1,n); bb=imPath;
for i=1:n
    imPath{i}=fullfile(opts.framesDir, sprintf('seq_%06d.jpg',ind(i)));
    ind1= boxes(:,1)==ind(i);
    box1=boxes(ind1,2:5)';
    bb{i}=box1;
end
try,rmdir(imgFolder,'s');catch end;
mkdir(imgFolder);
createPadImage(imgFolder,bb,imPath,opts);
end