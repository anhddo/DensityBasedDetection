function [resultPath,timeResultPath]=densityDetection(method,dataset)
% displayInline;
if strcmp(dataset,'vivo')
    p=vivoDetectionParameter;
elseif strcmp(dataset,'mall')
    p=mallDetectionParameter;
end

v2struct(p);
resultPath=fullfile('result',[method '.txt']);
timeResultPath=fullfile(matDir,[method 'time.mat']);
if isCreateTestTxtGt,createTxtGt(gtDir,gtTestFile);end;
pDetectFrame=initDensityDetection(dataset);
if ~exist(fullfile('result',[method,'.txt']),'file')
    % rmdir(gtDir);
    delete('temp/*.png');
    n=numel(testFiles);
    bbs=cell(1,n);
    timeFrame=[];
    for i=1:n
        imgInd=1800+i;
        img=imread(fullfile(framesDir,sprintf('seq_%06d.jpg',imgInd)));
        [time,boxes,~]=denDectectByFrame(img,pDetectFrame);
        fprintf('image %d, time:%f\n',imgInd,time);
        timeFrame=[timeFrame time];
        bbs{i}=[i*ones(size(boxes,1),1) boxes];
    end
    bbs=cat(1,bbs{:});
    bbs(:,2:5)=bbApply('resize',bbs(:,2:5),1,0,0.5);
    if ~exist('result','dir'),mkdir('result');end;
    dlmwrite(resultPath,bbs);
    avgtime=mean(timeFrame);
    fprintf('average time: %f\n',avgtime);
    save(timeResultPath,'avgtime');
end
[gt,dt]=bbGt('loadAll',gtDir,resultPath);
[gt,dt] = bbGt('evalRes',gt,dt);
v2struct(pDetectFrame);
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
[recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
plot(precision,recall);
xlabel('precision'); ylabel('recall');
end
