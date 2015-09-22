function evaluationSVM(fnm,svmname)
close all;
% loadParameter;
displayInline;
load(fnm);
load('posTest');
load('negTestHog');
aps=[];
disp('choose best model');
for i=1:numel(models)
% for i=6
    [ap,~,~]=getAveragePrecision(posTest,negTestHog,models{i});
    aps=[aps ap];
    displayInline(sprintf('%d/%d',i,numel(models)));
end
[~,i]=sort(aps,'descend');
SVMModel=models{i};
save(svmname,'SVMModel');
