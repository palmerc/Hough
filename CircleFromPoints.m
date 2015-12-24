function [xy, R] = CircleFromPoints(points)
%CIRCLEFROMPOINTS Calculate center and radius of a circle given 3 points
% along the circle's edge.
% Using the determinent of the matrix we calculate the circle's center and 
% radius. I found this version while trying to decipher the supplied
% version.
    P = points;
    M = [1 1 1 1; ...
         (P(1, 1).^2 + P(2, 1).^2) P(1, 1) P(2, 1) 1; ...
         (P(1, 2).^2 + P(2, 2).^2) P(1, 2) P(2, 2) 1; ...
         (P(1, 3).^2 + P(2, 3).^2) P(1, 3) P(2, 3) 1];

    M11 = local_minordet(M, 1, 1) ;
    if M11 == 0
        xy = [];
        R = [];
        warning('No solution! Points may be on a straight line.');
    else
        xy(1) = 0.5 * (local_minordet(M, 1, 2) ./ M11);
        xy(2) = -0.5 * (local_minordet(M, 1, 3) ./ M11);
        R = sqrt(xy(1).^2 + xy(2).^2 + (local_minordet(M, 1, 4) ./ M11));
    end
end

function md = local_minordet(M, i, j)
    % minor determinant
    M(i, :) = [];
    M(:, j) = [];
    md = det(M);
end
