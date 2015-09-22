function SVMModel=trainSVMModel(trainPos,trainNeg,p)
v2struct(p);
disp('Training stage SVM');
if ~exist('trainPos','var'),load('trainPos'); end;
if ~exist('trainNeg','var'),load('trainNeg'); end;
nPos=size(trainPos,2);nNeg=size(trainNeg,2);
X=[trainPos trainNeg];  Y=[ones(1,nPos) -ones(1,nNeg)];
clear trainNeg trainPos;

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