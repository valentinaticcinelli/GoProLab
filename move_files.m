% Move files from the SD in the right folders. 

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

function move_files(Participants, sourceRoot)

load file_names.mat

%% Chech that all the files are present

currentFolder = pwd;
N=length(Participants);

for p=1:N
    for i=1:5
        cd([sourceRoot '\' Angles{i} '\' Participants{p} '\named']);
        fileList = dir('*.MP4');
        c=1;
        while strcmp(fileList(c).name(1:2),'._')
            c=c+1;
        end
        c=c-1;
        L=length(fileList)-c;
        cd(currentFolder);
        assert((L==4*8),['ERROR! The number of files (' num2str(L) ') in the folder <' Angles{i} '\' Participants{p} '\named>  does not match the expected number of files (' num2str(4*8) ') . Moving the files in this situation would create a lot of mess! Please check your files and provide only complete sessions (4*8 videos for each actor)'])         
    end
end

%% actual actions

for p=1:N  
    for i=1:5
        source=[sourceRoot '\' Angles{i} '\' Participants{p} '\named'];        
        if ~exist([destRoot '\' Angles{i}], 'dir'),  mkdir([destRoot ,'\' Angles{i}]); end
        for j=1:8
            if ~exist([destRoot '\' Angles{i} '\' Espressions{j}], 'dir'),  mkdir([destRoot  '\' Angles{i} '\' Espressions{j}]); end
        
            if ~exist([destRoot '\' Angles{i} '\' Espressions{j} '\' Participants{p}], 'dir'),  mkdir([destRoot  '\' Angles{i} '\' Espressions{j} '\' Participants{p}]); end
            for k=1:4           
                destination=...
                [ destRoot '\' Angles{i} '\' Espressions{j} '\' Participants{p} ];
                %cd(destination)
%                 n=f+cc+in;
%                 if exist([source '\GOPR0' num2str(n) '.MP4'])
%                 sourceN=[source '\GOPR0' num2str(n) '.MP4'];
%                 else
%                     while ~exist([source '\GOPR0' num2str(n+cc) '.MP4'])  
%                     cc=cc+1;
%                     end
                sourceN=[source '\' Participants{p} Espressions{j} num2str(k) '.MP4'];
%                 end
                destinationN=[destination '\'  Participants{p} Espressions{j} num2str(k) '.MP4']

                copyfile(sourceN,destinationN );
            end
        end
    end
end
