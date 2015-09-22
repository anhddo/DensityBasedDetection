load('../train/p.mat');
close all;
figure('Position',[200 400 837 233],'Visible','on');

gray=colormap('gray');
jet=colormap('jet');
for i=1:1:1000;
    addpath('../train');
    im=(getIm(i,p));
    tic;
    den=mallden(im,p);
    addpath('../train');
%     den=imfilter(den,fspecial('gaussian',[5 5],3));
%     den(den<max(den(:))*0.0001)=0;
    
    toc;
%     den(den<0.001)=0;
    [m,n]=size(den);
    subplot(1,2,1);
    subimage(im);
    
    subplot(1,2,2);
    imagesc(den);
%     imshow(den>max(den(:))*0.01,[]);
    drawnow;
    waitforbuttonpress;
    pause(0.2);
    addpath('../train');
    im=getIm(i,p);
end