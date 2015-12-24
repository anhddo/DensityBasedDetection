function testDataset(varargin)

testDataset1('mall');
testDataset1('vivo1');
testDataset1('crescent');

end
%% nargin=2 only load optsList(no Train, no Detect)
function optsList=testDataset1(datasetName)
optsList=createOptsList(datasetName);
datasetTrain(datasetName);
for i=1:numel(optsList)
    applyDetect(optsList{i});
end
end


function chooseim
a=bbGt('getFiles',{'D:\document\vision\DensityBasedDetection\vivo_dataset1\plsTrainImage'});
choosedImg={};
for i=1:numel(a)
    [~,name,ext]=fileparts(a{i});
    choosedImg{end+1}=[name ext];
end
end