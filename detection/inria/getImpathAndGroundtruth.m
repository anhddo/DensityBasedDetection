function [imPath,gtbbs]=getImpathAndGroundtruth(inriaDir,testDir,testFiles)
imPath=cell(1,numel(testFiles));gtbbs=imPath;
for i=1:numel(testFiles)    
        [~,name,~]=fileparts(testFiles(i).name);
        imPath{i}=[testDir testFiles(i).name];
        annoFile=[inriaDir 'Test/annotations/' name '.txt'];
        [~,gtbb]=getGtInfo(annoFile,inriaDir);
        gtbbs{i}=gtbb;
end