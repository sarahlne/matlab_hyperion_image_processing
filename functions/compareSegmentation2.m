function  compareSegmentation2(Im_0, X, Y, DW)
% Fetch coordinates limits
    disp(['Enter the values of window s x and y limits ']);
    
    prompt = 'xa : ';
    xa = input(prompt);

    prompt = 'xb : ';
    xb = input(prompt);
    
    prompt = 'ya : ';
    ya = input(prompt);
    
    prompt = 'yb : ';
    yb = input(prompt);
    
    X2 = X(xa:xb,ya:yb);
    Y2 = Y(xa:xb,ya:yb);
    DW2 = DW(xa:xb,ya:yb);
    
    % Display images according limits on figure 3
    figure(3)
    subplot(1,2,1), imshow(Im_0(xa:xb,ya:yb)), axis on, title('DNA marker');
    title('DNA marker and centroids');
    subplot(1,2,2), voronoi(X2(DW2==1),-Y2(DW2==1)), title('Segmentation performed by Voronoi construction');
    %axis square
end