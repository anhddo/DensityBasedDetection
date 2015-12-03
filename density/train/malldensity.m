function malldensity(varargin)
% clear all;
if nargin==0,
    pDen=initDensityParameter;
    pDenPath=fullfile(pDen.matDir,'pDen.mat');
    forestPath=fullfile(pDen.matDir,'forest.mat');
else
    pDen=varargin{1};
    pDenPath=fullfile(pDen.matDir,sprintf('pDen%d.mat',pDen.methodNo));
    forestPath=fullfile(pDen.matDir,sprintf('forest%d.mat',pDen.methodNo));
end
close all;
densityTraining(pDen,pDenPath,forestPath);
end
