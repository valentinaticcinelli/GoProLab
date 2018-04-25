% Function for space cropping and removing background 
% based on the parameters set in 'prepare_space_crop_and_removeBG.m'
% Can be run without supervision from the user.

% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 21/03/2018

function space_crop_and_removeBG(Participants)
load param_remove_green.mat 
load cropping_input.mat
load file_names.mat
sourceRoot=destRoot;

N=length(Participants);
for p=1:N
    x=param_remove_green.(Participants{p});
    for j=1:8       %expression
     for p=1:N      %participant
       for k=1:4   %repetition
         for i=1:5   %cameera
           address=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\' Participants{p} Espressions{j} num2str(k) '.mp4'];
           if ~exist([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\black\'], 'dir'),  ...
                     mkdir([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\black\']); end
            vid1=VideoReader(address);
            n(i,j,k)=vid1.NumberOfFrames;
            writerBlack =  VideoWriter([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\black\' Participants{p} Espressions{j} num2str(k)],'MPEG-4');
            open(writerBlack);
            for f=1: n(i,j,k)%20
                f
                im=read(vid1,f);
                imc=imcrop(im,squeeze(rect.(Participants{p})(i,j,k,:))+[lim(i,3); lim(i,1); 0; 0]);%,[ cropXY(i,:) sC(i) sC(i)]);% The dimention of the new video
                sC=size(imc);
                propX=sC(2)/sC(1)*501;
                cropped{i,j,f}=imc;
                imcB=remove_green( cropped{i,j,f},str2num(x{1}),str2num(x{2}),str2num(x{3}),str2num(x{4}));
                writeVideo(writerBlack,imcB);  
            end
            close(writerBlack)
         end
        end
      end
    end
end