if ~exist('posTest.mat','file')
    count=0;
    posTest={};
    testDir=[inriaDir '70X134H96/Test/pos/'];
    files=dir([testDir '*.png']);
    for i=1:numel(files)
        fnm=[testDir files(i).name];
        im=loadImage(fnm,imageType);
        subHog=computeHog(im,hogType);
        subHog=subHog(1:H/cellSize,1:W/cellSize,:);
        posTest{end+1}=subHog;
    end
    posTest=cat(4,posTest{:});
    posTest=reshape(posTest,[],size(posTest,4));
    save('posTest','posTest');
end

if ~exist('negTestHog.mat','file')
    fprintf('create neg test Hog\n');
    negDir=[inriaDir 'Test/neg/'];
    files=dir([negDir '*']);
    negTestHog={};
    for i=1:numel(files)
        if ~files(i).isdir
            scale=1;
            fnm=[negDir files(i).name];
            im=loadImage(fnm,imageType);
            [m,n,~]=size(im);
            while true
                scale=scale/1.2;
                if m*scale<128 ||n*scale<64,break;end;
                im1=imresize(im,scale);
                negTestHog{end+1}=computeHog(im1,hogType);
            end
        end
        displayInline(sprintf('%d/%d\n',i,numel(files)));
    end
    save('negTestHog','negTestHog');
    clear negTestHog;
end