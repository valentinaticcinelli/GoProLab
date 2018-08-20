% Function for space cropping and removing background 
% based on the parameters set in 'prepare_space_crop_and_removeBG.m'
% Can be run without supervision from the user.

% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 21/03/2018

function filter_flickers(Participants)

if exist('file_names.mat','file'), load file_names.mat, end
if exist('edges.mat','file'), load edges.mat, end



sourceRoot=destRoot;


N=length(Participants);

for p=1:N      %participant
     for j=1:8       %expression
       for k=1:4   %repetition
         for i=1:5   %cameera
             disp(['Filter for Part:' Participants{p} ' espr:' num2str(j) ' rep:' num2str(k) 'cam:' num2str(i) ])    ;     
           address=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\black\' Participants{p} Espressions{j} num2str(k) '.mp4'];
           if ~exist([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\filt20\'], 'dir'),  ...
                     mkdir([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\filt20\']); end
            vid1=VideoReader(address);
            n(i,j,k)=vid1.NumberOfFrames;
            writerBlack =  VideoWriter([sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\filt20\' Participants{p} Espressions{j} num2str(k)],'MPEG-4');
            open(writerBlack);
             imR=zeros(vid1.Height,vid1.Width,n(i,j,k));
             imG=imR;
             imB=imR;
            for f=1: n(i,j,k)%20
                tmp=read(vid1,f);
                imR(:,:,f)=tmp(:,:,1);
                imG(:,:,f)=tmp(:,:,2);
                imB(:,:,f)=tmp(:,:,3);               
            end
            for ix=1:vid1.Height-1
                for iy=1:vid1.Width-1
                    if Edg.(Participants{p}).Angles{1,i}.Espressions{1,j}(ix,iy,k)
                   imR(ix,iy,:)=hampel(double(squeeze(imR(ix,iy,:))),20);
                   imG(ix,iy,:)=hampel(double(squeeze(imG(ix,iy,:))),20);
                   imB(ix,iy,:)=hampel(double(squeeze(imB(ix,iy,:))),20);  
                    end
                end
            end
            im=zeros(vid1.Height,vid1.Width,3,n(i,j,k));
            for iii=1:n(i,j,k)
                im(:,:,1,iii)=imR(:,:,iii);
                im(:,:,2,iii)=imG(:,:,iii);
                im(:,:,3,iii)=imB(:,:,iii);
            end
            im2=round(im);
            im3=uint8(im2);
            for ii=1:n(i,j,k)
                writeVideo(writerBlack,squeeze(im3(:,:,:,ii)));
            end
            close(writerBlack)
         end
        end
      end
    end