function [H, theta_maximum, theta_range, rho_maximum, rho_range] = RandomHough(I, line_threshold, maximum_iterations)
%RANDOMHOUGH Uses the randomized version of the Hough transform to find
%lines.
%Algorithm - lines
% 
% 1) Pick a maximum number of iterations to perform, should be at least an
%    order of magnitude less than the value of image rows times columns.
% 2) Pick a 'peak' value that identifies a rho-theta value as a line. Try 
%    different values.
% 3) Establish an empty Hough matrix rho-theta for bookkeeping purposes.
% 
% while iteration < max_iterations:
% 4) From the thresholded input image pick two points randomly.
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

    [image_rows, image_cols] = size(I);
    % Step 3
    [H, theta_maximum, theta_range, rho_maximum, rho_range] = HoughMatrix(image_rows, image_cols);
    H_bookkeeping = H;
    while iteration < maximum_iterations
        points = RandomPoints(I, 2); % Step 4
        H_bookkeeping = H_bookkeeping + HoughPoints(I, points); % Step 5/6
        [candidate_rows, candidate_cols] = find(H_bookkeeping > line_threshold); % Step 7
        for i = 1:size(candidate_rows, 1)
            rho_index = candidate_rows(i);
            theta_index = candidate_cols(i);
            rho = rho_range(rho_index);
            theta = theta_range(theta_index);
            if theta ~= 0
                for x = 1:image_cols
                    y = round((rho - x * cosd(theta)) / sind(theta));
                    if y > 0 && y <= image_rows
                        % Step 8
                        row = y;
                        col = x;
                        H_bookkeeping(rho_index, theta_index) = 0;
                        H(rho_index, theta_index) = H(rho_index, theta_index) + 1;
                        I(row, col) = 0;
                    end
                end
            end
        end

        iteration = iteration + 1; % Step 9
    end
end

