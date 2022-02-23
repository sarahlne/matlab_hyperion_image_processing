function [EXBW_Im, BW_Im, DW_Im, X, Y, Im_0] = GetCentroids(exp_Im, save_path)
% Get extend max intensity parameter
    disp(['Enter the values of the extend max intensity parameter ']);
    prompt = 'param : ';
    param = input(prompt);
    
% Get exend max intensity
    EXBW_Im = imextendedmax(exp_Im, param);
    BW_Im=imregionalmax(EXBW_Im);
    Im_0 = exp_Im;
    Im_0(BW_Im==1)=0;
    n=size(Im_0);
    Y=repmat((1:n(1))',1,n(2));
    X=repmat((1:n(2)),n(1),1);
    
    figure(1);
    imagesc(Im_0);
    %imagesc(DNA) displays the data in array DNA as an image that uses the full range of colors in the colormap. 
    %Each element of C specifies the color for one pixel of the image. The resulting image is an m-by-n grid of 
    %pixels where m is the number of rows and n is the number of columns in C
%     hold on
%     plot(X(BW_Im==1),Y(BW_Im==1),'ro')
%     voronoi(X(BW_Im==1),Y(BW_Im==1))
%     axis square


    % Find connex components and reduces the size of connex component cloud to
    % 1

    CCBW = bwconncomp(BW_Im);
    DW_Im = BW_Im;
    %list_remove = [];
    for n = 1:length(CCBW.PixelIdxList)
        indexes = cell2mat(CCBW.PixelIdxList(n));
        L = length(indexes);
        indexes_to_remove = [];
        if L == 2
            number_indexes_to_drop = 1;
            indexes_to_remove = indexes(randperm(length(indexes),number_indexes_to_drop));
            %disp(indexes_to_remove);
        end

        if L > 2
            %disp(indexes)
            %number_indexes_to_drop = L-fix(L/5);
            number_indexes_to_drop = L-1;
            indexes_to_remove = indexes(randperm(length(indexes),number_indexes_to_drop));
            %disp(indexes_to_remove);
        end
        DW_Im(indexes_to_remove)=0;
        %list_remove(end+length(indexes_to_remove))= indexes_to_remove;   
    end

    Im_0 = exp_Im;
    Im_0(DW_Im==1)=0;
    n=size(Im_0);
    Y=repmat((1:n(1))',1,n(2));
    X=repmat((1:n(2)),n(1),1);
    
    figure(1);
    imagesc(Im_0);
    saveas(gcf, save_path);
end