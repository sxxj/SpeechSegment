%% Zero Crossing Rate 
%
% INPUTS:
%   audio = audio array with dimensions [1,n]
%   window = array with window values (see below)
%   winLen = Length of the window 
%
% OOUTPUTS:
%   Short term ernergy array with dimensions [n/winLen,1]
% 
% WINDOWS:
%   Rect: ones(winLen,1);
%   Gaussian: gausswin(winLen)
%   Chebyshev: chebwin(winLen)
function xx = zcross(audio,window,winLen)
audio(audio>=0) = 1;
audio(audio<0) = -1;
xx = 0.5*sum(diff(buffer(audio, winLen),1,2).*window);
end