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
%% Exploration of 21-IMC-M-05-LLC_d100-Takis murin melanoma
%% Import images from foler
%Importation of DNA1&2 tiff images to locate nucleus
DNA1_tiff=imread('data/mcd_murin_melanoma/21-IMC-M-05-LLC_d100-Takis/ROI001_Panel-100_Takis-1/191Ir_DNA1.ome.tiff');
DNA2_tiff=imread('data/mcd_murin_melanoma/21-IMC-M-05-LLC_d100-Takis/ROI001_Panel-100_Takis-1/193Ir_DNA2.ome.tiff');

%Importation of CD31 to locate blood vessels
CD31_tiff=imread('data/mcd_murin_melanoma/21-IMC-M-05-LLC_d100-Takis/ROI001_Panel-100_Takis-1/151Eu_CD31.ome.tiff');

%Importation of CA9 and PDHE1 other markers
PDHE1_tiff=imread('data/mcd_murin_melanoma/21-IMC-M-05-LLC_d100-Takis/ROI001_Panel-100_Takis-1/163Dy_PDHE1.ome.tiff');
CA9_tiff=imread('data/mcd_murin_melanoma/21-IMC-M-05-LLC_d100-Takis/ROI001_Panel-100_Takis-1/147Sm_CA9.ome.tiff');
MLANA_tiff = imread('data/mcd_murin_melanoma/21-IMC-M-05-LLC_d100-Takis/ROI001_Panel-100_Takis-1/149Sm_MLANA.ome.tiff');

%% Preprocessing
[l,k] = askUserExpValues;
save_path = 'outputs/mcd_murin_melanoma/pre_processing/';
exp_DNA1_tiff = PreprocessImages2(DNA1_tiff,l,k, [5 5], 2, true);
saveas(gcf,strcat(save_path, 'exp_DNA1_tiff', '.png'));
exp_DNA2_tiff = PreprocessImages2(DNA2_tiff,l,k, [5 5], 2, true);
saveas(gcf,strcat(save_path, 'exp_DNA2_tiff', '.png'));
exp_CD31_tiff = PreprocessImages2(CD31_tiff,l,k, [5 5], 2, true);
saveas(gcf,strcat(save_path, 'exp_CD31_tiff', '.png'));
exp_PDHE1_tiff = PreprocessImages2(PDHE1_tiff,l,k, [5 5], 2, true);
saveas(gcf,strcat(save_path, 'exp_PDHE1_tiff', '.png'));
exp_CA9_tiff = PreprocessImages2(CA9_tiff,l,k, [5 5], 2, true);
saveas(gcf,strcat(save_path, 'exp_CA9_tiff', '.png'));
exp_mlana_tiff = PreprocessImages2(MLANA_tiff,l,k, [5 5], 2, true);
saveas(gcf,strcat(save_path, 'exp_MLANA_tiff', '.png'));

DNA = exp_DNA1_tiff;

%% Get centroids of cells thanks with the localisation of regional maxima and plot of figure (1)
[EXBW_Im, BW_Im, DW_Im, X, Y, Im_0] = GetCentroids(DNA, 'outputs/mcd_murin_melanoma/centroids/image_w_centroids.png');
nb_centroids = saveLocations(BW_Im,'outputs/mcd_murin_melanoma/centroids/matlab_locations_takis_d100.csv');

%% Compare segmentation strategies
IMC_tiff = imread('data/data_from_IMC_pipeline/21-IMC-M-05-LLC_d100-Takis_s0_a1_ac_ilastik_s2_Probabilities.tiff');
IMC_locations = readtable('data/data_from_IMC_pipeline/IMC_location_takis_100.csv', 'ReadRowNames', true);
IMC_X = IMC_locations(:,'Location_Center_X');
IMC_Y = IMC_locations(:,'Location_Center_Y');
% 
dIMC_X = table2array(IMC_X);
dIMC_Y = table2array(IMC_Y);
% 
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

dIMC_X = table2array(IMC_X);
dIMC_Y = table2array(IMC_Y);

compareSegmentation(Im_0, IMC_tiff,X,Y,DW_Im, dIMC_X, dIMC_Y, 'outputs/mcd_murin_melanoma/compare_segmentations/Voronoi_vs_IMC.png')
%compareSegmentation2(Im_0,X,Y,DW_Im)



% %%
% figure(1)
% DNA(BW==1)=0;
% n=size(DNA);
% Y=repmat((1:n(1))',1,n(2));
% X=repmat((1:n(2)),n(1),1);
% imagesc(DNA)
% %imagesc(DNA) displays the data in array DNA as an image that uses the full range of colors in the colormap. 
% %Each element of C specifies the color for one pixel of the image. The resulting image is an m-by-n grid of 
% %pixels where m is the number of rows and n is the number of columns in C
% hold on
% plot(X(BW_Im==1),Y(BW_Im==1),'ro')
% voronoi(X(BW_Im==1),Y(BW_Im==1))
% axis square
