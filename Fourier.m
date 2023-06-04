function [fourier, fourier_shift] = Fourier(region, output_figure) 

    fourier = fft2(region, size(region,1), size(region, 2)); 

    fourier_shift = fftshift(fourier); % Center FFT
    
    min(min(abs(fourier_shift)))
    max(max(abs(fourier_shift)))
    maximum = log(1+abs(fourier_shift));

    % Circle x and y centre
    centre_x = round(size(fourier_shift, 1)/2);
    centre_y = round(size(fourier_shift, 2)/2);
    
    % Radius of small and large circle
    radius = round(mean(size(fourier_shift, 1), size(fourier_shift, 2))/8);
    radius_large = round(mean(size(fourier_shift, 1), size(fourier_shift, 2))/4);
    [width, height] = meshgrid(1:size(fourier_shift, 2), 1:size(fourier_shift, 1)); 
    
    % Make circular objects
    mask_small = sqrt((width - centre_x).^2 +(height - centre_y).^2)<= radius; 
    mask_large = sqrt((width - centre_x).^2 +(height - centre_y).^2)<= radius_large; 

    circled_small = maximum.*mask_small;
    circled_large = maximum.*mask_large;

    average_intensity_circle = [sum(circled_small)/sum(mask_small), sum(circled_large)/sum(mask_large)];
    
    if output_figure == true    
        
        figure('Name','FOURIER')
        subplot(2, 2, 1)
        imshow(fourier_shift);
        title('FOURIER SHIFT')

        subplot(2, 2, 2)
        imshow(abs(fourier_shift),[0 100]); colormap(jet); colorbar
        title('MIN')

        subplot(2, 2, 3)
        imshow(log(1+abs(fourier_shift)),[0,3]); colormap(jet); colorbar 
        title('MAX')

        % Look at the phases
        subplot(2, 2, 4)
        imshow(angle(fourier_shift),[-pi,pi]); colormap(jet); colorbar
        title('PHASES')

        M = size(fourier_shift, 1);
        N = size(fourier_shift, 2);

        triangle = struct;
        triangle.a = maximum.*poly2mask([0, 0, M/2], [N/4, N/2, N/2], M, N);
        triangle.b = maximum.*poly2mask([0, 0, M/2], [0, N/4, N/2], M, N);
        triangle.c = maximum.*poly2mask([0, M/4, M/2], [0, 0, N/2], M, N);
        triangle.d = maximum.*poly2mask([M/2, M/4, M/2], [0, 0, N/2], M, N);
        triangle.e = maximum.*poly2mask([M/2, 0.75*M, M/2], [0, 0, N/2], M, N);
        triangle.f = maximum.*poly2mask([0.75*M, M, M/2], [0, 0, N/2], M, N);
        triangle.g = maximum.*poly2mask([M, M, M/2], [0, N/4, N/2], M, N);
        triangle.h = maximum.*poly2mask([M, M, M/2], [N/4, N/2, N/2], M, N);

        average_intensity = [ sum(triangle.a)/sum(poly2mask([0, 0, M/2], [N/4, N/2, N/2], M, N)), 
                                sum(triangle.b)/sum(poly2mask([0, 0, M/2], [0, N/4, N/2], M, N)),
                                sum(triangle.c)/sum(poly2mask([0, M/4, M/2], [0, 0, N/2], M, N)),
                                sum(triangle.d)/sum(poly2mask([M/2, M/4, M/2], [0, 0, N/2], M, N)),
                                sum(triangle.e)/sum(poly2mask([M/2, 0.75*M, M/2], [0, 0, N/2], M, N)),
                                sum(triangle.f)/sum(poly2mask([0.75*M, M, M/2], [0, 0, N/2], M, N)),
                                sum(triangle.g)/sum(poly2mask([M, M, M/2], [0, N/4, N/2], M, N)),
                                sum(triangle.h)/sum(poly2mask([M, M, M/2], [N/4, N/2, N/2], M, N))];
        
        
        

        figure('Name','FOURIER DIRECTIONS')
        subplot(2, 5, 1)
        imshow(circled_small, [0,3]); colormap(jet); colorbar
        title('CIRCLE SMALL')
        tx = text(centre_x, centre_y + 100, num2str(average_intensity_circle(1)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';
        
        subplot(2, 5, 2)
        imshow(triangle.a, [0,3]); colormap(jet); colorbar
        title('ANGLE 1')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(1)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';

        subplot(2, 5, 3)
        imshow(triangle.b, [0,3]); colormap(jet); colorbar
        title('ANGLE 2')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(2)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';

        subplot(2, 5, 4)
        imshow(triangle.c, [0,3]); colormap(jet); colorbar
        title('ANGLE 3')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(3)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';

        subplot(2, 5, 5)
        imshow(triangle.d, [0,3]); colormap(jet); colorbar
        title('ANGLE 4')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(4)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';

        subplot(2, 5, 6)
        imshow(circled_large, [0,3]); colormap(jet); colorbar
        title('CIRCLE LARGE') 
        tx = text(centre_x, centre_y + 100, num2str(average_intensity_circle(2)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';
        
        subplot(2, 5, 7)
        imshow(triangle.e, [0,3]); colormap(jet); colorbar
        title('ANGLE 5')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(5)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';

        subplot(2, 5, 8)
        imshow(triangle.f, [0,3]); colormap(jet); colorbar
        title('ANGLE 6')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(6)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';

        subplot(2, 5, 9)
        imshow(triangle.g, [0,3]); colormap(jet); colorbar
        title('ANGLE 7')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(7)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';

        subplot(2, 5, 10)
        imshow(triangle.h, [0,3]); colormap(jet); colorbar
        title('ANGLE 8')
        tx = text(centre_x, centre_y + 40, num2str(average_intensity(8)));
        tx.HorizontalAlignment = 'center';
        tx.VerticalAlignment = 'bottom';
        tx.Color = 'cyan';       
    end
end