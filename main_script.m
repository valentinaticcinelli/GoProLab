%Complete processing of videos divided in separate functions. Each function
%saves the input for the next in a .mat file, and modifies the video file
%in the relevant folder

% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 26/04/2018

clear all
clc
close all

%% Initialize static variables

destRoot='H:\database swiss';
Fs=32000;
Angles={'1 Right','2 Front Right','3 Front','4 Front Left','5 Left'};
Espressions={'anger','disgust','fear','happiness','neutral','neutral_chewing','sadness','surprise'};

save ('file_names.mat')


%% INSERT HERE THE NAMES OF THE PARTICIPANTS 
% IN CURLY BRAKETS (e.g {'F3','M4'})
% AND THE FOLDER CONTAINING ALL THE UNSORTED RAW FILES

Participants={'F6','F7','F8', 'M5','M6','M7','M8','M9','M10','M11','M12'}; %,
sourceRoot='H:\A trier';



%% Rename files according to [unsorted folder_folder '\named\' Participants{p} Espressions{j} repetition(k) '.MP4']

rename_files(Participants)


%% move the files in the corresponding sorted  folder of the final database
% like: [ destRoot '\' Angles{i} '\' Espressions{j} '\' Participants{p}'\'  Participants{p} Espressions{j} num2str(k) '.MP4' ];

move_files(Participants,sourceRoot)


%% time-crop the videos in two stages: one with user checking and one just computing

prepare_sound_crop(Participants)
sound_crop(Participants)


%% space-crop the videos in two stages: one with user checking and one just computing

prepare_space_crop_and_removeBG(Participants,'check')  % or 
%prepare_space_crop(Participants)                       % to just see the final crop and not interacting with it

skipped_eye_error %run this to correct a specific set of space-crops went wrong (because of eye detected wrong)

space_crop_and_removeBG(Participants)


%%        *********RUN THIS ONLY IF ******************
%  one actor has to be removed from the final database

To_be_removed={'M1','F2'};
remove_files(To_be_removed);

