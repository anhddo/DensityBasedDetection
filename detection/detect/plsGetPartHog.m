function [Xpls,Ypls]=plsGetPartHog(folder,opts)
files=bbGt('getFiles',{folder});
Xpls={};Ypls={};
for i=1:numel(files)
    im=loadImage(files{i},opts.pDetect.imageType);
    [m,n,~]=size(im);
    subHog=computeHog(im,opts.pDetect.hogType);
    for u=1:(m-128)/8+1
        for v=1:(n-64)/8+1
            Xpls{end+1}=subHog(u:u+15,v:v+7,:);
            Ypls{end+1}=[n/2-((v+3)*8+1) m/2-((u+7)*8+1)];
        end
    end
end
fprintf('%d wins\n',numel(Xpls));
Xpls=cat(4,Xpls{:});Xpls=reshape(Xpls,[],size(Xpls,4));Xpls=Xpls';
Ypls=cat(1,Ypls{:});
