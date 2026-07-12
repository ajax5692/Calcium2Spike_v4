function [dff, F0] = CalculateDff_C2S(x, y, methodName, LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF);
% [dff, F0] = CalculateDff(x, y, methodName) - calculates df/f of a signal y
% (with a time axis x) using one of the following methods:
% 8th percentile ('percentile')
% median ('median') [adapted from Allen Institute.
% x and y should be vectors of the same length and dimensions
%

if nargin < 3
    methodName = 'median';%default
end

%making sure both x and y are row vectors
if ~isrow(x)
    x = x';
end

if ~isrow(y)
    y = y';
end

switch methodName
    case 'median'
        [dff, F0] = local_MedianDff(y,LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);
        
    case 'percentile'
        
        [dff, F0] = local_PercentileDff(y, x, LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF);
        
    otherwise
        error('Unknown method specified!');
end

function [dff,timescaleFilterLong] = local_MedianDff(data,LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF)

dff = data;
for irow = 1:numel(dff(:,1))
    currentDff = dff(irow,:);
    
    longKernel = floor(LONG_KERNEL_COEFF * numel(currentDff));
    shortKernel = floor(SHORT_KERNEL_COEFF * numel(currentDff));
    sigmaF = local_NoiseStd(currentDff);
    
    %long timescale median filter for baseline subtraction
    timescaleFilterLong = local_MedianFilter1(currentDff,longKernel);
    currentDff = currentDff - timescaleFilterLong;
    currentDff = currentDff./(max(timescaleFilterLong, sigmaF));
    
    %short timescale detrending
    sigmaDff = local_NoiseStd(currentDff);
    timescaleFilterShort = local_MedianFilter1(currentDff, shortKernel);
    timescaleFilterShort = min(timescaleFilterShort, 2.5*sigmaDff);
    currentDff = currentDff - timescaleFilterShort;
    dff(irow,:) = currentDff;
end

function [dff, smoothBaseline] = local_PercentileDff(data, xAxis, LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF)
if nargin == 1
    xAxis =[];
end


dataPercentile = 8;
xAxisPercentile = 25;

if ~isempty(xAxis)
    twdw = prctile(xAxis,xAxisPercentile);
    Tsamp = (xAxis(2) - xAxis(1));
    fSamp = 1/Tsamp;
    wdw = round(fSamp*twdw);
else
    wdw = round(prctile([1:numel(data)], xAxisPercentile));
end
numFrames = size(data,2);
numCells = size(data,1);
data = data';
smoothBaseline = zeros(size(data));

if numFrames > 2*wdw
    for itrace = 1:numCells
        dataSlice = data(:,itrace);
        currentWindow = zeros(numFrames-2*wdw,1);
        for idx = wdw+1:numFrames-wdw
            currentWindow(idx-wdw) = prctile(dataSlice(idx-wdw:idx+wdw),dataPercentile);
        end
        smoothBaseline(:,itrace) = [currentWindow(1)*ones(wdw,1) ; 
                                    currentWindow; 
                                    currentWindow(end)*ones(wdw,1)];
        smoothBaseline(:,itrace) = local_runfit(smoothBaseline(:,itrace),wdw,1);
    end
else
    for itrace = 1:numCells
        smoothBaseline(:,itrace) = [ones(numFrames,1)*prctile(data(:,itrace),8)];
    end
end

dff = (data - smoothBaseline)./smoothBaseline;
[dff, sigma, mu] = local_DffNoise(dff); %denoises df/f (moves closer to baseline = 0)
dff = dff';

%%% -------------------Median method helper functions------------------%%%
function nstd = local_NoiseStd(signal, noiseKernelLength, positivePeakScale, outlierStdScale)

%default arguments
if nargin < 2
    noiseKernelLength = 31;
end
if nargin < 3
    positivePeakScale = 1.5;
end
if nargin < 4
    outlierStdScale = 2.5;
end

signal = signal - local_MedianFilter1(signal, noiseKernelLength);
signal = signal(signal < positivePeakScale.*abs(min(signal)));
rstd = local_RobustStd(signal);
signal = signal(abs(signal) < outlierStdScale*rstd);
nstd = local_RobustStd(signal);

function medianFilter = local_MedianFilter1(data, windowSize)
medianFilter = zeros(size(data));
nSamples = numel(data);

if mod(windowSize,2) == 0
    halfWindow = windowSize/2;
else
    halfWindow = (windowSize-1)/2;
end

% paddedData = [zeros(1,halfWindow), data,zeros(1,halfWindow)]; this was
% the original code
paddedData = data;
counter = 1; %this is not present in the original code
for iSample = 1:nSamples

%     original code commented out now
%     currentWindow = paddedData(iSample:iSample+(2*halfWindow));
%     medianFilter(iSample) = median(currentWindow);
    
    try
        currentWindow = paddedData(iSample:iSample+(2*halfWindow));
        medianFilter(iSample) = median(currentWindow);
    catch
        currentWindow = paddedData(iSample:iSample+(2*halfWindow)-counter);
        medianFilter(iSample) = median(currentWindow);
        counter = counter + 1;
    end
end

function rstd = local_RobustStd(signal)

GAUSSIAN_MAD_STD_SCALE = 1.4826; %HARDCODED
medianAbsoluteDeviation = median(abs(signal - median(signal)));
rstd = GAUSSIAN_MAD_STD_SCALE.*medianAbsoluteDeviation;


%%% -------------------Percentile method helper functions------------------%%%
function runFit = local_runfit(data, winsize, step)
% Running line fit (local linear regression)
%
% Inputs: 
% data: input 1-d time series (real)
% winsize: length of running window in samples
% step: stepsize of window in samples
% 
% Outputs:
% runFit: local line fit to data

nY = numel(data);
runFit = zeros(nY,1);
refl = runFit; %duplicating
Nwindows = ceil((nY - winsize)/step); %number of windows in the trace

dataFit = zeros(Nwindows,winsize);
xWindow = ((1:winsize) - winsize/2)/(winsize/2);
wt = (1-abs(xWindow).^3).^3;

for iwin = 1:Nwindows 
	currentWindow = data(step*(iwin-1)+1:step*(iwin-1)+winsize);
	data1 = mean(currentWindow); 
	data2 = mean((1:winsize)'.*currentWindow)*2/(winsize+1);
    
	a = (data2 - data1)*6/(winsize-1); 
    b = data1 - a*(winsize+1)/2;
    
	dataFit(iwin,:) = (1:winsize)*a+b;
    
    sampleIndices = (iwin-1)*step+(1:winsize);
	runFit(sampleIndices) = runFit(sampleIndices)+(dataFit(iwin,:).*wt)';
	refl(sampleIndices) = refl(sampleIndices) + wt';
end
mask = find(refl>0);
runFit(mask) = runFit(mask)./refl(mask);
indx = (Nwindows-1)*step + winsize-1;
npts = length(data)-indx+1;
runFit(indx:end) = (winsize+1 : winsize+npts)'*a+b;

function [dff, sigma, mu] = local_DffNoise(dff)
% [dff, sigma] = visc_dffnoise(dff) - estimate the noise in df/f signal
% and adjust it. Based on
% https://github.com/zebrain-lab/Toolbox-Romano-et-al/blob/master/Toolbox%20software/EstimateBaselineNoise.m

sigma = [];
thr = 0.2;

[f,xi] = ksdensity(dff);

[peak,idx_peak] = max(f);
xtofit = xi(1:idx_peak);
ytofit = f(1:idx_peak);
[A, sigma, mu] = local_Fit(xtofit,ytofit,thr,dff);
yfit = A*exp(-(xi-mu).^2./(2*sigma^2));

dff = bsxfun(@minus,dff, mu);


function [A,sigma, mu] = local_Fit(x,y,thr,dff)

ymax = max(y);
xtrimmed = [];
ytrimmed = [];
%collect only those points which exceed given threshold- maxY*thr
for ix = 1:length(x)
    if y(ix)>ymax*thr
        xtrimmed = [xtrimmed,x(ix)];
        ytrimmed = [ytrimmed,y(ix)];
    end
end
%put in log scale
ytrimmedlog = log(ytrimmed);
xtrimmedlog = xtrimmed;
%fit logged values with 2-nd order polynomial

P = polyfit(xtrimmedlog,ytrimmedlog,2);
%extract Gauss terms
sigma = sqrt(-1/(2*P(1)));
mu = P(2)*sigma^2;
A = exp(P(3)+mu^2/(2*sigma^2));

if isnan(A)
    disp('Doing linear interpolation');
    x2 = linspace(min(x), max(x));
    y2 = interp1(x,y,x2);
    x = x2; y = y2;
    xtrimmed = [];
    ytrimmed = [];
    for ix = 1:length(x)
        if y(ix) > ymax*thr
            xtrimmed = [xtrimmed,x(ix)];
            ytrimmed = [ytrimmed,y(ix)];
        end
    end
    ytrimmedlog = log(ytrimmed);
    xtrimmedlog = xtrimmed;
end
P = polyfit(xtrimmedlog,ytrimmedlog,2);
%extract Gauss terms
sigma = sqrt(-1/(2*P(1)));
mu = P(2)*sigma^2;
A = exp(P(3)+mu^2/(2*sigma^2));

if ~isreal(sigma)
    dev = nanstd(dff);
    outliers = abs(dff)>2*dev;
    
    deltaF2 = dff;
    deltaF2(outliers) = NaN;
    sigma = nanstd(deltaF2);
    mu = nanmean(deltaF2);
    
end