function den=mallden(im,p)
ftr=extractFeature(im,p);
ftr=convertFeature(ftr,p);
den=p.w(ftr).*p.trainWeights{1};
den=sum(den,3);
% den=sum(den,3).*p.weightMap;