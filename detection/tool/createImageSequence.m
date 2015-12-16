% p=allParameter('vivo1');
% datasetDir='vivo_dataset1';
datasetDir='crescent_dataset';
path=fullfile(datasetDir,'MAH00185.MP4');
shuttleVideo=VideoReader(path);
frameDir=fullfile(datasetDir,'frames');
if ~exist(frameDir,'dir'),mkdir(frameDir);end;
step=0.3;
shuttleVideo.CurrentTime=0;
i=0;
while shuttleVideo.CurrentTime<shuttleVideo.Duration
    i=i+1;
    shuttleVideo.CurrentTime=shuttleVideo.CurrentTime+step;
    fullpath=fullfile(frameDir,strcat(sprintf('seq_%06d',i),'.jpg'));
    im=readFrame(shuttleVideo);
    imwrite(im,fullpath);
end