%close all
%clear all
% read color image and convert to 24 bits
img = imread('mandm.png');
% uncomment following if the image is 16 bits:
% img = uint8(img/256);

cform = makecform('srgb2lab');
lab = applycform(img, cform);

% calling the k-mean and display functions
features = im2feature(lab);
[data,stats] = my_kmeans(features,6);
c = displayclusters(lab, data);