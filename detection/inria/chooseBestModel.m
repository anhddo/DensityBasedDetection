function chooseBestModel
close all;
% testModel('gray','piotr','fitcsvm');
% testModel('gray','piotr','vlfeat');
testModel('gray','vlfeat','vlfeat');
testModel('rgb','piotr','fitcsvm');
testModel('rgb','vlfeat','fitcsvm');
end
function testModel(pimtype,phog,psvm)
delete posTest.mat negTestHog.mat;
loadParameter;
svmTool=psvm;
hogType=phog;
imageType=pimtype;
modelName=['svm_' imageType '_' hogType '_' svmTool];
load(modelName);
createTest;
load('posTest');
load('negTestHog');
[~,label,score]=getAveragePrecision(posTest,negTestHog,SVMModel);
figure;vl_pr(label,score);
end