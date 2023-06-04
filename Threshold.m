function [tray, label] = Threshold(reference_image, image_double, output_figure, name)
    
    % Detect SURF features
    pts_original  = detectSURFFeatures(reference_image);
    pts_distorted = detectSURFFeatures(image_double);
    
    % Extract features from reference and the transformed image
    [features_original,  valid_pts_original]  = extractFeatures(reference_image,  pts_original);
    [features_distorted, valid_pts_distorted] = extractFeatures(image_double, pts_distorted);
    
    % Match the features
    index_pairs = matchFeatures(features_original, features_distorted);
    matched_original  = valid_pts_original(index_pairs(:,1));
    matched_distorted = valid_pts_distorted(index_pairs(:,2));
    
    % Estimate Geometric Transformation
    [transform, inlier_distorted, inlier_original] = estimateGeometricTransform(...
    matched_distorted, matched_original, 'similarity');
    
    % Tranform the distorted image
    output_view = imref2d(size(reference_image));
    image_double  = imwarp(image_double, transform, 'OutputView', output_view);

    % Threshold to isolate tray and label
    tray = imbinarize(image_double, 0.01);
    label = imbinarize(image_double, 0.35);
    
    % Fill in any threshold holes
    tray = imfill(tray, 'holes');
    label = imfill(label, 'holes');

    % Get largest object mask
    tray_mask = bwareafilt(tray, 1);
    label_mask = bwareafilt(label, 1);

    % Get bounding box of tray and label
    tray_props = regionprops(tray_mask, 'BoundingBox');
    label_props = regionprops(label_mask, 'BoundingBox');

    % Crop the tray and label
    tray = imcrop(image_double, tray_props(1).BoundingBox);
    label = imcrop(image_double, label_props(1).BoundingBox);
    
    % Output Figures
    if output_figure == true
        figure('Name', strcat('FEATURE MATCHING', name))
        subplot(2, 1, 1)
        showMatchedFeatures(reference_image, image_double, matched_original, matched_distorted);
        title('PUTATIVELY MATCHED POINTS (INCLUDING OUTLIERS)');
        
        subplot(2, 1, 2)
        showMatchedFeatures(reference_image, image_double, inlier_original, inlier_distorted);
        title('MATCHING POINTS (INLIERS ONLY)');
        legend('POINTS ORIGINAL','POINTS DISTORTED');
            
        figure('Name', name)
        subplot(2, 2, 1)
        imshow(image_double);
        title(strcat(name,' ORIGINAL IMAGE'));
        
        subplot(2, 2, 2)
        imshow(tray_mask);
        title(strcat(name,' BINARY SEGMENTATION'));
        
        subplot(2, 2, 3)
        imshow(tray);
        title(strcat(name,' SEGMENTED TRAY'));
        
        subplot(2, 2, 4)
        imshow(label);
        title(strcat(name, ' SEGMENTED LABEL'));
    end
end