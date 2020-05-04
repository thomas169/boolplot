function randomPlot()
% *************************************************************************
% Program:      Boolean Ploter
%
% File:         <a href="matlab:open('randomPlot.m')">randomPlot.m</a>
%
% Functions:    randomPlot()
%
% Description:  Run a boolPlot() demo
%
% Arguments:    None
%
% Returns:      Nothing
%
% Useage:       randomPlot
%
% Revisions:    1.00 04/05/20 (tf) First release
%
% See also:     boolPlot
% *************************************************************************

%% randomPlot

tl = 96; 
n = 16; 

data = randi([0,1],tl,n);
time = 0:tl-1;

if randi([0,1])
    data = timeseries(data,time);
end

boolPlot(data);