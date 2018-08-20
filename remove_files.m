% Remove files for one actor from the folders. 

% The parameters to be set are the 'destination' paths
% (the level above '1 Right','2 Front Right','3 Front','4 Front Left','5 Left')
% and the name of the actor which files are to be removed
% ({'F2'})

% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 28/02/2018



function remove_files(Participants)
%% PLEASE UPGRADE THESE PARAMETERS

%Paths for the source and destination folders to copy and paste the files
destRoot='H:\database swiss';

%Names of the actors whose files are contained in each folder and must be
%removed
for i=1:length(Participants)

%% WARNING DIALOGUE
choice = questdlg(['Continuing will erese permanently the videos from the actor ' Participants{i} '. Are you sure that you want to proceed?'], ...
	'!!Warning!!', ...
	'Yes, proceed','No, stop the script','No, stop the script');
% Handle response
switch choice
    case 'Yes, proceed'
    case 'No, stop the script'
        return
end


%% SCRIPT

Angles={'1 Right','2 Front Right','3 Front','4 Front Left','5 Left'};
Espressions={'anger','disgust','fear','happiness','neutral','neutral_chewing','sadness','surprise'};


currentFolder = pwd;



for i=1:5
    for j=1:8
            cd ([destRoot '\' Angles{i} '\' Espressions{j}])
            if exist([destRoot '\' Angles{i} '\' Espressions{j} '\' Participants{i}], 'dir') 
                 A = dir( [destRoot '\' Angles{i} '\' Espressions{j} '\' Participants{i}]);
                for k = 1:length(A)
                    delete([destRoot '\' Angles{i} '\' Espressions{j} '\' Participants{i} '\' A(k).name])
                end
                rmdir(Participants{i}); 
            end
cd(currentFolder);
    end
end
end