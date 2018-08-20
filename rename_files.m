% Rename files according to [unsorted_folder '\named\' Participants{p} Espressions{j} repetition(k) '.MP4']
  
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
                while ~exist([source '\GOPR' sprintf('%04d',f+c-1) '.MP4'])  
                    c=c+1;
                end
                sourceN=[source '\GOPR' sprintf('%04d',f+c-1)  '.MP4']
                destinationN=[source '\named\' Participants{p} Espressions{j} num2str(k) '.MP4']
                copyfile(sourceN,destinationN );
          end
        end
        end
    end
end
 cd(currentFolder);