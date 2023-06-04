function [stats] = CalculateStats(image_mask, image_double, region_props, region_number)

    stats = struct();    
    stats.autoc = zeros(1,region_number); % Autocorrelation: [2] 
    stats.contr = zeros(1,region_number); % Contrast: matlab/[1,2]
    stats.corrm = zeros(1,region_number); % Correlation: matlab
    stats.cprom = zeros(1,region_number); % Cluster Prominence: [2]
    stats.cshad = zeros(1,region_number); % Cluster Shade: [2]
    stats.dissi = zeros(1,region_number); % Dissimilarity: [2]
    stats.energ = zeros(1,region_number); % Energy: matlab / [1,2]
    stats.entro = zeros(1,region_number); % Entropy: [2]
    stats.homom = zeros(1,region_number); % Homogeneity: matlab
    stats.maxpr = zeros(1,region_number); % Maximum probability: [2]
    stats.sosvh = zeros(1,region_number); % Sum of sqaures: Variance [1]
    stats.savgh = zeros(1,region_number); % Sum average [1]
    stats.svarh = zeros(1,region_number); % Sum variance [1]
    stats.senth = zeros(1,region_number); % Sum entropy [1]
    stats.dvarh = zeros(1,region_number); % Difference variance [4]
    stats.denth = zeros(1,region_number); % Difference entropy [1]
    stats.inf1h = zeros(1,region_number); % Information measure of correlation1 [1]
    stats.inf2h = zeros(1,region_number); % Informaiton measure of correlation2 [1]
    stats.indnc = zeros(1,region_number); % Inverse difference normalized (INN) [3]
    stats.idmnc = zeros(1,region_number); % Inverse difference moment normalized [3]

    %lOOP EXTRACTION AND GLCM CALCULATION%
    for k = 1 : region_number
        bounding_box = region_props(k).BoundingBox;
        sub_image = imcrop(image_double, bounding_box);
        sub_image_pixels = image_mask == k;
        subImageMask = imcrop(sub_image_pixels, bounding_box);
        sub_image = subImageMask.*sub_image;
%         sub_image(sub_image == 0) = NaN;
        %GLCM%
        GLCM = graycomatrix(sub_image,'Offset',[2 0;0 2],'Symmetric',true);
        stats(k) = GLCMFeaturesVectorised(GLCM,1);
    end
end