%function to run the spce crop ONLY for a specific set of files
% Autor: Valentina Ticcinelli, valentina.ticcinelli@unifr.ch, 
% Date: 26/04/2018

function skipped_eye_error
load param_remove_green.mat 
load cropping_input.mat
load file_names.mat
sourceRoot=destRoot;
button = questdlg('Did you accidentally skip an error?','Check skipped errors','Yes','No','Yes');

if strcmp(button,'Yes')  
   prompt = {'Subject:','Espression','Repetition'};
   dlg_title = 'Input';
   num_lines = 1;
   defaultans = {'F1 M1 M1','1 3 2','1 1 3'};
   x = inputdlg(prompt,dlg_title,num_lines,defaultans);           
   Participants=strsplit(x{1});
   J=str2num(x{2});
   K=str2num(x{3});
   
   check=1;
   
halfY=1440/2; halfX=1920/2; quartY=1440/4; quartX=1920/4; thirdY=1440/3; thirdX=1920/3; sixthY=round(1440/6); sixthX=round(1920/6);
lim=[  sixthY   halfY+sixthY      1 halfX ; 
       quartY   halfY+quartY      quartX halfX+quartX ;
       thirdY   2*thirdY  thirdX  2*thirdX;
       quartY   halfY+quartY      quartX halfX+quartX  ;
       quartY   halfY+quartY     halfX  halfX+halfX];

%% threshold and other parameters for eye detection

thr=[4 4 4 4 4];
target={'RightEye','RightEye','EyePairBig','RightEye','RightEye'};
CLtarget={'Click on the eye','Click on the eye on the left','Click between the eyes ','Click on the eye on the right','Click on the eye'};
rectSize=[-420 -270 600 600;
          -300 -230 490 490;
          -200 -210 400 450;
          -200 -230 490 490;
          -180 -270 600 600];
      
   for p=1:length(Participants)  %participant 
        pp=Participants{p}; j=J(p); k=K(p)%repetition
        fPanels= figure; 
        fPanels.Position=[ 6         350        1901         244];
        for i=1:5  %angle
            disp(['Participant ' Participants{p} ', Expression ' num2str(j) '/8, Repetition '  num2str(k) '/4, Angle ' num2str(i) '/5'])
            address=[sourceRoot '\' Angles{i}   '\' Espressions{j} '\' Participants{p} '\timed\'  Participants{p} Espressions{j} num2str(k) '.mp4'];
            vid1=VideoReader(address);
            im{i}=read(vid1,1);
            sI=size(im{i});

            % this uses automatic detection or if not asks to click
            imC=im{i}(lim(i,1):lim(i,2),lim(i,3):lim(i,4),:);    
            eval(['axes' num2str(i) '=subplot(1,5,i);']);
            imshow(imC);  
            title(['Camera ' num2str(i)])
            FaceDetect = vision.CascadeObjectDetector('ClassificationModel',target{i},'MergeThreshold',thr(i)); 
            BB{i,j,k} = step(FaceDetect,imC);   % NEEDS LICENCE
    %       BB{i,j,k}=[]; %FOR NO LICENCE

            if isempty(BB{i,j,k})
                h = msgbox({'NO EYE DETECTED', CLtarget{i}},'Icon', 'warn')
                [ccoo]= readPoints(gcf, 1);
                BB{i,j,k}= [ccoo(1)-30 ccoo(2)-20 60 40]; 
                delete(h);
            end

            [~,v]=max(BB{i,j,k}(:,4)); %takes the biggest rectangle
            for kk = v% 1:size(BB{i,j,k},1) %keep the cycle just in case one wants to plot all the detected eyes
                rr=rectangle('Position',[BB{i,j,k}(kk,1) BB{i,j,k}(kk,2) BB{i,j,k}(kk,3:4)],'LineWidth',3,'LineStyle','-  ','EdgeColor','r');
            end

            gravX(i,j,k)= BB{i,j,k}(v,1)+ round(BB{i,j,k}(v,3)/2);
            gravY(i,j,k)= BB{i,j,k}(v,2)+ round(BB{i,j,k}(v,4)/2);

            hold on
            rect.(Participants{p})(i,j,k,:)=[  gravX(i,j,k)+rectSize(i,1) gravY(i,j,k)+rectSize(i,2) +rectSize(i,3)  +rectSize(i,4)  ];
            rectangle('Position',rect.(Participants{p})(i,j,k,:),'LineWidth',3,'LineStyle','-  ','EdgeColor','b');
            imc{i,j,k}=imcrop(im{i},squeeze(rect.(Participants{p})(i,j,k,:))+[lim(i,3); lim(i,1); 0; 0]);
            sC=size(imc{i,j,k});
            propX=sC(2)/sC(1)*501;
            imc{i,j,k}=imresize(imc{i,j,k},[501,propX ]);
            if i==1
                imPrev.(Participants{p}){j,k}=imc{i,j,k};
            else
                imPrev.(Participants{p}){j,k}=cat(2, imPrev.(Participants{p}){j,k}, imc{i,j,k});
            end
        end
        if check
            button = questdlg('Is it correct?','Check eye detection','Yes','No','Yes');
            if strcmp(button,'No')   
                x = inputdlg({'Enter space-separated numbers of wrong detection:'},'Fix', [1 35]);
                data = str2num(x{:}); 
                for i=1:length(data)
                    ii=data(i);
                    axes(eval(['axes' num2str(ii) ';']));
                    d = msgbox(CLtarget{ii})
                    delete(rr);
                    [ccoo]= readPoints(gcf, 1)
                    BB{ii,j,k}=[];
                    BB{ii,j,k}= [ccoo(1)-30 ccoo(2)-20 60 40];
                    v=1;
                    delete(d);
                    gravX(ii,j,k)= BB{ii,j,k}(v,1)+ round(BB{ii,j,k}(v,3)/2);
                    gravY(ii,j,k)= BB{ii,j,k}(v,2)+ round(BB{ii,j,k}(v,4)/2);        
                    hold on
                    %plot(gravX(ii,j,k)+lim(ii,3),gravY(ii,j,k)+lim(ii,1),'rx')
                    rect.(Participants{p})(ii,j,k,:)=[  gravX(ii,j,k)+rectSize(ii,1) gravY(ii,j,k)+rectSize(ii,2) +rectSize(ii,3)  +rectSize(ii,4)  ];
                    rectangle('Position',rect.(Participants{p})(ii,j,k,:),'LineWidth',3,'LineStyle','-  ','EdgeColor','b');
                    imc{ii,j,k}=imcrop(im{ii},squeeze(rect.(Participants{p})(ii,j,k,:))+[lim(ii,3); lim(ii,1); 0; 0]);
                    sC=size(imc{ii,j,k});
                    propX=sC(2)/sC(1)*501;
                    imc{ii,j,k}=imresize(imc{ii,j,k},[501,propX ]);
                end
                for i=1:5
                    if i==1
                        imPrev.(Participants{p}){j,k}=imc{i,j,k};
                    else
                        imPrev.(Participants{p}){j,k}=cat(2, imPrev.(Participants{p}){j,k}, imc{i,j,k});
                    end
               end
            end
        end
        close all
        figure
        imshow(imPrev.(Participants{p}){j,k});    
        save cropping_input.mat rect lim imPrev

        imPrevRem=remove_green(imPrev.(Participants{p}){1,1},0.,5,6,6);

        figure
        imshow(imPrevRem)
        w=1;
        x={'0.0','5','6','6'};
        while w==1
            button = questdlg('Is it correct?','Check green removal','Yes','No','Yes');
            if strcmp(button,'No')          
               prompt = {'Threshold:','Inner edge:','Outer edge:','Sigma:'};
               dlg_title = 'Input';
               num_lines = 1;
               defaultans = {x{1},x{2},x{3},x{4}};
               x = inputdlg(prompt,dlg_title,num_lines,defaultans);           
               imPrevRem=remove_green(imPrev.(Participants{p}){1,1},str2num(x{1}),str2num(x{2}),str2num(x{3}),str2num(x{4}));
               imshow(imPrevRem)
            end
            if strcmp(button,'Yes')  
                w=2;
            end
        end
   end
end