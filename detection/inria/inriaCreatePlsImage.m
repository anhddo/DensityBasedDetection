files=dir([posAnno '*.txt']);
count=0;
reject=[26 27 33 42 44:54 62:68 70 ...
    71 73 100 107 108 114 115 117 119 128:133 137 139 146 147 ...
    154 155 157 158 179 193 194 199:204 223:226];
boxes={};imPath={};
try
    rmdir(trainPlsImageDir,'s'); rmdir(testPlsImageDir,'s');
catch
end
mkdir(trainPlsImageDir); mkdir(testPlsImageDir);

for i=1:numel(files)
    if ~files(i).isdir
        [~,name,~]=fileparts(files(i).name);
        annoFile=[posAnno name '.txt'];
        [path,gtbb]=getGtInfo(annoFile,inriaDir);
        if size(gtbb,2)>1,continue;end;
        count=count+1;
        if ~isempty(find(reject==count,1)),continue;end;
        boxes{end+1}=gtbb;
        imPath{end+1}=path;
    end
end
p=struct('padFullIm',1000,'padCrop',48,'H',96);
createPadImage(trainPlsImageDir,boxes,imPath,p);
%%
boxes={};imPath={};
files=dir([posTestAnno '*.txt']);
for i=1:numel(files)
    if ~files(i).isdir
        [~,name,~]=fileparts(files(i).name);
        annoFile=[posTestAnno name '.txt'];
        [path,gtbb]=getGtInfo(annoFile,inriaDir);
%         if size(gtbb,2)>1,continue;end;
        boxes{end+1}=gtbb;
        imPath{end+1}=path;
    end
end
p=struct('padFullIm',1000,'padCrop',48,'H',96);
createPadImage(testPlsImageDir,boxes,imPath,p);