%% Label Multiple Clean Audio Files
% INFO:
%   This function labels clean audio. It assumes that only voiced and 
%   and unvoiced regions appear in the audio. 
% INPUT: 
%   The same inputs as readData.m
%   folder_path: A string to the folder with the audio files
%   count: number of audio files to save or the string all for all the
%   files
%
% OUTPUT: 
%   A 1xn cell 
%   Each cell countains a nx2 array. The first column in the array is the 
%   audio. The second colum is the label array. Each array is sampled as
%   such:
%   0: Silent
%   1: Unvoiced (noise)
%   2: Voiced
%
% EXAMPLE
% x = labelData('C:\Documents\EE 6255\AudioFolder','all');
% or
% x = labelData('C:\Documents\EE 6255\AudioFolder',5);


function x = labelData(folder_path,count)
[x,fs] = readData(folder_path,count);
for i=1:length(x)
%Extract each audio file
y = x{i};
audio = find(y~=0);

%Add white noise
noise_length = length(y)-round(find(y~=0,1,'first')*(2/3));
var = max(y)/30;
noise = var.*[zeros(length(y)-noise_length,1); randn(noise_length,1)];
y = y+noise;

%label Audio
y2 = zeros(length(y),1);
y2(length(y)-noise_length:length(y)) = 1;
y2(audio) = 2;
y(:,2) = y2;
plot(y(:,1))
x{i} = y;
end
end