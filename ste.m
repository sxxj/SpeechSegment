%% Short Term Energy
%
% INPUTS:
%   audio = audio array with dimensions [1,n]
%   window = array with window values (see below)
%   winLen = Length of the window 
%
% OUTPUTS:
%   Short term ernergy array with dimensions [n/winLen,1]
% 
% WINDOWS:
%   Rect: ones(winLen,1);
%   Gaussian: gausswin(winLen)
%   Chebyshev: chebwin(winLen)

function xx = ste(audio,window,winLen)
norm = 1/(sqrt(length(audio)));
xx = norm.*sum((buffer(audio, winLen).*window).^2);
end