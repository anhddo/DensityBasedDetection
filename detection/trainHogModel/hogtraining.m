displayInline;
loadParameter;
createTest;
extractPosHog;
%% Get negative vector
if ~exist('trainNeg.mat','file')
    fprintf('Generating negative subwindows: \n');
    trainNeg=cell(1,100000);
    nSamplePerImage=10;
    count=0;
    modelWidth=W/cellSize;
    modelHeight=H/cellSize;
    for i=1:numel(trainNegFiles)
        if ~trainNegFiles(i).isdir
            fnm=[trainNegDir trainNegFiles(i).name];
            im=loadImage(fnm,imageType);
            hogFeature=computeHog(im,hogType);
            
            width = size(hogFeature,2) - modelWidth + 1 ;
            height = size(hogFeature,1) - modelHeight + 1;
            index = vl_colsubset(1:height*width, 10, 'uniform') ;
            
            for j=1:numel(index)
                [hy, hx] = ind2sub([height width], index(j)) ;
                sx = hx + (0:modelWidth-1) ;
                sy = hy + (0:modelHeight-1) ;
                trainNeg{end+1} = hogFeature(sy, sx, :) ;
            end
        end
        displayInline(sprintf('%d/%d\n',i,numel(trainNegFiles)));
    end
    trainNeg=cat(4,trainNeg{:});
    trainNeg=reshape(trainNeg,[],size(trainNeg,4));
    save('trainNeg','trainNeg');
end
trainSVMStage1;
clearvars;
loadParameter;
if ~exist('hardNeg.mat','file')
    load('svmstage1');
    fprintf('Gathering hard negatives: \n');
    count=0;
    upper=200000;
    if strcmp(hogType,'vlfeat')
        hardNeg=single(zeros(3968,upper));
    elseif strcmp(hogType,'piotr') || strcmp(hogType,'dalal')
        hardNeg=single(zeros(4608,upper));
    end
    for i=1:numel(trainNegFiles)
        %     for i=1:4
        if ~trainNegFiles(i).isdir
            fnm=[trainNegDir trainNegFiles(i).name];
            im=loadImage(fnm,imageType);
            p=struct('cellSize',cellSize,'hogType',hogType,'threshold',0,...
                'step',2,'H',128,'W',64,'pad',16);
            [~,scores,features1,~]=fineDetect(im,SVMModel,p);
            %             [~,ind]=sort(scores,'descend');
            %             ind=vl_colsubset(ind,50,'beginning');
            %             features1=features1(:,ind);
            hardNeg(:,count+1:count+size(features1,2))=features1;
            count=count+size(features1,2);
            if count>upper,break;end;
        end
        displayInline(sprintf('%d hard neg, %d/%d\n',count,i,numel(trainNegFiles)));
    end
    
    hardNeg=hardNeg(:,1:count);
    hardNeg=vl_colsubset(hardNeg,78e3,'Random');
    save('hardNeg','hardNeg');
end
if ~exist('svmstage2.mat','file')
    if ~exist('trainPos','var'), load('trainPos');end;
    if ~exist('trainNeg','var'), load('trainNeg');end;
    if ~exist('hardNeg','var'), load('hardNeg');end;
    nPos=size(trainPos,2);
    X=[trainPos trainNeg hardNeg];
    clear trainNeg hardNeg trainPos;
    Y=-1*ones(size(X,2),1); Y(1:nPos)=1;
    disp('Train SVM stage2');
    if strcmp(svmTool,'vlfeat')
        modelName='models2';
        if ~exist([modelName '.mat'],'file')
            trainSVMModel(modelName,X,Y,svmTool);
        end
        evaluationSVM(modelName,'svmstage2');
    else
        trainSVMModel('svmstage2',X,Y,svmTool);
    end
    clear X Y;
    
    load('svmstage2');
    modelName=['svm_' imageType '_' hogType '_' svmTool];
    save(modelName,'SVMModel');
end

