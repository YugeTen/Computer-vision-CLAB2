function cluster_img = displayclusters( img, clusters )

% Just take size information and then make 
% a new display image.
[rows, cols, ncolors] = size(img);

% Reshape cluster information into image
cluster_img = reshape( clusters, [rows cols] );

% Find boundaries
boundary_img_x = filter2( [-1 1], cluster_img, 'same' );
boundary_img_y = filter2( [-1 1]', cluster_img, 'same' );
boundary_img = (abs(boundary_img_x) + abs(boundary_img_y)) > 0;

figure(1);
subplot(1,2,1);
imagesc(cluster_img); axis image; title('cluster image (nc = 6)');
subplot(1,2,2);
imagesc(uint8(img)); axis image; title('cluster image in uint8 (nc = 6)');

drawnow;
figure(gcf);

figure(17);
imagesc(boundary_img); axis image; colormap(gray);
title('boundary image (nc = 6)')

%pause;
