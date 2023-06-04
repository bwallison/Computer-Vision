clear all

% If outputting plots
output_figure = true;

% Read in data
img_rgb = imread('.\Data\ImgPIA.jpeg');
img_pia = rgb2gray(img_rgb);
x = csvread('.\Data\x.csv');
y = csvread('.\Data\y.csv');
a = csvread('.\Data\a.csv');
b = csvread('.\Data\b.csv');
top_image = imread('.\Data\TopImg0000.bmp');
top_image_skew = imread('.\Data\TopImg0013.bmp');

% Reference image for feature matching
reference_image = top_image;

% Threshold and matching for TopImg0000
[top_image_tray, top_image_label] = Threshold(reference_image, top_image, output_figure, 'TopImg0000.bmp');

% Threshold and matching for TopImg0013
[top_image__skew_tray, top_image_skew_label] = Threshold(reference_image, top_image_skew, output_figure, 'TopImg0013.bmp');

% Show ImgPIA
figure
imshow(img_pia);

% Select rectangle on image
region = getrect;

% Extract rectangle region
region = imcrop(img_pia, region);
imshow(region);

% Perform Fourier on region
[fourier, fourier_shift] = Fourier(region, output_figure);

% Plot Image Histogram
figure('Name','IMG PIA HISTOGRAM')
histogram(img_pia, 255)
title('IMG PIA HISTOGRAM')

% Convert Image to 8, 6, and 4bit images
img_8bit = double(rgb2ind(img_rgb, 8));
img_6bit = double(rgb2ind(img_rgb, 6));
img_4bit = double(rgb2ind(img_rgb, 4));
img_pia = im2double(img_pia);

% Show 8-bit image
figure('Name','IMG PIA 8-BIT')
imshow(img_8bit, []);
title('IMG PIA 8-BIT')

% Calculate First Order Features
mean = mean(img_pia(:));
variance = var(img_pia(:));
skewness = skewness(img_pia(:));
kurtosis = kurtosis(img_pia(:));

% Perform SLIC super pixel segmentation on ImgPIA
[regions, region_number, region_props] = SLIC(img_pia, output_figure, 20, 0); 
[regions_8bit, region_number_8bit, region_props_8bit] = SLIC(img_8bit, output_figure, 2, 1); 
[regions_6bit, region_number_6bit, region_props_6bit] = SLIC(img_6bit, 'false', 2, 1); 
[regions_4bit, region_number_4bit, region_props_4bit] = SLIC(img_4bit, 'false', 2, 1); 

% Perform GLCM Haralick feature calculation for ImgPIA segmented by SLIC
breast_stats = CalculateStats(regions, img_pia, region_props, region_number);
breast_stats_8bit = CalculateStats(regions, img_8bit, region_props_8bit, region_number_8bit);
breast_stats_6bit = CalculateStats(regions, img_6bit, region_props_6bit, region_number_6bit);
breast_stats_4bit = CalculateStats(regions, img_4bit, region_props_4bit, region_number_4bit);

% Plot x and y against a and b
figure('Name', 'OBJECT TRACKING')
subplot(2, 1, 1)
plot(x, y, 'xb');
hold;
plot(a, b, '+r');
title('X AND Y AGAINST A AND B')

z = [a; b];
% Perform Kalman tracking on a and b, the noisy version
[px, py] = KalmanTracking(z);

% Plot x and y against px and py, the predicted points
subplot(2, 1, 2)
plot(x, y, 'xb');
hold;
plot(px, py, '+r');
title('X AND Y AGAINST PX AND PY')

% Calculate the error of the tracking
estimated_error = sqrt(((x-px).^2)+((y-py).^2));
estimated_mean_error = sum(estimated_error)/size(estimated_error,2);
estimated_standard_deviation_error = std(estimated_error);

noisy_error = sqrt(((x-a).^2)+((y-b).^2));
noisy_mean_error = sum(noisy_error)/size(noisy_error,2);
noisy_standard_deviation_error = std(noisy_error);

% Calculate the Root mean squared error of the tracking
estimated_N = size(estimated_error, 2);
estimated_rms = sqrt(sum(estimated_error.^2)/estimated_N);

noisy_N = size(noisy_error, 2);
noisy_rms = sqrt(sum(noisy_error.^2)/noisy_N);









