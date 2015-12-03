function boxes=removeOutOfRangeBox(boxes,pad,m,n)
if isempty(boxes), boxes=[];return;end;
boxes(:,1:2)=boxes(:,1:2)-pad;
xmin=boxes(:,1);ymin=boxes(:,2); xmax=xmin+boxes(:,3)-1; ymax=ymin+boxes(:,4)-1;
ind=(xmin>=1).*(ymin>=1).*(xmax<=n).*(ymax<=m);
ind=logical(ind);
boxes=boxes(ind,:);
end