function nb_centroids = saveLocations(BW, save_path)
    nb_centroids = nnz(BW);
    fprintf('%f centroids have been found', nnz(BW));
    [row,col,v]= find(BW);
    locations = [col,row];
    %path = strcat('outputs/mcd_human_melanoma/centroids/matlab_locations_',suffix, '.csv');
    csvwrite(save_path, locations);
end