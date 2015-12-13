close all;
final=imread('./vivo_dataset1/frames/seq_000440.jpg');
b=imread('./vivo_dataset1/frames/seq_000737.jpg');
c=imread('./vivo_dataset1/frames/seq_000273.jpg');
d=imread('./vivo_dataset1/frames/seq_000033.jpg');
final(1:360,640:end,:)=b(1:360,640:end,:);
final(1:360,1:640,:)=c(1:360,1:640,:);
final(1:400,400:700,:)=d(1:400,400:700,:);
imwrite(final,'./vivo_dataset1/background.jpg');


