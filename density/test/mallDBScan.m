addpath('../train');
addpath('../dbscan/');
load('p');
close all;
for i=1:5:1000
    im=getIm(i,p);
    tic;
    den=mallden(im,p);
    toc;
    den=imfilter(den,fspecial('gaussian',[5 5],3));
    
    [r,c]=find(den);
    x=[r c];
    labs=dbscan(x,5,5);
    subplot(1,2,1);
    imshow(im);
    hold on;
    c=clustCent(2,:);
    r=clustCent(1,:);
    plot(c,r,'*');
    subplot(1,2,2);
    imagesc(den);
    waitforbuttonpress;
end