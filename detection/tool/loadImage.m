function im=loadImage(fnm,type)
if strcmp(type,'rgb'), im=im2single(imread(fnm));
else im=im2single(rgb2gray(imread(fnm)));end;
            