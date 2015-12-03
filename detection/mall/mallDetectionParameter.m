function p=mallDetectionParameter
mallParameter;
trainPosDir=fullfile(datasetDir,'trainPosCrop');
framesDir=fullfile(datasetDir,'frames');
createTrainImage=false;
reRunDetect=true;
svmTool='fitcsvm';
hogType='piotr';
imageType='rgb';
delete(fullfile(framesDir,'Thumbs.db'));
testFiles=bbGt('getFiles',{framesDir});
testFiles=testFiles(1801:end);
H=128; W=64;
cellSize=8;
padSize=16;
xstep=32;ystep=64;
roi=load(fullfile(datasetDir,'perspective_roi.mat'),'roi');
roi=roi.roi.mask;

writeBb=true;
dBB=false;dCenBox=false; dCenPls=false; dClust=false; dDenIm=false; dDenFilt=false;
colorDen=false; bandwitdh=3;

gtFile='groundtruth.mat';
% load(fullfile(matDir,'plsPatchTrain.mat'));
%pGen: crop pedestrian paramter for hogsvm
pGen=struct('padFullIm',500,'padSize',padSize,'H',96,'isFlip',true,...
    'imageDir',trainPosDir,'gtFile',gtFile,'matDir',matDir,'framesDir',framesDir);
pGenPls=struct('padFullIm',500,'padSize',48,'H',96,'isFlip',false,...
    'gtFile',gtFile,'matDir',matDir,'framesDir',framesDir);
%     'plsPatchTrain',{plsPatchTrain});
p=v2struct;