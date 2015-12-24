function [ Hough, theta_range, rho_range ] = naiveHough(I)
%NAIVEHOUGH Peforms the Hough transform in a straightforward way.
%   
    [rows, cols] = size(I);
 
    theta_maximum = 90;
    rho_maximum = floor(sqrt(rows^2 + cols^2)) - 1;
    theta_range = -theta_maximum:theta_maximum - 1;
    rho_range = -rho_maximum:rho_maximum;
 
    Hough = zeros(length(rho_range), length(theta_range));
 
    wb = waitbar(0, 'Naive Hough Transform');
    
    for row = 1:rows
        waitbar(row/rows, wb);
        for col = 1:cols
            if I(row, col) > 0
                x = col - 1;
                y = row - 1;
                for theta = theta_range
                    rho = round((x * cosd(theta)) + (y * sind(theta)));                   
                    rho_index = rho + rho_maximum + 1;
                    theta_index = theta + theta_maximum + 1;
                    Hough(rho_index, theta_index) = Hough(rho_index, theta_index) + 1;
                end
            end
        end
    end
    
    close(wb);
 
end
