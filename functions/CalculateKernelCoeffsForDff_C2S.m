function [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoeffsForDff_C2S(y,frameRate);

if nargin < 2
    LONG_KERNEL_COEFF = 0.0468; %original value on the paper
    SHORT_KERNEL_COEFF  = 8.7476e-04; %original value on the paper
else
    windowSizeLONG = 180; %this is in seconds. same value as the paper
    
    windowSizeSHORT = 20; %original value was 3.3 seconds in the paper.
                          %changed to eliminate dip in the df/f
                          
    SHORT_KERNEL_COEFF = (windowSizeSHORT*frameRate)/size(y,2);
    LONG_KERNEL_COEFF = (windowSizeLONG*frameRate)/size(y,2);
end
