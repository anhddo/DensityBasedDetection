function [BETA,rms1,rms2]=plsTraining(trainFolder,testFolder,p)
[Xpls,Ypls]=plsGetPartHog(trainFolder,p);
[XL,YL,XS,YS,BETA,PCTVAR,MSE]=plsregress(Xpls,Ypls,60);

%% test on training Data
rms1=testPLSModel(Xpls,Ypls,BETA);
%% test on Test Data
[Xtest,Ytest]=plsGetPartHog(testFolder,p);
rms2=testPLSModel(Xtest,Ytest,BETA);
end
%%
function rms=testPLSModel(Xpls,Ypls,BETA)
fit=[ones(size(Xpls,1),1) Xpls]*BETA;
res=fit-Ypls;
rms=res.^2;
rms=sqrt(mean(rms,1));
end