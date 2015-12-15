datasetName='vivo1';
opts=allParameter('vivo1');
if strcmp(datasetName,'vivo1')
    im1=getDatasetImg(opts,101);
    im2=getDatasetImg(opts,140);
    im1(1:360,:,:)=im2(1:360,:,:);
    pos1=[611.25 451.25 79.5 246];
    pos2=[542.25 7.25000000000011 39 109.5];
%     imshow(im1);
%     rectangle('Position',pos1);
%     rectangle('Position',pos2);
    a=246/109;
    pMapN=zeros(720,1280);
    bot=pos1(2)+pos1(4)/2;%bot
    top=pos2(2)+pos2(4)/2;%top
    X=(bot-top);
    a=pos2(4)/pos1(4);a=1/a;
    Y=1-a;
    for i=1:720
        y=Y/X*(i-bot)+1;
        pMapN(i,:)=y;
    end
    save(fullfile('vivo_dataset1','perspective.mat'),'pMapN');
end