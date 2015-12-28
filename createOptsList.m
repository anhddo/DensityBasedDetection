function optsList=createOptsList(datasetName)
args48=struct('plsPad',48);
% args32=struct('plsPad',32);
% datasetTrain(datasetName,args32);
optsList={};
optsList{end+1}=createParameter(datasetName,'DenBased','pad48',args48);
optsList{end+1}=createParameter(datasetName,'DenBasedNoPls','pad48',args48);
optsList{end+1}=createParameter(datasetName,'PLS','pad48',args48);
end

function opts=createParameter(varargin)
datasetName=varargin{1};
methodName=varargin{2};
strName=varargin{3};
if nargin==4,opts=loadTrainModel(datasetName,varargin{4});
else opts=loadTrainModel(datasetName);end;
resultPath=fullfile('result',datasetName);
if ~exist(resultPath,'dir'),mkdir(resultPath);end;
resultName=strcat(datasetName,methodName,strName);
sharePath=fullfile(resultPath,resultName);
resultFile=strcat(sharePath,'result.mat');
detectBox=strcat(sharePath,'.txt');
avgTimeFile=strcat(sharePath,'time.mat');
gtTextFolder=fullfile(resultPath,strcat(datasetName,'gtTxtFiles'));
resultOpts=struct('resultFile',resultFile,'detectBox',detectBox,'avgTimeFile',avgTimeFile,...
    'gtTextFolder',gtTextFolder,'methodName',methodName,'resultPath',resultPath,...
    'resultName',resultName);
opts.resultOpts=resultOpts;
end