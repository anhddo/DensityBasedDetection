function [ap,label,scores]=getAveragePrecision(posTest,negTestHog,SVMModel)
st=calcSVMScore(posTest,SVMModel,'linear');
% disp(sum(st>0)/numel(st));
totalNeg=0;
falsePos=0;
negscores={};
w=SVMModel.w; w=single(reshape(w,16,8,[])); b=single(SVMModel.b);
for i=1:numel(negTestHog)
    y=vl_nnconv(negTestHog{i},w,b);
    falsePos=falsePos+sum(y(:)>0);
    totalNeg=totalNeg+numel(y);
    negscores{end+1}=y(:)';
end
% fppw=falsePos/totalNeg;
% disp(fppw);
negscores=cat(2,negscores{:});
label=[ones(1,numel(st)) -ones(1,totalNeg)];
scores=[st negscores];
[~,~,info]=vl_pr(label,scores);
ap=info.ap;
% disp([missrate fp(ind)]);
end