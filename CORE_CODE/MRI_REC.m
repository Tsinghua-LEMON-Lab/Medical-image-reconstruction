function [Results] = MRI_REC(image_MRI)
block_size = size(image_MRI,1);  
overlap = 0;           
step = block_size - overlap; 

image_MRI_ext = zeros(size(image_MRI,1)+overlap,size(image_MRI,2)+overlap);
image_MRI_ext(((overlap/2) + 1):(end-(overlap/2)),((overlap/2) + 1):(end-(overlap/2))) = image_MRI(:,:);
MRI_rec = zeros(size(image_MRI,1)+overlap,size(image_MRI,2)+overlap);
row_step = 1:step:size(image_MRI_ext,1);
colm_step = 1:step:size(image_MRI_ext,2);
Block_rec_cropp = cell(size(row_step,2),size(colm_step,2));

for row_step_index = 1:size(row_step,2)
    for colm_step_index = 1:size(colm_step,2)       
        colm_position = 1+(colm_step_index-1)*step;
        row_position = 1+(row_step_index-1)*step;
        row_low = row_position;
        row_high = row_position+block_size-1;
        if row_high>size(image_MRI_ext,1)
            row_high = size(image_MRI_ext,1);
        end
        clmn_low = colm_position;
        clmn_high = colm_position+block_size-1;
        if clmn_high>size(image_MRI_ext,2)
            clmn_high = size(image_MRI_ext,2);
        end
        image_blck = zeros(block_size); 
        image_blck(1:(row_high-row_low+1),1:(clmn_high-clmn_low+1)) = image_MRI_ext(row_low:row_high,clmn_low:clmn_high);
        image_blck_F = fft2(image_blck);  % First get the simulated raw data from MRI coils
        image_blck_recovered = ifft2(image_blck_F);  % Then, reconstruct MRI images by software ifft2. This process can be implemented on MIR.
        Block_rec_cropp{row_step_index,colm_step_index} = abs(image_blck_recovered);   
    end   
end

for row_step_index = 1:size(row_step,2)
    for colm_step_index = 1:size(colm_step,2)
        colm_position = 1+(colm_step_index-1)*step;
        row_position = 1+(row_step_index-1)*step;
        row_low = row_position;
        row_high = row_position+block_size-1;  
        if row_high>size(image_MRI_ext,1)
            row_high = size(image_MRI_ext,1);
        end
        clmn_low = colm_position;
        clmn_high = colm_position+block_size-1;
        if clmn_high>size(image_MRI_ext,2)
            clmn_high = size(image_MRI_ext,2);
        end
        image_blck_recovered = Block_rec_cropp{row_step_index,colm_step_index};
        MRI_rec((row_low+(overlap/2)):(row_high-(overlap/2)),(clmn_low+(overlap/2)):(clmn_high-(overlap/2))) = image_blck_recovered((1+(overlap/2)):((row_high-row_low+1)-(overlap/2)),(1+(overlap/2)):((clmn_high-clmn_low+1)-(overlap/2)));
    end    
end

MRI_rec_cropped = MRI_rec(((overlap/2) + 1):(end-(overlap/2)),((overlap/2) + 1):(end-(overlap/2)));
Results = MRI_rec_cropped;
end