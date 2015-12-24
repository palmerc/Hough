%% Task 2a - Line case
 
clear 
close all
 
RGB = imread('corridor.png');
gray = rgb2gray(RGB);
 
figure(1);
subplot(211), imshow(RGB), title('Original');
 
h1 = fspecial('sobel');
h2 = h1';
igh = imfilter(gray, h1);
igv = imfilter(gray, h2);
sobel = abs(igh) + abs(igv);
subplot(212), imshow(sobel, []), title('Sobel');
 
sobel_thresholded = sobel > 170;
figure(2);
imshow(sobel_thresholded, []), title('Sobel thresholded');
hold on
 
tic;
[H, theta_max, theta_range, rho_max, rho_range] = RandomHough(sobel_thresholded, 20, 1000);
toc;
 
[rows, cols] = find(H>0);
for i = 1:numel(rows)
    rho = rho_range(rows(i));
    theta = theta_range(cols(i));
    x = 1:size(sobel_thresholded, 2);
    y = round((rho - x * cosd(theta)) / sind(theta));
    plot(x, y, 'r-');
end
 
%% Task 2b - Circle case
 
clear
close all
 
RGB = imread('coins2.jpg');
gray = double(rgb2gray(RGB));
 
figure(1);
subplot(211), imshow(RGB), title('Original');
 
h1 = fspecial('sobel');
h2 = h1';
igh = imfilter(gray, h1);
igv = imfilter(gray, h2);
sobel = abs(igh) + abs(igv);
subplot(212), imshow(sobel, []), title('Sobel');
 
sobel_thresholded = sobel(5:end - 5, 5:end - 5) > 170;
[MI, xy, R] = RandomHoughCircles(sobel_thresholded, 4, 200000, [15 25]);
 
figure(2);
imshow(sobel_thresholded, []), title('Sobel thresholded');
hold on
points = 100;
t = linspace(0, 2 * pi, points);
for i = 1:size(xy, 2)
    x = xy(1, i);
    y = xy(2, i);
    r = R(i);
    x_unit = r * cos(t) + x;
    y_unit = r * sin(t) + y;
    plot(y_unit, x_unit, 'ro');
end
hold off
axis equal
 
figure(3);
imshow(MI, []), title('Erased points');

%% Naive version

%Reading image
img=imread('corridor.png');
img=double(rgb2gray(img));

% Lets filter the original image with a Sobel filter to find the Sobel
% magnitude
h1=fspecial('sobel');
h2=h1';
igh=imfilter(img,h1);
igv=imfilter(img,h2);
igs=abs(igh)+abs(igv);

%Lets treshold the Sobel image
%And lets skip the border
igsT=igs(5:end-5,5:end-5)>170;

I = igsT;

%Using the tresholded Sobel magnitude of the corridor from earlier
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
            for theta_ = theta_range
                rho_ = round((x * cosd(theta_)) + (y * sind(theta_)));
                rho_index = rho_ + rho_maximum + 1;
                theta_index = theta_ + theta_maximum + 1;
                Hough(rho_index, theta_index) = Hough(rho_index, theta_index) + 1;
            end
        end
    end
end

close(wb);
figure(22)
imagesc(theta,rho,H);
title('Matlab Hough');

figure(23)
imagesc(theta_range,rho_range,Hough)
title('Naive Hough: Cameron Palmer');