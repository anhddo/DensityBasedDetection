function createGenImage(p)
v2struct(p);
load(pGen.matfile);
ind=newOriData(:,1)>0;
boxes=newOriData(ind,:);
boxes=boxes(:,[1 3:6]);

ind=unique(boxes(:,1));
n=numel(ind);

imPath=cell(1,n); bb=imPath;
for i=1:n
    imPath{i}=fullfile(framesDir, sprintf('seq_%06d.jpg',ind(i)));
    ind1= boxes(:,1)==ind(i);
    box1=boxes(ind1,2:5)';
    bb{i}=box1;
end

try,rmdir(pGen.imageDir,'s');catch end;
mkdir(pGen.imageDir);
createPadImage(pGen.imageDir,bb,imPath,pGen);
end