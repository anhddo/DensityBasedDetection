p=vivoDetectionParameter;
v2struct(p);
path=fullfile(datasetDir,'vivo.MP4');
shuttleVideo = VideoReader(path);
ii = 0;i=0;
totalFrame=shuttleVideo.FrameRate*shuttleVideo.Duration;
frameDir=fullfile(datasetDir,'frames');
if ~exist(frameDir,'dir'),mkdir(frameDir);end;
while hasFrame(shuttleVideo)
    img = readFrame(shuttleVideo);
    ii = ii+1;
    if mod(ii,20)==0,
        i=i+1;
        filename = [sprintf('seq_%06d',i) '.jpg'];
        fullname = fullfile(frameDir,filename);
        imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
    end
end