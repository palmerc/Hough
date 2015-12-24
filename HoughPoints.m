function [ Hough, theta_range, rho_range ] = HoughPoints(varargin)
%HOUGHCLP performs the Hough transform in a straightforward way.
%   
    [I, points] = ParseInputs(varargin{:});
    [rows, cols] = size(I);

    [Hough, theta_maximum, theta_range, rho_maximum, rho_range] = HoughMatrix(rows, cols);
    
    for point_index = 1:size(points, 2)
        point = points(:,point_index);
        row = point(1);
        col = point(2);
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

%% ParseInputs - copied out of MatLab
function [I, points] = ParseInputs(varargin)
    narginchk(1,2);

    % Check I
    I = varargin{1};
    validateattributes(I, {'logical', 'numeric'}, {'2d', 'real', 'nonsparse'}, ...
                  mfilename, 'I', 1);

    if nargin > 1
        points = varargin{2};
    else
        [rows, cols] = size(I);
        points = zeros(1, 2, rows * cols);
        index = 1;
        for row = 1:rows
            for col = 1:cols
                points(:,:,index) = [row, col];
                index = index + 1;
            end
        end        
    end
end

