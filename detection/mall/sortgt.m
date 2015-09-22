load('groundtruth1801-2000old');
ind=newOriData(:,1)>0;
newOriData=newOriData(ind,:);
[~,ind]=sort(newOriData(:,1));
newOriData=newOriData(ind,:);
save('groundtruth1801-2000','newOriData');
