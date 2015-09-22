function s=calcSVMScore(X,model,svmTool)
if isempty(X)
    s=[];
elseif strcmp(svmTool,'linear') || strcmp(svmTool,'fitcsvm')
    s=model.w'*X+model.b;
elseif strcmp(svmTool,'libsvm')
    [~, ~, s] = libsvmpredict(ones(size(x,1),1), features, ...
        SVMModel,'-q');
elseif strcmp(svmTool,'svmlight')
    [~,s]=svmclassify(X,ones(size(X,1),1),model);
elseif strcmp(svmTool,'fitcsvmrbf')
    [~,s]=predict(model,X);
    s=s(:,2);
end