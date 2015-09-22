inriaDir='INRIAPerson';
trainPosDir=fullfile(inriaDir,'96X160H96','Train','pos');
trainNegDir=fullfile(inriaDir,'Train','neg');
trainPosFull=fullfile(inriaDir,'Train','neg/');
testDir=fullfile(inriaDir,'Test','pos');

testFiles=bbGt('getFiles',{testDir});
trainPosFiles=bbGt('getFiles',{trainPosDir});
trainNegFiles=bbGt('getFiles',{trainNegDir});

nPos=numel(trainPosFiles);
nNeg=nPos*5;nSample=10;
H=128; W=64;
cellSize=8;
padSize=16;

xstep=32;ystep=64;

svmTool='fitcsvm';
% svmTool='vlfeat';

% hogType='piotr';
% hogType='dalal';
hogType='vlfeat';

imageType='rgb';
% imageType='gray';