% Function  preparing the parameters for the time-crop based on the sounds
% pattern.
% Requires inputs from the user

% Autor: Valentina Ticcinelli (from Koyo's code), valentina.ticcinelli@unifr.ch, 
% Date: 21/03/2018


function prepare_sound_crop(Part)
load file_names.mat
sourceRoot=destRoot;
if exist('time_crop.mat', 'file')
    load('time_crop.mat');
end
% This section is for detecting the last sound beep through the sound analysis.
% Please specify the file path you want to process.
N=length(Part);
highF=520;
lowF=480;
np=10;

for p=1:N   %participant
    for j=1:8       %expression
   
    for k=1:4   %repetition
         ai_original{5}=[];
          ai{5}=[];
           a{5}=[];
           pks=[]; locs=[];
       for i=1:5
          
             if ~exist([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Part{p} '\timed\'], 'dir'),  ...
                     mkdir([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Part{p} '\timed\']); end
            disp(['Angle ' num2str(i) '/5, Repetition '  num2str(k) '/4, Participant ' Part{p} ', Expression ' num2str(j) '/8'])
            address=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Part{p} '\'  Part{p} Espressions{j} num2str(k) '.mp4'];
            ouput_path=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Part{p} '\timed\'];
            v = VideoReader(address);
            [a{i},Fs] = audioread(address);
            t1=1.5; 
            %t2=t1+10.5;
            
            t=[0:1/Fs:30];
            % sound information is BAND-pass filtered around 500Hz     
            f = Fs*(0:(length(a{i})/2))/length(a{i});
            low=findSimilar(f,lowF);
            high=findSimilar(f,highF);
            F=fft(a{i});
            F(1:low)=0;
            F(high:length(f))=0;
            ai_original{i}=ifft(F);
            ai{i}=ai_original{i};
            ai{i}(1:t1*Fs) = 0;
            %ai{i}(t2*Fs:end) = 0;
            
            [pks(:,i),locs(:,i)]= findpeaks(abs(ai{i}),'Npeaks',np,'SortStr','descend','MinPeakDistance',0.8*Fs);
            [locsP(i),ii] = min(locs(:,i));
            [pksP(i)] = (pks(ii,i));
       end   
       locstd=std(locsP); 
       locsI.(Part{p})(j,k,:)=locsP;
       %locsAv(p,j,k)=round(mean(locs(1,:)));
       
       %if the location of peaks is suspiciously far apart, check it and
       %replace the wrong with the write ones
       vv=1;
       
       if locstd>0.3*Fs   
           while vv==1
               col=[246, 81, 29
               255, 180, 0
               0, 166, 237
               127, 184, 0
               13*2, 44*2, 84*2]/255;

           figure
          set(gcf,'position',[105   100   871   869])
           for i=1:5
               subplot(5,1,i) 
               hold on
             
               plot(t(1:length(ai{i})),a{i},'Color',[0.8 0.8 0.8],'LineWidth',1)
               plot(t(1:length(ai{i})),abs(ai{i}),'Color',col(i,:),'LineWidth',1)
               plot(t(locsP(i)),pksP(i),'x','MarkerEdgeColor', col(i,:),'MarkerSize',20,'LineWidth',4)
               title(['Camera ' num2str(i)])  
               vline(t1)
           end
           xlabel('Time (s)')
     

           prompt = {'Enter the number of the WRONG detections:','Enter the number of RIGHT detections to replace:','Change the initial time:'};
           dlg_title = 'Input';
           num_lines = 1;
           defaultans = {'3','3',num2str(t1)};
           x = inputdlg(prompt,dlg_title,num_lines,defaultans);   
           if ~strcmp(x{3},num2str(t1))
               close all


           t1=str2double(x{3}); 
           t2=t1+10.5;
           pks=zeros(10,5); locs=zeros(10,5);
            for i=1:5 
            ai{i}=ai_original{i};
            ai{i}(1:t1*Fs) = 0;
            ai{i}(t2*Fs:end) = 0;
            [xx,pp]=findpeaks(abs(ai{i}),'Npeaks',np,'SortStr','descend','MinPeakDistance',0.8*Fs);
            if length(xx)<10
                xx(end:10)=xx(end);
                pp(end:10)=pp(end);
            end
            pks(:,i)= xx;
            locs(:,i)= pp;
            [locsP(i), ii] = min(locs(:,i));
            [pksP(i)] = (pks(ii,i));
            end
            close all
            figure
          set(gcf,'position',[105   100   871   869])
           for i=1:5
               subplot(5,1,i) 
               hold on
               
               plot(t(1:length(ai{i})),a{i},'Color',[0.8 0.8 0.8],'LineWidth',1)
               plot(t(1:length(ai{i})),abs(ai{i}),'Color',col(i,:),'LineWidth',1)
               plot(t(locsP(i)),pksP(i),'x','MarkerEdgeColor', col(i,:),'MarkerSize',20,'LineWidth',4)
               title(['Camera ' num2str(i)])
               vline(t1)
           end
            locstd=std(locsP); 
            locsI.(Part{p})(j,k,:)=locsP;
             button = questdlg('Is it correct?','Check peaks detection','Yes','No','Yes');
             if strcmp(button,'Yes')
                 vv=0;
             end
           else
               vv=0;
           end
           
                   
           locsI.(Part{p})(j,k,str2double(x{1})) = locsP(str2double(x{2}));    
           close all
          save time_crop.mat locsI
           end
       end
       
       
    end
 end
end
save time_crop.mat locsI
% for p=1:N      %participant
% for j=1:8       %expression
%  
%     for k=1:4   %repetition
%        for i=1:5
%             if ~exist([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\'], 'dir'),  ...
%                      mkdir([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\']); end
%             disp(['Angle ' num2str(i) '/5, Repetition '  num2str(k) '/4, Participant ' Participants{p} ', Expression ' num2str(j) '/8'])
%             address=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\' names.(Participants{p}){i,j,k}];
%             ouput_path=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\'];
%             v = VideoReader(address);
%             first_sound_timing = locsI.(Participants{p})(j,k,i)/Fs;
%             v.CurrentTime = first_sound_timing;
%             kk = 1;
%             clear mov
%             while hasFrame(v) & kk <= v.FrameRate*11 && kk<= Fs*10
%                 mov(kk) = im2frame(readFrame(v));
%                 kk = kk + 1;
%             end
%             % output the preprocessed files
%             o = VideoWriter([ouput_path, names.(Participants{p}){i,j,k}],'MPEG-4');
%             open(o);
%             writeVideo(o,mov);
%             close(o);
%           %  saveas(gcf,[ouput_path, names{p,i,j,k},'.png']);
%             close all;
%       end
%     end
%   end
% end
% 
% 
% 
%     
