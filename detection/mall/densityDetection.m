function [resultPath,timeResultPath]=densityDetection(method)
p=mallDetectionParameter;
v2struct(p);
resultPath=fullfile('result',[method '.txt']);
timeResultPath=fullfile(matDir,[method 'time.mat']);
if exist(fullfile('result',[method,'.txt']),'file'),return;end;
delete('temp/*.png');
pDetectFrame=initDensityDetection;
n=numel(testFiles);
bbs=cell(1,n);
for i=1:n
    [totalTime,boxes,~]=denDectectByFrame(i,pDetectFrame);
    bbs{i}=[i*ones(size(boxes,1),1) boxes];
end
bbs=cat(1,bbs{:});
dlmwrite(resultPath,bbs);
avgtime=totalTime/n;
fprintf('average time: %f\n',avgtime);
save(timeResultPath,'avgtime');


[gt,dt]=bbGt('loadAll',gtDir,resultPath);
[gt,dt] = bbGt('evalRes',gt,dt);
if writeBb
    for i=1:numel(dt)
        bbs=dt{i};
        im=loadImage(testFiles{i},imageType);
        clf;imshow(im);
        matchInd=bbs(:,6)==1; matchBb=bbs(matchInd,:);
        unMatchInd=bbs(:,6)==0; unMatchBb=bbs(unMatchInd,:);
        bbApply('draw',matchBb,'g',1,'--');
        bbApply('draw',unMatchBb,'r',1,'--');
        print(fullfile('temp',['box' num2str(i) '.png']),'-dpng');
    end
    movefile(fullfile('temp','*.png'),fullfile('temp',method));
end
[recall,precision,score,miss] = bbGt('compRoc',gt,dt,0);
plot(precision,recall);
xlabel('precision'); ylabel('recall');
end
