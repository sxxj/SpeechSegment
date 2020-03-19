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
xx = (diff(buffer(audio, winLen)));
xx = length(xx(xx == 0));
end
