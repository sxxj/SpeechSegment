%% Basic Threshold Optimization Method
% This code chooses different values of ZCR and STE as a threshold to 
% discern unvoiced and voiced regions. An accuracy of 93.775% was achieved
% here though different window lengths could give different results. 

%Load data that is alread labeled
file_path = 'D:\Documents\GaTech\Masters\EE 6255\Final Project\dataexport.txt';
data = readmatrix(file_path);
%data = [x_ste' x_zcr' labels'];  
%winLen = 60;

%Thresholds
silence_ste = 0;
silence_zc = 0;
n = 100; %number of test points
unvoiced_ste = linspace(min(data(data(:,1)~=0)),max(data(:,1)),n);
unvoiced_zc = linspace(min(data(data(:,2)~=0)),max(data(:,2)),n);
estimate = zeros(length(data),1);

accuracy = [];


for i = unvoiced_ste
    for j = unvoiced_zc
estimate(data(:,1)<=i & data(:,2)<=j ...
    & data(:,1)~=silence_ste & data(:,2)~=silence_zc,1) = 1;
estimate(data(:,1)>i & data(:,2)>j,1) = 2;  
accuracy = [accuracy;100*sum(data(:,3)==estimate)/length(data)];
 
    end
end


