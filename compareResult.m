function compareResult
initPath;
rerun=true;
close all;
if rerun
    densityDetection;
    mallPlsDetection;
end
clf;
[recall,precision]=PRplot('denWithPls26Scale.txt');
plot(precision,recall,'r','LineWidth',2);
[recall,precision]=PRplot('pls26scale.txt');
hold on; plot(precision,recall,'b','LineWidth',2);
xlabel('precision'); ylabel('recall');
legend('Proposed method','PLS');
print(fullfile('temp','pr.png'),'-dpng');
load('densityMethodtime');
denTime=avgtime;
load('plstime');
plsTime=avgtime;
% figure;
% h=bar([0 1],[1 3]);
% set(gca,'XTickLabel',{'Proposed method','PLS'});
% set(h(2),'FaceColor','r');
figure;
h(1)=bar(gca,[denTime plsTime],'r','BarWidth',0.5);
set(gca,'XTickLabel',{'Proposed method','PLS'});
hold on;
h(2)=bar(gca,2,plsTime,'b','BarWidth',0.5);
ylabel('Time(s)');
print(fullfile('temp','time.png'),'-dpng');
end
function [recall,precision]=PRplot(txtResult)
[gt,dt]=bbGt('loadAll','gt1801-2000',txtResult);
[gt,dt] = bbGt('evalRes',gt,dt);
[recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
end