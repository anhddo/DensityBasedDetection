function im=getImForDensityPhase(id,opts)
im=getDatasetImg(opts,id);
im=im(1:opts.pDen.spacing:end,1:opts.pDen.spacing:end,:);