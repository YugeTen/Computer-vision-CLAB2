close all;
clear all;
im = imread(input('input the image name:'));
bw = rgb2gray(im);  % convert to grey scale image

% Harris Corner detection
sigma = 2; thresh = 2999999; sze = 11; disp = 0;

% derivative masks
dy = [-1 0 1; -1 0 1; -1 0 1]; % derivative mask in y direction
dx = dy'; % derivative mask in x direction

% image derivatives 
Ix = conv2(double(bw), dx, 'same'); % find derivative of x direction using convlution
Iy = conv2(double(bw), dy, 'same'); % find derivative of y direction using convolution

% Calculating the gradiant of the image Ix and Iy
g = fspecial('gaussian', max(1,fix(6^sigma)), sigma); % construct Gaussian filter
Ix2 = conv2(Ix.^2, g, 'same'); %smooth image drivatives with Gaussian filter
Iy2 = conv2(Iy.^2, g, 'same'); 
Ixy = conv2(Ix.*Iy, g, 'same');

% Compute the cornerness
k = 0.04; % range of k: 0.01~0.1
cornerness = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; % R = lambda1*lambda2-k*(lambda1+lambda2)^2
% the equation above gets a similar enough result with the eigen value one,
% it is implemented here to save computation time

% Non-maximum suppression and threshold
mx = ordfilt2(double(cornerness), sze^2, ones(sze));       % Grey-scale dilation
% function ordfilt2:
%        replaces each element in cornerness by the last element of
%        its 11*11 sorted neighbour (ranking from smallest to largest), 
%        which would be 1 as long as there is one pixel in its
%        neighbour is 1. The dilation effect is thus achieved. 
cornerness = (double(cornerness) == mx) & (double(cornerness) > thresh);  % Find local maxima

% self-implemented function plot
[rws, cols] = find(cornerness); % extract the row and column number from cornerness
subplot(1,2,1),imshow(im);
hold on;
p = [cols, rws]; 
plot(p(:,1),p(:,2), 'or'); % plot the corner points on the image
title('\bf Self-implemented Harris Corners Function')

% built-in function plot
coor = corner(bw,'Harris');
subplot(1,2,2),imshow(im);
hold on;
plot(coor(:,1),coor(:,2), 'or');
title('\bf Built-in Harris Corners Function')