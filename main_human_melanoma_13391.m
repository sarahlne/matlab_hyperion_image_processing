%%
% This script propose different manipulation on mcd data files from human and murin melanama including:
%     - importation of files by staining markers channels
%     - preprocessing of data (contrast improvement, filtering, maximum intensity detection)
%     - implementation of voronoi segmentation on cell
%     - comparison of voronoi segmentation vs IMC segmentation pipelines outputs

%%
clear all 
close all

% Add function folder to path
addpath('functions', 'data', 'outputs');
%% Exploration of 13391 human melanoma 
%% Import images from foler
%Importation of DNA1&2 tiff images to locate nucleus
DNA1_tiff=imread('data/mcd_human_melanoma/13391/200129_hMel1_slide13391/ROI001_ROI_001/191Ir_DNA1.ome.tiff');
DNA2_tiff=imread('data/mcd_human_melanoma/13391/200129_hMel1_slide13391/ROI001_ROI_001/193Ir_DNA2.ome.tiff');

%Importation of CD31 to locate blood vessels
CD31_tiff=imread('data/mcd_human_melanoma/13391/200129_hMel1_slide13391/ROI001_ROI_001/151Eu_CD31.ome.tiff');

%Importation of CA9 and PDHE1 other markers
PDHE1_tiff=imread('data/mcd_human_melanoma/13391/200129_hMel1_slide13391/ROI001_ROI_001/163Dy_PDHE1.ome.tiff');
CA9_tiff=imread('data/mcd_human_melanoma/13391/200129_hMel1_slide13391/ROI001_ROI_001/147Sm_CA9.ome.tiff');

%% Preprocessing
[l,k] = askUserExpValues; %default l = 1/100, k=1
save_path = 'outputs/mcd_human_melanoma/pre_processing/';
exp_DNA1_tiff = PreprocessImages(DNA1_tiff,l,k, [10 10], 2, true);
saveas(gcf,strcat(save_path, 'exp_DNA1_tiff', '.png'));
exp_DNA2_tiff = PreprocessImages(DNA2_tiff,l,k, [10 10], 2, true);
saveas(gcf,strcat(save_path, 'exp_DNA2_tiff', '.png'));
exp_CD31_tiff = PreprocessImages(CD31_tiff,l,k, [10 10], 2, true);
saveas(gcf,strcat(save_path, 'exp_CD31_tiff', '.png'));
exp_PDHE1_tiff = PreprocessImages(PDHE1_tiff,l,k, [10 10], 2, true);
saveas(gcf,strcat(save_path, 'exp_PDHE1_tiff', '.png'));
exp_CA9_tiff = PreprocessImages(CA9_tiff,l,k, [10 10], 2, true);
saveas(gcf,strcat(save_path, 'exp_CA9_tiff', '.png'));

DNA = exp_DNA1_tiff.*exp_DNA2_tiff;

%% Get centroids of cells thanks with the localisation of regional maxima and plot of figure (1)
[EXBW_Im, BW_Im, DW_Im, X, Y, Im_0] = GetCentroids(DNA, 'outputs/mcd_human_melanoma/centroids/image_w_centroids.png'); %default param = 0.012
nb_centroids = saveLocations(BW_Im, 'outputs/mcd_human_melanoma/centroids/matlab_locations_human_13391.csv');

%% Compare segmentation strategies
IMC_tiff = imread('data/data_from_IMC_pipeline/200129_hMel1_slide13391_s0_a1_ac_ilastik_s2_Probabilities1x.tiff');
IMC_locations = readtable('data/data_from_IMC_pipeline/IMC_location.csv', 'ReadRowNames', true);
IMC_X = IMC_locations(:,'Location_Center_X');
IMC_Y = IMC_locations(:,'Location_Center_Y');

dIMC_X = table2array(IMC_X);
dIMC_Y = table2array(IMC_Y);

%Overlay IMC_tiff input image with locations founded by the IMC pipeline
figure();
h = imshow(IMC_tiff);
axis on
set(h, 'AlphaData', 0.8);
hold on;
plot(dIMC_X, dIMC_Y, 'black+')
% ax = gca;
% ax.Clipping = 'off';
axis([300 350 280 380])
% xlim([300 350])
% ylim([280 380])
%plot([313 339],[373 352], 'r+', 'MarkerSize', 30, 'LineWidth', 2);

% dIMC_X = table2array(IMC_X);
% dIMC_Y = table2array(IMC_Y);

%compareSegmentation2(Im_0,X,Y,DW_Im)
compareSegmentation(Im_0, IMC_tiff,X,Y,DW_Im, dIMC_X, dIMC_Y, 'outputs/mcd_human_melanoma/compare_segmentations/Voronoi_vs_IMC.png')


%% END MAIN