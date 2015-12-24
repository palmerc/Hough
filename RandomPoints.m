function [ points ] = RandomPoints(I, count)
%RANDOMPOINTS takes a thresholded image and returns count number of points
%   
    points = zeros(2, count);
    [rows, cols] = find(I == 1);
    row_size = size(rows, 1);
    indices = randperm(row_size, count);
    for i = 1:count
        points(:,i) = [rows(indices(i)); cols(indices(i))];
    end
end

