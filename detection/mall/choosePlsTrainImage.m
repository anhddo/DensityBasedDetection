files=dir(fullfile('mall_dataset','plsTrainImage','*.jpg'));
files={files.name};
save('plsTrainImage','files');
