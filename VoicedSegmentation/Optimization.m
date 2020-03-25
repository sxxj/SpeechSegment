%% Threshold Optimization Method
% Another Threshold optimization that tests different window lengths and 
% threshold values for ZCR and STE.
%
% INPUTS:
%   data: The audio data as a [nx1] vector 
%   labels: Labels for the audio as a [nx1] vector
%   winLen: A [1xn] vector of the window lengths to test
%   x_ste: A [1xn] vector of the STE values to test
%   x_zcr: A [1xn] vector of the ZCR values to test
% 
% OUTPUTS:
%   most_accurate: A [4x1] vector that is formated as such
%   [Highest Accuracy, Corrosponding Window Length,
%   Corrosponding STE Threshold, Corrosponding ZCR Threshold] 
%
% EXAMPLE:
%Load data that is alread labeled
tic

file_path = 'D:\Documents\GaTech\Masters\EE 6255\Final Project\LibriSpeech\dev-clean\84\121123';
x = label_audio(file_path,'all');
data = flatten_data(x);
labels = data(:,2);
data = data(:,1);
n = 10; %Number of Threshold Points to test
[x_ste,x_zcr] = thresholds(data,n);
winLen = 2:4;
most_accurate = optimize(data,labels,winLen,x_ste,x_zcr);

toc

function most_accurate = optimize(data,labels,winLen,x_ste,x_zcr)
count = 0;
thresh_accuracy = [];
win_accuracy = [];
for winLength = winLen
    thresh_accuracy = [];
    [win_x_ste,win_x_zcr,win_labels] = window(data,labels,winLength);
for x_ste_1 = x_ste
    for x_zcr_1 = x_zcr
        prediction = predict(win_x_ste,win_x_zcr,win_labels,x_ste_1,x_zcr_1);
        thresh_accuracy = [thresh_accuracy;100*sum(win_labels==prediction)/length(prediction)];
    end
end
[M,I] = max(thresh_accuracy);
win_accuracy = [win_accuracy; [I M]];
count=count+1;
str = sprintf('Completed %i of %i',count,length(winLen));
disp(str)

end
[M,I] = max(win_accuracy(:,2));
most_accurate = [M, winLen(I), mod(win_accuracy(I,1),length(x_zcr)), ceil((win_accuracy(I,1)/length(x_ste)))];
end

function data = flatten_data(x)
data = [];
for i = 1:length(x)
     data = [data;x{i}];
 end
end

function [x_ste,x_zcr] = thresholds(data,n)
winLen = 2;
window = ones(winLen,1);
x_ste = ste(data',window,winLen);
x_ste = linspace(min(x_ste(x_ste~=0)),max(x_ste),n);
x_zcr = linspace(0,100,n);
end

function [win_x_ste,win_x_zcr,win_labels] = window(data,labels,winLen)
window = ones(winLen,1);
win_x_ste = ste(data,window,winLen);
win_x_zcr = zcr(data,window,winLen);

win_labels = buffer(labels,winLen);
if winLen~=1
win_labels = mode(win_labels);
end

end

function prediction = predict(win_x_ste,win_x_zcr,win_labels,x_ste,x_zcr)
prediction = zeros(1,length(win_labels));
prediction(1,win_x_ste(1,:)<=x_ste & win_x_zcr(1,:)<=x_zcr) = 1;
prediction(1,win_x_ste(1,:)>x_ste & win_x_zcr(1,:)>x_zcr) = 2;
prediction(1,win_x_ste(1,:)==0 & win_x_zcr(1,:)==0) = 0;

end