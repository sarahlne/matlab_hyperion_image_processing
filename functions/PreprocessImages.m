function filter_im = PreprocessImages(im_tiff,l,k, hsize, sigma, display)
% Applicatino of exponential operator
    filter_im = k./(k+exp(-l*double(im_tiff)));
    
% Application of gaussian filter
    h = fspecial('gaussian',hsize,sigma);
    filter_im = imfilter(filter_im,h,'replicate');
    %filter_im = imfilter(im_tiff,h,'replicate');
    if display==true;
        subplot(1,2,1), imshow(im_tiff), title('Image before preprocessing'); 
        subplot(1,2,2), imshow(filter_im), title('Image after preprocessing');
    end
end