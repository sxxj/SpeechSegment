%%
file_path = 'D:\Documents\GaTech\Masters\EE 6255\Final Project\LibriSpeech\dev-clean\84\121123\sample';
x = label_audio(file_path,'all');
data = flatten_data(x);
labels = data(:,2);
data = data(:,1);

winLen = 60;


ste_lim = 0.000124;
zcr_lim = 15;
[audio_ste,audio_zcr,win_labels] = window(data,labels,winLen);
prediction = predict(audio_ste,audio_zcr,win_labels,ste_lim,zcr_lim);
acc = 100*sum(win_labels==prediction)/length(prediction);
str = sprintf('acc: %f, i: %i',acc,i);
disp(str)
cases = [win_labels',prediction',audio_ste',audio_zcr'];
%%
%data = WienerScalart96(data,fs,0.08);
prediction = repmat(prediction,[60,1]);
prediction = reshape(prediction,1,[]);
length_differance = length(prediction)-length(data);
prediction = prediction(1:end-length_differance);
silent_region = data(prediction==0);
unvoiced_region = data(prediction==1);
voiced_region = data(prediction==2);
audiowrite('sielnce.wav',silent_region,16000);
audiowrite('unvoiced.wav',unvoiced_region,16000);
audiowrite('voiced.wav',voiced_region,16000);
clean_voiced = WienerScalart96(voiced_region,16000,0.06);
audiowrite('clean_voiced.wav',clean_voiced,16000);
%%
function [win_x_ste,win_x_zcr,win_labels] = window(data,labels,winLen)
window = ones(winLen,1);
win_x_ste = ste(data,window,winLen);
win_x_zcr = zcr(data,window,winLen);

win_labels = buffer(labels,winLen);
if winLen~=1
win_labels = mode(win_labels);
end

end

function data = flatten_data(x)
data = [];
for i = 1:length(x)
     data = [data;x{i}];
 end
end

function prediction = predict(audio_ste,audio_zcr,win_labels,ste_lim,zcr_lim)
prediction = zeros(1,length(win_labels));
for i = 1:length(win_labels)
    
if audio_ste(i)<=ste_lim
    prediction(i) = 2;
elseif audio_ste(i)>ste_lim
    if audio_zcr(i)<zcr_lim
        prediction(i) = 2;
    else
        prediction(i) = 1;
    end
end

if audio_zcr(i)==0
    prediction(i) = 0;
end


end
end
function plot_data(data,labels,winLen)
index = 1:length(data);
voiced = '.g';
unvoiced = '.r';
silence = '.k';
labels = repmat(labels,[winLen,1]);
labels = reshape(labels,1,[]);
figure;
for i = 1:length(data)
    
    if labels(i) == 0 
        plot(i,data(i),silence)
        xlim([1,length(data)])
        hold on
    end
    if labels(i) == 1
        plot(i,data(i),silence)
        xlim([1,length(data)])
        hold on
    end
    if labels(i) == 2
        plot(i,data(i),voiced)
        xlim([1,length(data)])
        hold on
    end
        


end
end