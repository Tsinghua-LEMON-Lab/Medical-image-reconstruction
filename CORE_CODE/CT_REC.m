function [Results] = CT_REC(CT_image)

block_size = size(CT_image,1);            
overlap = 0;     
step = block_size - overlap;  

CT_image_ext = zeros(size(CT_image,1)+overlap,size(CT_image,2)+overlap);
CT_image_ext(((overlap/2) + 1):(end-(overlap/2)),((overlap/2) + 1):(end-(overlap/2))) = CT_image(:,:);
CT_image_rec = zeros(size(CT_image,1)+overlap,size(CT_image,2)+overlap);
row_step = 1:step:size(CT_image_ext,1);
colm_step = 1:step:size(CT_image_ext,2);
Block_rec_cropp = cell(size(row_step,2),size(colm_step,2));

for row_step_index = 1:size(row_step,2)
    for colm_step_index = 1:size(colm_step,2)        
        colm_position = 1+(colm_step_index-1)*step;
        row_position = 1+(row_step_index-1)*step;
        row_low = row_position;
        row_high = row_position+block_size-1;
        if row_high>size(CT_image_ext,1)
            row_high = size(CT_image_ext,1);
        end        
        clmn_low = colm_position;
        clmn_high = colm_position+block_size-1;
        if clmn_high>size(CT_image_ext,2)
            clmn_high = size(CT_image_ext,2);
        end        
        image_blck = zeros(block_size);
        image_blck(1:(row_high-row_low+1),1:(clmn_high-clmn_low+1)) = CT_image_ext(row_low:row_high,clmn_low:clmn_high);        
        [image_blck_recovered] = Direct_Fourier_Reconst(image_blck);
        Block_rec_cropp{row_step_index,colm_step_index} = image_blck_recovered; 
    end   
end

for row_step_index = 1:size(row_step,2)
    for colm_step_index = 1:size(colm_step,2)
        colm_position = 1+(colm_step_index-1)*step;
        row_position = 1+(row_step_index-1)*step;
        row_low = row_position;
        row_high = row_position+block_size-1;       
        if row_high>size(CT_image_ext,1)
            row_high = size(CT_image_ext,1);
        end        
        clmn_low = colm_position;
        clmn_high = colm_position+block_size-1;        
        if clmn_high>size(CT_image_ext,2)
            clmn_high = size(CT_image_ext,2);
        end
        image_blck_recovered = Block_rec_cropp{row_step_index,colm_step_index};
        CT_image_rec((row_low+(overlap/2)):(row_high-(overlap/2)),(clmn_low+(overlap/2)):(clmn_high-(overlap/2))) = image_blck_recovered((1+(overlap/2)):((row_high-row_low+1)-(overlap/2)),(1+(overlap/2)):((clmn_high-clmn_low+1)-(overlap/2)));
    end    
end

CT_image_rec_cropped = CT_image_rec(((overlap/2) + 1):(end-(overlap/2)),((overlap/2) + 1):(end-(overlap/2)));
Results = CT_image_rec_cropped;
end



