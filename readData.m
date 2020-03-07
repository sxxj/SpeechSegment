%% Read and Store Multiple Audio Files
%
% INPUT: 
%   folder_path: A string to the folder with the audio files
%   count: number of audio files to save or the string all for all the
%   files
%
% OUTPUT: 
%   A 1xn cell with the audio data where n is equal to count
%
% EXAMPLE
% x = readData('C:\Documents\EE 6255\AudioFolder','all');
% or
% x = readData('C:\Documents\EE 6255\AudioFolder',5);


function x = readData(folder_path,count)
str = [".wav",".mp3"];
if isfolder(folder_path) == 0
    ME = MException('%s is not a valid path',folder_path);
    throw(ME)
end

contents = dir(folder_path);
x = struct2cell(contents)';
audio_files = find(contains(x(:,1),str,'IgnoreCase',true));

if count ~= 'all'
    if count>=length(audio_files)
        disp('There are only %s audio files',length(audio_files))
    else 
        audio_files = audio_files(1:count);
    end
end

file_paths = x(audio_files,2);
file_names = x(audio_files,1);
paths = strcat(file_paths,'\');
paths = strcat(paths,file_names);
x = {};

for i = 1:length(paths(:,1))
    x{i}  = audioread(cell2mat(paths(i)));
end
end