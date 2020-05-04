% run a test
tl = 128; 
n = 32; 

data = randi([0,1],tl,n);
time = 0:tl-1;
boolPlot(data)

timeseries(data,time)
boolPlot(data)