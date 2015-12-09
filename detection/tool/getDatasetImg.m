function img=getDatasetImg(opts,idx)
img=imread(fullfile(opts.dtsetOpts.framesDir,sprintf('seq_%06d.jpg',idx)));
end