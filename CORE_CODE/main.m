close all; clc; clear
CT_MRI = 1; % 1: CT reconstruction; 0: MRI reconstruction

if CT_MRI
    load('CT_image_data_1.mat');
    load('CT_image_data_2.mat');
    load('CT_image_data_3.mat');
    image(:,:,1:68) = image_1;
    image(:,:,69:110) = image_2;
    image(:,:,111:168) = image_3;
else
    load('MRI_image_data.mat');   
end

z_size = size(image,3);
Results = zeros(size(image));
minimum_image = double(min(min(min(image))));

for z_index = 1:z_size  % parfor can be used to accelerate the calculation process
    if CT_MRI
        % CT reconstruction, taking about 1 minute with Intel Core i7-10700
        Results(:,:,z_index) = CT_REC(image(:,:,z_index)-minimum_image)+minimum_image;
    else
        % MRI reconstruction, taking about 5 seconds with Intel Core i7-10700
        image(:,:,z_index) = fliplr(rot90(image(:,:,z_index)));
        Results(:,:,z_index) = MRI_REC(image(:,:,z_index)-minimum_image)+minimum_image;
    end
end

% plot figure
subplot(1,2,2)
imshow(Results(:,:,20),[])
title('Software reconstructed image');
set(gca,'FontName','Times New Roman','FontSize',16);
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')

subplot(1,2,1)
imshow(image(:,:,20),[])
title('Ideal image');

set(gca,'layer','bottom'); 
set(gcf,'color','w'); 
set(gca,'FontName','Times New Roman','FontSize',16);
set(gcf,'position',[100 100 700 400]);
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')