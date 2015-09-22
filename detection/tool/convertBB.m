function bb=convertBB(pbb,type,score)
if isempty(pbb) bb=[];
elseif strcmp(type,'xywh')
    bb(:,1:2)=pbb(1:2,:)'; bb(:,3)=(pbb(3,:)-pbb(1,:)+1)'; 
    bb(:,4)=(pbb(4,:)-pbb(2,:)+1)';
    if ~isempty(score) bb(:,5)=score;end;
elseif strcmp(type,'minmax')
    bb(1:2,:)=pbb(:,1:2)';
end