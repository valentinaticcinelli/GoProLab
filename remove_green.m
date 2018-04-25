%greenscreen
function rgbImage = remove_green(name,thr,external, internal,sigma,varargin)

col=0;
if nargin>5
col=1;
end

if ischar(name)
    rgbImage=imread(name);
else
    rgbImage=name;
end

redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);


mask = (greenChannel > (1+thr)*redChannel) & (greenChannel > (1+thr)*blueChannel);
se = strel('disk',external,8);
 %se = strel('cube',3);
mask = imdilate(mask,se);
 


%% this filles holes

original=~mask;
filled = imfill(original, 'holes'); %removes holes into face
holes = filled & ~original;
mask =~( original | holes);
% 


mask = bwareaopen(~mask, 50000);
mask=~mask;
%% this smooth edges

%  se = strel('cube',3);
%  mask = imdilate(mask,se);
se = strel('disk',internal,8); %the smaller, more inward the mask is
%   se = strel('cube',10);
mask = imerode(mask,se);
%  se = strel('cube',10);
E = edge(double(mask),'canny');
se = strel('disk',external,8); % the bigger, more outward the mask is
Ed = imdilate(E,se);
%Filtered image
Ifilt  = imgaussfilt(rgbImage,sigma);
%Ifilt = imfilter(rgbImage,fspecial('gaussian'));
rgbImage(E) = Ifilt(E);
mask =( mask | E);

% f=figure;
% f.Position=[   100   352   932   528];
% subplot(2,1,1)




  
%%


for i=1:3   
    rgbImage(:,:,i)=double(rgbImage(:,:,i)).*double(~mask);
end


% subplot(2,1,2)
% imshow(rgbImage+uint8(mask2)*255/2,[]);
% % 
% subplot(2,1,3)
% imshow(rgbImage+uint8(mask)*255,[]);




if col

    rgbImage= rgbImage+uint8(mask)*255*varargin{1};

  %  imshow(rgbImage)
end
