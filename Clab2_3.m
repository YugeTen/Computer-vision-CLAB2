close all;
clear all;

%% read, modify and write the image
img1 = imresize(rgb2gray(imread('2.jpg')), [512 512]);
img2 = imrotate(imresize(img1,0.5),90);
img3 = imrotate(imresize(img1,1.2),3);
img4 = imrotate(imresize(img1,0.9),45);

imwrite(img1,'img1.png');
imwrite(img2,'img2.png');
imwrite(img3,'img3.png');
imwrite(img4,'img4.png');

%% implement sift and show keypoints
[img_1,descriptors1,locs1] = sift('img1.png');
[img_2,descriptors2,locs2] = sift('img2.png');
[img_3,descriptors3,locs3] = sift('img3.png');
[img_4,descriptors4,locs4] = sift('img4.png');

showkeys(img_1,locs1);
showkeys(img_2,locs2);
showkeys(img_3,locs3);
showkeys(img_4,locs4);

%% matching keypoints 
% except for the self-implemented function, built-in function matchFeatures
% can readily be used with the descriptors as input
min_position = [];  
for i = 1:size(descriptors1,1)
    descriptor1_row = repmat(descriptors1(i,:),size(descriptors2,1),1); %map one row of descriptor1 to the size of descriptor2
    % calculate the distance using matrix operation
    difference = descriptor1_row - descriptors2; 
    distances = sqrt(sum(difference.^2,2));
    min_distance = min(distances); %find minimum distance
    % find second smallest distance
    distances1 = distances;
    distances1(distances1 == min_distance) = 10;
    min2_distance = min(distances1);
    % when minimum distance smaller than k of the second minimum,
    % the two keypoints match. k lies in 0.6~0.8.
    if min_distance <= 0.6*min2_distance 
        % store the keypoint position of minimum distance (in descriptor)
        min_position = [min_position; [i, find(distances == min_distance,1)]];
    end   
end
% find the location of keypoint
matchpoints1 = locs1(min_position(1:10,1),1:2);
matchpoints2 = locs2(min_position(1:10,2),1:2);
% plot & connecting matching keypoints
figure; showMatchedFeatures(img1, img2,matchpoints1, matchpoints2, 'montage', 'parent', axes);

% the code below are pretty much the same with the above chunk, just with
% different images.
min_position = [];  
for i = 1:size(descriptors1,1)
    descriptor1_row = repmat(descriptors1(i,:),size(descriptors3,1),1);
    difference = descriptor1_row - descriptors3;
    distances = sqrt(sum(difference.^2,2));
    min_distance = min(distances);
    distances1 = distances;
    distances1(distances1 == min_distance) = 10;
    min2_distance = min(distances1);
    if min_distance <= 0.6*min2_distance
       min_position = [min_position; [i, find(distances == min_distance,1)]];
    end   
end
matchpoints1 = locs1(min_position(1:10,1),1:2);
matchpoints2 = locs3(min_position(1:10,2),1:2);
figure; showMatchedFeatures(img1, img3,matchpoints1, matchpoints2, 'montage', 'parent', axes);

min_position = [];  
for i = 1:size(descriptors1,1)
    descriptor1_row = repmat(descriptors1(i,:),size(descriptors4,1),1);
    difference = descriptor1_row - descriptors4;
    distances = sqrt(sum(difference.^2,2));
    min_distance = min(distances);
    distances1 = distances;
    distances1(distances1 == min_distance) = 10;
    min2_distance = min(distances1);
    if min_distance <= 0.6*min2_distance
       min_position = [min_position; [i, find(distances == min_distance,1)]];
    end   
end
matchpoints1 = locs1(min_position(1:10,1),1:2);
matchpoints2 = locs4(min_position(1:10,2),1:2);
figure; showMatchedFeatures(img1, img4,matchpoints1, matchpoints2, 'montage', 'parent', axes);

    
    
    

    