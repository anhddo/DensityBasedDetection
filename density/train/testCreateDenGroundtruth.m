function testCreateDenGroundtruth
pDen=initDensityParameter('mall');
ims=createAllImForDenseTraining(pDen);
denGts=createDenseTrainImages(pDen,ims);
end