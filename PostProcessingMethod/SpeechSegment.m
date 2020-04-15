close all
clc
clear

tic

data = audioread('parrot.wav');
data = data(:,1);
datax = data;
fs = 44100;
data = WienerScalart96(data,fs,0.08);
prediction = [zeros(length(datax)-length(data),1); data.*datax(1:length(data))];
labels = [zeros(1,1.2e4) ones(1,1.6e4) zeros(1,2e4) ones(1,1.8e4) zeros(1,length(data)-6.6e4)];
threshold = 10e-4;

%%
prediction = abs(prediction);

for i = 1 : 1 : length(prediction)
    
   if prediction(i) > threshold
        prediction(i) = 1;
   else
       prediction(i) = 0;
   end
    
end

%%
for i = 1 : 1 : length(prediction) - 100
    
    a = sum(prediction(i:i+100));
    if a > 1
        prediction(i) = 1;
    else
        prediction(i) = 0;
    end

end
%%
plot(prediction);
hold on;
plot(labels*2);
ylim([0 2])

accuracy = corrcoef(prediction(1:length(labels)),labels)

toc
%%
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
