function compareResult
displayInline;
initPath;
rerun=true;
close all;
denMethod='densityMethod';
plsMethod='pls';
if rerun
    [denResult,denTimePath]=densityDetection(denMethod);
    [plsResult,plsTimePath]=mallPlsDetection(plsMethod);
end
clf;
[recall,precision]=PRplot(denResult);
plot(precision,recall,'r','LineWidth',2);
[recall,precision]=PRplot(plsResult);
hold on; plot(precision,recall,'b','LineWidth',2);
xlabel('precision'); ylabel('recall');
legend('Proposed method','PLS');
print(fullfile('temp','pr.png'),'-dpng');
load(denTimePath);
denTime=avgtime;
load(plsTimePath);
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
mallParameter;
createTxtGt(gtDir,gtTestFile);
[gt,dt]=bbGt('loadAll',gtDir,txtResult);
[gt,dt] = bbGt('evalRes',gt,dt);
[recall,precision,~,~] = bbGt('compRoc',gt,dt,0);
end