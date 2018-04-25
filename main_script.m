%Complete processing of videos divided in separate functions. Each function
%saves the input for the next in a .mat file, and modifies the video file
%in the relevant folder

% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 21/03/2018

clear all
clc
close all

%% 

destRoot='H:\database swiss';
Fs=32000;
Angles={'1 Right','2 Front Right','3 Front','4 Front Left','5 Left'};
Espressions={'anger','disgust','fear','happiness','neutral','neutral_chewing','sadness','surprise'};


%% INSERT HERE THE NAMES OF THE PARTICIPANTS 
% IN CURLY BRAKETS (e.g {'F3','M4'})
% AND THE FOLDER CONTAINING ALL THE UNSORTED RAW FILES

Participants={'F6','F7','F8', 'M5','M11','F5'}; %'M5','M6','M7','M8','M9','M10','M12',
sourceRoot='H:\A trier';
rename_files(Participants)

%% move the files in the corresponding folder
move_files(Participants,sourceRoot)


%% time-crop the videos
prepare_sound_crop(Participants)
sound_crop(Participants)


%% space-crop the videos

prepare_space_crop_and_removeBG(Participants)  % or prepare_space_crop(Participants,'check') to chech the automatic detection
space_crop_and_removeBG(Participants)

