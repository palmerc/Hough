function [I, centers, radii] = RandomHoughCircles(I, circle_threshold, maximum_iterations, radius_range)
%RANDOMHOUGHCIRCLES Uses the randomized version of the Hough transform to 
% find circles.
% Algorithm - circles
% 
% 1) Pick a maximum number of iterations to perform, should be at least an
%    order of magnitude less than the value of image rows times columns.
% 2) Pick a 'peak' value that identifies a rho-theta value as a line. Try 
%    different values.
% 3) Establish an empty Hough matrix rho-theta for bookkeeping purposes.
% 
% while iteration < max_iterations:
% 4) From the thresholded input image pick three points randomly.
% 5) Perform the Hough transform on those two points - scoring the 
%    rho/theta values like normal.
% 6) Add the rho-theta values to your bookkeeping matrix.
% 7) If a rho-theta value is greater than or equal to your ?peak? value we 
%    found a line, otherwise loop.
% 8) Take the line and black-out the values in the thresholded image so you
%    don?t revisit them. Zero out the rho-theta value in your bookkeeping 
%    matrix too. Add the line rho-theta to a set of lines to return.
% 9) Loop until you reach max_iterations or the thresholded image is all 
%    black. Return your list of discovered lines.
    iteration = 0;
    centers_count = 1;
    centers = [];
    radii = [];
    
    min_radius = radius_range(1);
    max_radius = radius_range(2);
    [image_rows, image_cols] = size(I);
    % Step 3
    H_Bookkeeping = zeros(image_rows, image_cols, max_radius);
    while iteration < maximum_iterations && sum(I(:)) > 0
        points = RandomPoints(I, 3); % Step 4
        [xy, R] = CircleFromThreePoints(points);
        if numel(xy) > 0 && numel(R) > 0
            x = round(xy(1));
            y = round(xy(2));
            radius = ceil(R);
            row = y;
            col = x;
            if radius >= min_radius && radius <= max_radius && ...
               (col - radius) >= 1 && (col + radius) <= image_cols && ...
               (row - radius) >= 1 && (row + radius) <= image_rows
                H_Bookkeeping(row, col, radius) = H_Bookkeeping(row, col, radius) + 1;
                if H_Bookkeeping(row, col, radius) >= circle_threshold
                    mask = bsxfun(@plus, ((1:image_cols) - y).^2, (transpose(1:image_rows) - x).^2) > radius^2;
                    I = I .* mask;
                    I(points(1,:), points(2,:)) = 0;
                    H_Bookkeeping(row, col, radius) = 0;
                    centers(:, centers_count) = [x; y]; %#ok<AGROW>
                    radii(centers_count) = radius; %#ok<AGROW>
                    centers_count = centers_count + 1;
                    fprintf('(%d, %d) - %d\n', x, y, radius);
                end
            end
        end
        
        iteration = iteration + 1; % Step 9
    end
end

