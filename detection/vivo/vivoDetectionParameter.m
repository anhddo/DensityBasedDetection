function p=vivoDetectionParameter
vivoParameter;
trainPosDir=fullfile(datasetDir,'trainPosCrop');
framesDir=fullfile(datasetDir,'frames');
createTrainImage=false;
reRunDetect=true;
svmTool='fitcsvm';
hogType='piotr';
imageType='rgb';
thumbfile=fullfile(framesDir,'Thumbs.db');
if exist(thumbfile,'file'), delete(thumbfile);end;
H=128; W=64;
cellSize=8;
padSize=16;
xstep=32;ystep=64;
gtFile=fullfile(datasetDir,'vivoTrainGt.mat');

writeBb=true;
dBB=false;dCenBox=false; dCenPls=false; dClust=false; dDenIm=false; dDenFilt=false;
colorDen=false; bandwitdh=3;

%pGen: crop pedestrian paramter for hogsvm
pGen=struct('padFullIm',500,'padSize',padSize,'H',96,'isFlip',true,...
    'imageDir',trainPosDir,'gtFile',gtFile,'matDir',matDir,'framesDir',framesDir);
pGenPls=struct('padFullIm',500,'padSize',48,'H',96,'isFlip',false,...
    'gtFile',gtFile,'matDir',matDir,'framesDir',framesDir);
scaleRange=1./(1.06.^(0:15));
pDetect=struct('cellSize',cellSize,'hogType',hogType,'threshold',-2,...
    'fineThreshold',-0.5,'H',H,'W',W,'xstep',xstep,'ystep',ystep,'pad',padSize,...
    'scaleRange',scaleRange,'bPad',16,'dCenBox',dCenBox,'dCenPls',dCenPls,...
    'colorDen',colorDen);
isCreateTestTxtGt=false;
p=v2struct;