function [region_mask, region_number, region_props] = SLIC(image_double, output_figure, compactness, bit_depth)
    
    [region_mask, region_number] = superpixels(image_double, 500, 'compactness', compactness);

    %? https://uk.mathworks.com/matlabcentral/answers/335200-how-to-access-each-superpixel-individually%
    region_props = regionprops(region_mask,'BoundingBox','centroid','Area','PixelList');

    if output_figure == true
        centroids = round(cat(1, region_props.Centroid));

        centroids_x = centroids(:,1);
        centroids_y = centroids(:,2);
        
        boundary_mask = boundarymask(region_mask);
        
        if bit_depth == 0
            figure('Name','SLIC REGIONS')
            imshow((imoverlay(image_double, boundary_mask,'cyan')), 'InitialMagnification',67);
            for k = 1 : region_number         
                text(centroids_x(k) - 40, centroids_y(k), num2str(k),'color','red');
            end      
            title('SLIC REGIONS')
        else
            image_double = image_double + double(boundary_mask);
            figure('Name','SLIC REGIONS')
            imshow(image_double, [], 'InitialMagnification',67);
            for k = 1 : region_number         
                text(centroids_x(k) - 40, centroids_y(k), num2str(k),'color','red');
            end      
            title('SLIC REGIONS')
        end
    end
end