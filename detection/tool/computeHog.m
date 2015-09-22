function feature=computeHog(im,type)
if strcmp(type,'vlfeat')
    feature=vl_hog(im,8);
elseif strcmp(type,'dalal')
    feature=vl_hog(im,8,'variant','dalaltriggs');
elseif strcmp(type,'piotr')
    feature=hog(im);
end