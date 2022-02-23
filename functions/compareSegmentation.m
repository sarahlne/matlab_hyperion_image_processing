function  compareSegmentation(Im_0, IMC_tiff, X, Y, DW, dIMC_X, dIMC_Y, save_path)
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
    subplot(1,3,1)
    h = imshow(IMC_tiff);
    axis on
    set(h, 'AlphaData', 0.8)
    hold on;
    plot(dIMC_X, dIMC_Y, 'black+');
    xlim([ya yb])
    ylim([xa xb])
    title('Segmentation performed by IMCSegmentation Pipeline');
    hold off
    subplot(1,3,2), imshow(Im_0(xa:xb,ya:yb)), axis on, title('DNA marker from matlab processing');
%     subplot(1,3,2)
%     h = imshow(IMC_tiff);
%     axis on
%     set(h, 'AlphaData', 0.8)
%     hold on;
%     plot(dIMC_X, dIMC_Y, 'black+');
%     xlim([ya yb])
%     ylim([xa xb])
%     title('Segmentation performed by IMCSegmentation Pipeline');
    subplot(1,3,3), voronoi(X2(DW2==1),-Y2(DW2==1)), title('Segmentation performed by Voronoi construction');
    axis square
    saveas(gcf, save_path);
end