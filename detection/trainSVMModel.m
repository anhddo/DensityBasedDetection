function SVMModel=trainSVMModel(opts)
if exist(opts.dtsetOpts.SvmModelPath,'file'),return;end;
% try rmdir(opts.pGenSVM.trainPosDir,'s');catch, end;
if ~exist(opts.pGenSVM.trainPosDir,'dir'),
    createGenImage(opts.pGenSVM.trainPosDir,opts.pGenSVM);
end;
trainPosName=fullfile(opts.dtsetOpts.matDir,sprintf('%strainPos.mat',opts.datasetName));
trainPos=extractPosHog(opts);
trainNegName=fullfile(opts.dtsetOpts.matDir,sprintf('%strainNeg.mat',opts.datasetName));

opts.nNeg=size(trainPos,2)*5;
trainNeg=mallExtractNegHog(opts);
SVMModel=trainSVMModel0(trainPos,trainNeg,opts);

nRetrain=2;
neg=trainNeg;
for i=1:nRetrain
    fprintf('Retrain stage %d\n',i);
    hardNeg=getHardNeg(opts,SVMModel);
    fprintf('%d hard negatives\n',size(hardNeg,2));
    if size(hardNeg,2)>0
        neg=[neg hardNeg];
        SVMModel=trainSVMModel0(trainPos,neg,opts);
    end
end
save(opts.dtsetOpts.SvmModelPath,'SVMModel');
end

function features=getHardNeg(opts,SVMModel)
v2struct(opts);
% scaleRange=opts.pDetect.scaleRange;
%     pDetect=struct('cellSize',cellSize,'hogType',hogType,'threshold',0,...
%         'jumpstep',1,'H',H,'W',W,'pad',16,'scaleRange',scaleRange);
im=loadImage(fullfile(opts.dtsetOpts.datasetDir,'background.jpg'),opts.pDetect.imageType);

[~,features]=detectSL(im,SVMModel,opts);

end

function trainNeg=mallExtractNegHog(opts)
trainPosFiles=bbGt('getFiles',{opts.pGenSVM.trainPosDir});
nPos=numel(trainPosFiles);
nNeg=nPos*10;

fprintf('Gathering negative subwindows:\n');
im=loadImage(fullfile(opts.dtsetOpts.datasetDir,'background.jpg'),opts.pDetect.imageType);
scale=opts.pDetect.scaleRange;
trainNeg={};
H=opts.pDetect.H;
W=opts.pDetect.W;
cellSize=opts.pDetect.cellSize;

for s=scale
    sim=imResample(im,s);
    sHog=computeHog(sim,opts.pDetect.hogType);
    [m,n,~]=size(sHog);
    for i=1:m-H/cellSize+1
        for j=1:n-W/cellSize+1
            trainNeg{end+1}=sHog(i:i+H/cellSize-1,j:j+W/cellSize-1,:);
        end
    end
    if numel(trainNeg)>nNeg,break;end;
end
trainNeg=cat(4,trainNeg{:});
trainNeg=reshape(trainNeg,[],size(trainNeg,4));

negativeDir=fullfile(opts.dtsetOpts.datasetDir,'negative');
% if ~exist(negativeDir,'dir'),mkdir(negativeDir);end;
% count=0;
% for s=scale
%     sim=imResample(im,s);
%     [m,n,~]=size(sim);
%     for c=1:8:n-64
%         for r=1:8:m-128
%             subim=sim(r:r+127,c:c+64,:);
%             count=count+1;
%             filePath=fullfile(negativeDir,sprintf('%d.jpg',count));
%             imwrite(subim,filePath);
%         end
%     end
%     if count>nNeg,break;end;
% end
end

function SVMModel=trainSVMModel0(trainPos,trainNeg,opts)
disp('Training stage SVM');
nPos=size(trainPos,2);nNeg=size(trainNeg,2);
X=[trainPos trainNeg];  Y=[ones(1,nPos) -ones(1,nNeg)];
clear trainNeg trainPos;
svmTool=opts.pDetect.svmTool;
if strcmp(svmTool,'vlfeat')
    modelName='models1';
    if ~exist([modelName '.mat'],'file')
        trainSVMModel1(modelName,X,Y,svmTool);
    end
    evaluationSVM('models1','svmstage1');
else
    SVMModel=trainSVMModel1(X,Y,svmTool);
end
end

function SVMModel=trainSVMModel1(X,Y,svmTool)
if strcmp( svmTool,'vlfeat')
    
    lamda=double(1)./power(10,-2:7);
    %     C=power(10,-10:10);
    %     lamda=1./(C*numel(Y));
    models={};
    for i=1:numel(lamda)
        [w,b]=vl_svmtrain(X,Y,lamda(i),'epsilon',1,...
            'MaxNumIterations',1e8,'verbose');
        %         [w,b]=vl_svmtrain(X,Y,lamda(i),'verbose');
        SVMModel.lamda=lamda(i);
        SVMModel.w=w;SVMModel.b=b;SVMModel.t=0;
        models{end+1}=SVMModel;
    end
    save(fnm,'models');
elseif strcmp(svmTool,'libsvm')
    SVMModel=libsvmtrain(Y,X,'-t 0');
    save(fnm,'SVMModel');
elseif strcmp(svmTool,'fitcsvm')
    SVMModel1 = fitcsvm(X',Y','BoxConstraint',0.01,'verbose',1);
    SVMModel1=compact(SVMModel1);
    SVMModel.w=SVMModel1.Beta; SVMModel.b=SVMModel1.Bias;SVMModel.t=0;
    %     save(fnm,'SVMModel');
elseif strcmp(svmTool,'fitcsvmrbf')
    SVMModel = fitcsvm(X,Y,'KernelFunction','rbf','Verbose',1);
    SVMModel=compact(SVMModel);
    save(fnm,'SVMModel');
    clear SVMModel;
    
elseif strcmp(svmTool,'svmlight')
    SVMModel=svmlearn(X,Y,'-t 0 -c 0.01');
    save(fnm,'SVMModel');
end
end