function den=mallden(im,opts)
ftr=extractFeature(im,opts);
ftr=convertFeature(ftr,opts);
% den=p.w(ftr).*p.trainWeights{1};
den=opts.pDen.w(ftr);
% den=sum(den,3);
den=sum(den,3).*opts.pDen.weightMap;