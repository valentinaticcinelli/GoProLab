% Function  for sound crop, based on the parameters set in 
% 'prepare_sound_crop.m'
% Can be run without supervision from the user.

% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 21/03/2018

function sound_crop(Participants)
load file_names.mat
sourceRoot=destRoot;
load('time_crop.mat');


N=length(Participants);


for p=1:N       %participant
  for j=1:8     %expression 
    for k=1:4   %repetition
       for i=1:5
            if ~exist([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\'], 'dir'),  ...
                     mkdir([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\']); end
            disp(['Participant ' Participants{p} ', Expression ' num2str(j) '/8, Repetition '  num2str(k) '/4, Angle ' num2str(i) '/5'])
            address=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\'  Participants{p} Espressions{j} num2str(k) '.mp4'];
            ouput_path=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\'];
            v = VideoReader(address);
            first_sound_timing = locsI.(Participants{p})(j,k,i)/Fs;
            v.CurrentTime = first_sound_timing;
            kk = 1;
            clear mov
            while hasFrame(v) & kk <= v.FrameRate*11 && kk<= Fs*10
                mov(kk) = im2frame(readFrame(v));
                kk = kk + 1;
            end
            % output the preprocessed files
            o = VideoWriter([ouput_path  Participants{p} Espressions{j} num2str(k)],'MPEG-4');
            open(o);
            writeVideo(o,mov);
            close(o);
            close all;
      end
    end
  end
end


