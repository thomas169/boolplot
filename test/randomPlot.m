
rootData = drv20msB.data{1}.Values.Control.Control_Word;
rootData = drv20msB.data{1}.Values.Status.Main_Status_Word;
rootData = ts

%%
fNames = fieldnames(rootData);
%reporterFig('nextPlot','add')
figure(4)

iTems = 8;
nSample = 25;


    
for n = 8  : -1:  1
    ts = rootData.(fNames{n});
    rbg = cM(mod(n-1,cN)+1,:);
    yOffset = (n-1);
    tsFillPlot(ts,yOffset,rbg);

end
tEnd = rootData.(fNames{n}).Time(end);
set(gca,'XMinorGrid','on')
set(gca,'XGrid','on')
%set(gca,'YMinorGrid','on')
set(gca,'YGrid','on')
set(gca,'YTick',0.5+[0:iTems-1])
set(gca,'XLim',[0 tEnd])
set(gca,'YLim',[0 iTems])
set(gca,'YTickLabel',strrep(fliplr(fNames),'_',' '))
set(gca,'YTickLabelRotation',35)
set(gca,'TickLength',[0 0])

%%

x = csvToTimeseries('UnclogicFastComms.csv')

axes
grid on
set(gca,'nextplot','add')
cM = get(gca,'ColorOrder');
cN = size(cM,1);
figure(4)

for n = 1:size(x.UncLogic.Data,2)
    ts.(['bit' num2str(n)]) = timeseries(x.UncLogic.Data(:,n),x.UncLogic.Time);
    
end

%%
    rbg = cM(mod(n-1,cN)+1,:);
    yOffset = (n-1);
    tsFillPlot(ts,yOffset,rbg);  

