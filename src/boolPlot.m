function hPlot = boolPlot(data, time)
% *************************************************************************
% Program:      Boolean Ploter
%
% File:         <a href="matlab:open('boolPlot.m')">boolPlot.m</a>
%
% Functions:    hPlot = boolPlot(data, time)
%
% Description:  Makes a stacked plot for boolean values.
%
% Arguments:    data:
%                   timeseries object or a nueric array, can a be matrix.
%               time:
%                   time vector, only used if the "data" arg is numeric. In
%                   this case time may still be ommited.
%
% Returns:      hPlot:
%                   handle to the produced figure
%
% Useage:       boolPlot(randi([0,1],50,5))
%
% Revisions:    1.00 04/05/20 (tf) First release
%
% See also:     randomPlot
% *************************************************************************

%% boolPlot

openNewFigure = false;
figTag = 'boolPlotFig';
figName = 'Boolean Plot';
tsData = isa(data,'timeseries');
numData = isnumeric(data);
boolHeight = 1;
boolSpace = 0.5;
trueLable = '';
falseLabel = '';

assert(tsData || numData,'data must be numeric or a timeseries')

if openNewFigure
    hPlot = figure('Name',figName, 'tag',figTag);
    hAxe = axes(hPlot);
else
    hPlot = findobj(0,'tag',figTag);
    if isempty(hPlot)
        hPlot = figure('Name',figName', 'tag',figTag);
        hAxe = axes(hPlot);
    else
        clf(hPlot);
        hAxe = axes(hPlot);
        figure(hPlot);
    end
end

cM = get(0,'DefaultAxesColorOrder');
cN = size(cM,1);

if numData
    if isrow(data)
        data = transpose(data);
    end
    if nargin < 2
        tsData = timeseries(data,0:length(data)-1);
    else
        assert(isrow(time),'time nust be a row vector')
        if (find(size(data) == numel(time),1) ~= 1)
            data = transpose(data);
        end
        tsData = timeseries(data,time);
    end
elseif tsData
    tsData = data;
end

[tsPlot, nPlot] = compressTimeseries(tsData);
yOffset = 0;
yTickLabel = cell(1,nPlot*3);
minT = inf;
maxT = 0;

for n = 1 : nPlot
    idx = (n-1)*3+1;
    yTickLabel(idx:idx+2) = {falseLabel,['Bit' num2str(n-1)],trueLable};
    y = tsPlot(n).Data;
    x = tsPlot(n).Time;
    minT = min(minT,min(x));
    maxT = max(maxT,max(x));
    rbg = cM(mod(n-1,cN)+1,:);
    Y = [];
    if isvector(x) && ismatrix(y) && size(y,1)==length(x)
        x = reshape(x,length(x),1);   
    else
        error('x and y dimentions should be consistent.')
    end
    for k = 1 :size(y,2)
        x = [x';x'];
        temp = [y(:,k)';y(:,k)'];
        temp = temp(:);
        Y(:,k) = temp; %#ok<AGROW>
        xPlot = [x([2:end end]), fliplr(x([2:end end]))];
        yPlot = boolHeight * [Y; zeros(length(xPlot)/2,size(Y,2))];
        patch(hAxe,'XData',xPlot,'YData',yPlot+yOffset,'FaceColor',rbg);
        yOffset = yOffset + boolHeight + boolSpace;
    end
end

yTickPos = [0,cumsum(repmat([boolHeight/2, boolHeight/2,boolSpace],1,nPlot))];

set(hAxe,'YTick',yTickPos(1:end-1))
set(hAxe,'YTickLabel',yTickLabel);
set(hAxe,'TickLength',[0 0]);
set(hAxe,'XLim',[minT maxT]);
set(hAxe,'YLim',[0 yOffset]);

end

function [tsOutArray, nElem] = compressTimeseries(tsIn)
    nTime = numel(tsIn.Time);
    nElem = numel(tsIn.Data)/nTime;
    allData = boolean(tsIn.Data);
    indexAllData = @(n) (n-1)*nTime+1:(n-1)*nTime+nTime;
    tsOutArray(nElem) = timeseries;
    for n = 1 : nElem
        elemData = allData(indexAllData(n));
        deltaIdx = [true; (diff(elemData(1:end-1))~=0)'; true];
        deltaData = elemData(deltaIdx);
        deltaTime = tsIn.Time(deltaIdx);
        tsOutArray(n) = timeseries(deltaData',deltaTime);
    end
end