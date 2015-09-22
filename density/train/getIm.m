function im=getIm(imName,p)
im=imread(imName);
im=im(1:p.spacing:end,1:p.spacing:end,:);
