load('../train/p.mat');
close all;
figure('Position',[200 400 837 233],'Visible','on');

gray=colormap('gray');
jet=colormap('jet');
for i=453:5:1000;
    addpath('../train');
    im=(getIm(i,p));
    tic;
    den=mallden(im,p);
    addpath('../train');
    toc;
    dem=medfilt2(den,[3 3]);
    den=den>max(den(:))*0.04;
%     den=imfilter(den,fspecial('gaussian',[5 5],3));
    [r,c]=find(den);
    x=[r c]';
    bandwidth=5;
    [clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(x,bandwidth);
    
    subplot(1,2,1);
    imshow(im);
    hold on;
    c=clustCent(2,:);
    r=clustCent(1,:);
    plot(c,r,'.');
    subplot(1,2,2);
    imshow(den);
    waitforbuttonpress;
end