function viewGT(p,imNum)
gtInfo=p.gtInfos{imNum};
imName=imread([p.datasetDir gtInfo.imPath]);
imshow(imName);
for i=1:gtInfo.nPerson
    bbox=gtInfo.persons{i}.bbox;
    h=rectangle('Position',[bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)],...
        'EdgeColor','green','LineWidth',3);
    
end
end