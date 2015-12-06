function im=getIm(imName,opts)
im=imread(imName);
im=im(1:opts.pDen.spacing:end,1:opts.pDen.spacing:end,:);
