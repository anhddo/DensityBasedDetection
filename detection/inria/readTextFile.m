function lines = readTextFile(filename)
% Search for number of string matches per line.  

fid = fopen(filename);
lines = cell(1,100000);
tline = fgetl(fid);
count=0;
while ischar(tline)
   count=count+1;
   lines{count}=tline;
   tline = fgetl(fid);
end
lines=lines(1:count);
fclose(fid);