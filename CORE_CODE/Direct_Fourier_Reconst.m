function [CT_rec]=Direct_Fourier_Reconst(image_blck)
% First get the simulated CT raw projections
radon_results = RADON_CT(image_blck); 
% Then reconstruct CT images by software
fft_result=fftshift(fft(ifftshift(radon_results,1)),1); 
K_2_R = K_2_radial(fft_result);
CT_rec = CT_rec_2DIDFT(K_2_R);
end

function radon_results = RADON_CT(image_blck)
radon_results=radon(image_blck,(0:1:179.5));
radon_results= [radon_results;zeros(1,size(radon_results,2))];
radon_results=padarray(radon_results,4,0,'both');
end

function K_2_R = K_2_radial(fft_result)
Grid_longside=(-(size(fft_result(:,1),1)-1)/2:(size(fft_result(:,1),1)-1)/2);
Grid_shortside = (0:1:179.5)/180*pi;
[ori_grid_x, ori_grid_y] = meshgrid(Grid_shortside,Grid_longside); % original grid 
[X, Y] = meshgrid(Grid_longside);
[theta,rho] = cart2pol(X,Y); rho=rho.*sign(theta); theta(theta<0)=pi+theta(theta<0); % transformed grid
K_2_R = interp2(ori_grid_x, ori_grid_y, fft_result, theta, rho, 'cubic', 0);
end

function results = CT_rec_2DIDFT(K_2_R)
results = fftshift(ifft(ifft(ifftshift(K_2_R)).').');
results=flipud(abs(results(113:end-114,115:end-112))); 
end
