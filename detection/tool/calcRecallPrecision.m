function [labels,scores,nGtNeg]=calcRecallPrecision(predict,predictScore, gt,Ith,Eth,totalWin)
nIm=numel(predict);
labels={};scores={};
nGtNeg=totalWin;
count=0;
check={};
for i=1:numel(predict)
    pBBs=predict{i}; gBBs=gt{i};
    scores1=predictScore{i};
    nOutcomePos=size(pBBs,2); nGtPos=size(gBBs,2);
    label=ones(1,nGtPos);
    scores2=single(ones(1,numel(label))*-inf);
    
    truePosInd=[];
    for g=1:nGtPos
        for p=1:nOutcomePos
            [I,E]=calcIE(pBBs(:,p),gBBs(:,g));
%             if p==2,fprintf('%f %f\n',I,E);end;
            if I>=Ith && E<=Eth
                scores2(g)=scores1(p); truePosInd=[truePosInd p];
%                 fprintf('%d %d/%d\n',i,numel(truePosInd),numel(scores2));
            end;
        end
    end
    %     truePosInd=unique(truePosInd);
    check{end+1}=[numel(truePosInd) nGtPos];
    count=count+numel(truePosInd);
    scores1(truePosInd)=[];
    label=[label -ones(1,numel(scores1))];
    nGtNeg=nGtNeg-nGtPos;
    labels{end+1}=label; scores{end+1}=[scores2 scores1];
end
labels=cat(2,labels{:}); scores=cat(2,scores{:});
check=cat(1,check{:});
% disp(count);
% fprintf('%d\n',sum((labels==1).*(scores~=-inf)));
% figure;
% vl_det(labels,scores,'numNegatives',nGtNeg);
% figure;
% vl_pr(labels,scores);
end
