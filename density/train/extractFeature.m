% function ftrs=extractFeature(i,img,pr,train)
function ftrs=extractFeature(im,opts)
imgray=rgb2gray(im);
% im=rgb2gray(getImForDensityPhase(idx,opts));
% if exist(fullfile(opts.dtsetOpts.framesDir,sprintf('seq_%06d.jpg',idx+1)),'file')
%     imNeighbor=rgb2gray(getImForDensityPhase(idx+1,opts));
% else
%     imNeighbor=rgb2gray(getImForDensityPhase(idx-1,opts));
% end
pr=opts.pDen;
% staticBg=(medfilt2(imgray,pr.medSize));
% diffBg=imgray-staticBg; absDiffBg=abs(diffBg);
h1=fspecial('gaussian',[3 3],0.5);
h2=fspecial('gaussian',[3 3],1);
% G1=imfilter(im,h1); G2=imfilter(im,h2);

[Gx,Gy]=vl_grad(imgray);
[m,n]=size(imgray);
ftrs=zeros(m,n,4);
% bgGray=medfilt2(im,[3 3]);
ftrs(:,:,1)=abs(pr.bggray-imgray);
% ftrs(:,:,2)=abs(im-imNeighbor);
ftrs(:,:,2)=imgray;
ftrs(:,:,3)=Gx;
ftrs(:,:,4)=Gy;
% ftrs(:,:,5)=abs(G1-G2);
% colorTransform = makecform('srgb2lab');
% ftrs(:,:,6:8)= applycform(im, colorTransform);
% % ftrs(:,:,+(7:14))=lbp(imgray);
% ftrs(:,:,9:56)=local_ternary_pattern(imgray,5,3);
end

function ltp = local_ternary_pattern( im, bin_size, k )
%LTP Summary of this function goes here
%   Detailed explanation goes here
  if length(size(im))==3; im=rgb2gray(im); end;
  d1=repmat(cumsum(ones(bin_size,1)),1,bin_size)-(bin_size/2+0.5);
  d2=repmat(cumsum(ones(1,bin_size)),bin_size,1)-(bin_size/2+0.5);
  ltp=zeros(size(im,1),size(im,2),2*(bin_size^2-1));
  s1=bin_size/2+0.5;e1=size(im,1)-(bin_size/2)+0.5;
  s2=bin_size/2+0.5;e2=size(im,2)-(bin_size/2)+0.5;
  j=1;
  for i=1:bin_size^2
    if i==(bin_size^2/2+0.5); continue; end;
    ltp(s1:e1,s2:e2,2*j-1)=(im(s1:e1,s2:e2)>im(s1+d1(i):e1+d1(i),s2+d2(i):e2+d2(i))+k);
%       ltp(s1:e1,s2:e2,2*j-1)+...
%       (im(s1:e1,s2:e2)>im(s1+d1(i):e1+d1(i),s2+d2(i):e2+d2(i))+k);
    ltp(s1:e1,s2:e2,2*j)=(im(s1:e1,s2:e2)<im(s1+d1(i):e1+d1(i),s2+d2(i):e2+d2(i))-k);
%       ltp(s1:e1,s2:e2,2*j)-...
%       (im(s1:e1,s2:e2)<im(s1+d1(i):e1+d1(i),s2+d2(i):e2+d2(i))-k);
    j=j+1;
  end
end
function lbp = lbp(im)
  im=im2single(im);
  s1=2;e1=size(im,1)-1;s2=2;e2=size(im,2)-1;
  d1=[-1 -1 0 1 1 1 0 -1];
  d2=[0 1 1 1 0 -1 -1 -1];
  s_im=im(s1:e1,s2:e2);
  for i=1:8
  eval(['I' num2str(i,'%d') '=s_im>im(s1+d1(' num2str(i,'%d') '):e1+d1('...
    num2str(i,'%d') '),s2+d2(' num2str(i,'%d') '):e2+d2(' num2str(i,'%d') '));']);
  end;
  lbp=zeros(size(im,1),size(im,2),8);
  lbp(s1:e1,s2:e2,1)=I1;
  lbp(s1:e1,s2:e2,2)=I2;
  lbp(s1:e1,s2:e2,3)=I3;
  lbp(s1:e1,s2:e2,4)=I4;
  lbp(s1:e1,s2:e2,5)=I5;
  lbp(s1:e1,s2:e2,6)=I6;
  lbp(s1:e1,s2:e2,7)=I7;
  lbp(s1:e1,s2:e2,8)=I8;
%   lbp=zeros(size(im,1),size(im,2));
%   lbp(s1:e1,s2:e2)=I1*2^0+I2*2^1+I3*2^2+I4*2^3+I5*2^4+I6*2^5+I7*2^6+I8*2^7;
end