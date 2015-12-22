function opts=allParameter(varargin)
datasetName=varargin{1};
dtsetOpts=initSettings(datasetName);
plsPad=48;
if nargin==2
    args=varargin{2};
    if isfield(args,'plsPad'),plsPad=args.plsPad;end;
end

dtsetOpts.framesDir=fullfile(dtsetOpts.datasetDir,'frames');
thumbfile=fullfile(dtsetOpts.framesDir,'Thumbs.db');
if exist(thumbfile,'file'), delete(thumbfile);end;

H=128; W=64; cellSize=8; xstep=32;ystep=64;

%pGen: crop pedestrian paramter for hogsvm
trainPosDir=fullfile(dtsetOpts.datasetDir,'trainPosCrop');
pGenSVM=struct('padFullIm',500,'padSize',16,'H',96,'isFlip',true,...
    'jumpstep',8,...
    'trainPosDir',trainPosDir,...
    'gtFile',dtsetOpts.gtFile,'framesDir',dtsetOpts.framesDir,...
    'choosedImg',{dtsetOpts.svmChoosedImg},'maxWritedFile',2000,'isNoHead',false,...
    'hardNegDetect',false);

pGenPlsTrain=struct('padFullIm',500,'padSize',plsPad,'H',96,'isFlip',false,...
    'gtFile',dtsetOpts.gtFile,'framesDir',dtsetOpts.framesDir,...
    'choosedImg',{dtsetOpts.plsChoosedImg},'maxWritedFile',1500);
pGenPlsTest=pGenPlsTrain;
pGenPlsTest.gtFile=dtsetOpts.gtTestFile;
% pGenPlsTest.maxWritedFile=700;
trainPlsImageDir=fullfile(dtsetOpts.datasetDir,strcat('plsTrainImage',num2str(plsPad)));
testPlsImageDir=fullfile(dtsetOpts.datasetDir,strcat('plsTestImage',num2str(plsPad)));
pTrainPls=struct('trainPlsImageDir',trainPlsImageDir,'testPlsImageDir',testPlsImageDir);
pDetect=struct('cellSize',cellSize,'threshold',-2,'hogType','piotr',...
    'fineThreshold',0,'H',H,'W',W,'xstep',xstep,'ystep',ystep,'pad',16,...
    'scaleRange',dtsetOpts.scaleRange,'imageType','rgb','svmTool','fitcsvm',...
    'usePls',false);
dtsetOpts=rmfield(dtsetOpts,{'scaleRange','plsChoosedImg','svmChoosedImg'});

debugOpts=struct('writeBb',false,'dBB',false,'dCenBox',false,...
    'dCenPls',false,'dClust',false,'dDenIm',false,'dDenFilt',false,...
    'colorDen',false);
pCLustering=struct('bandwidth',3);
opts=struct('datasetName',datasetName,'dtsetOpts',dtsetOpts...
    ,'pGenSVM',pGenSVM,'pGenPlsTrain',pGenPlsTrain,'pGenPlsTest',pGenPlsTest...
    ,'pDetect',pDetect,...
    'pTrainPls',pTrainPls,'debugOpts',debugOpts,'pCLustering',pCLustering);
if nargin==2 && isfield(args,'spacing')
    pDen=initDensityParameter(opts,args);
else
    pDen=initDensityParameter(opts);
end
opts.pDen=pDen;
[a,b,c]=fileparts(opts.dtsetOpts.BetaPath);
opts.dtsetOpts.BetaPath=fullfile(a,strcat(b,num2str(opts.pGenPlsTrain.padSize),c));
%%
end
