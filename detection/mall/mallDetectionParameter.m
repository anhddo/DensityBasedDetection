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
%pGen: crop pedestrian
pGen=struct('padFullIm',500,'padSize',padSize,'H',96,'isFlip',true,...
    'imageDir',trainPosDir,'gtFile','groundtruth','matDir',matDir);
p=v2struct;