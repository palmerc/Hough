function [Hough, theta_maximum, theta_range, rho_maximum, rho_range] = HoughMatrix(rows, cols)
%HOUGHMATRIX Creates a matrix suitable for the Hough Transform

theta_maximum = 90;
rho_maximum = floor(sqrt(rows^2 + cols^2)) - 1;
theta_range = -theta_maximum:theta_maximum - 1;
rho_range = -rho_maximum:rho_maximum;

Hough = zeros(length(rho_range), length(theta_range));

end

