cd('../train');
p=initParameter;
cd('../markdataset');
load([p.datasetDir 'mall_gt.mat']);
for i=1:5:10
    imName=sprintf('seq_%06d.jpg',i);
    imPath=[p.datasetDir 'frames/' imName];
    imshow(imPath);
    hold on;
    loc=frame{i}.loc;
    plot(loc(:,1),loc(:,2),'.');
    print(['dotGTimage/' imName],'-djpeg');
end