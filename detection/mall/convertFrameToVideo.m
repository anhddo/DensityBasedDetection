clearvars;
v2struct(mallDetectionParameter);
imageNames = dir(fullfile(framesDir,'*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(datasetDir,'video.avi'));
% outputVideo.FrameRate = shuttleVideo.FrameRate;
open(outputVideo);

for ii = 1:length(imageNames)
   img = imread(fullfile(framesDir,imageNames{ii}));
   writeVideo(outputVideo,img)
end
close(outputVideo);


