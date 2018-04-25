% Rename files

% The parameters to be set are the 'source' paths
% (the level above '1 Right','2 Front Right','3 Front','4 Front Left','5 Left')
% and the names of the actors which files are to be sorted 
% ('F2, F3, 'M6', 'M7') if they are the 2nd and 3rd female actresses, and the
%  6th and 7th male actors.
%  For each camera, the VIDEO FILES must be copied in a source folder named:
% '1 Right','2 Front Right','3 Front','4 Front Left','5 Left'

% In the destination folder (set in 'set_names.m') the same '1 Right','2 Front Right','3 Front','4 Front Left','5 Left' 
% structure for the cameras is copied, 
% and the following substructure is created:
% for the emotions, in each camera folder: 'anger','disgust','fear','happiness','neutral','neutral (chewing)','sadness','surprise'
% for the actors, in each emotions folder: 'F1', 'F2', ..., 'Fn', and 'M1', 'M2'...'Mn', accordinf to the names provided. 
% In the end of the process, 4 video files will be present in each final subfolder.     

% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 21/03/2018

function rename_files(Participants)

load file_names.mat

%% Chech that all the files are present

currentFolder = pwd;
N=length(Participants);
sourceRoot='H:\A trier';


%% actual actions

for p=1:N  
    for i=1:5
        
        cd([sourceRoot '\' Angles{i} '\' Participants{p}]);
        fileList = dir('*.MP4');
        cl=1;

        while strcmp(fileList(cl).name(1:2),'._')
            cl=cl+1;
        end

        first=str2double(fileList(cl).name(5:8));
        source=[sourceRoot '\' Angles{i} '\' Participants{p}];      
        if ~exist([source '\named'], 'dir'),  mkdir([source '\named']); end
        f=first;  
        c=0; 
        tot=0;
        for k=1:4
        for j=1:8
            j 
            k
            tot=tot+1;
            c=c+1;
            if tot<=32
                while ~exist([source '\GOPR0' num2str(f+c-1) '.MP4'])  
                    c=c+1;
                end
                sourceN=[source '\GOPR0' num2str(f+c-1) '.MP4']
                destinationN=[source '\named\' Participants{p} Espressions{j} num2str(k) '.MP4']
                copyfile(sourceN,destinationN );
          end
        end
        end
    end
end
