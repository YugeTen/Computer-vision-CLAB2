function [data_clusters, cluster_stats] = my_kmeans( data, nc )
% This function performs k-means clustering on data , 
% given (nc) = the number of clusters.
% Random Initialization
data = double(data);
ndata = size(data,1);
ndims = size(data,2);
% randomly distribute the data to 1~nc
random_labels = floor(rand(ndata,1) * nc) + 1; 
data_clusters = random_labels;  
% statistic of each cluster (nc+data)
cluster_stats = zeros(nc,ndims+1);
% distance of each point to its own cluster centre
distances = zeros(ndata,nc);
while(1)
    pause(0.03);
    % Make a copy of cluster statistics for 
    % comparison purposes.  If the difference 
    % is very small, the while loop will exit.
    last_clusters = cluster_stats;
    % For each cluster    
    for c=1:nc
        % Find all data points assigned to this cluster
        [index] = find(data_clusters == c);
        num_assigned = size(index,1); % count index (rows)
        % some heuristic codes for exception handling.
        if( num_assigned < 1 )
            disp('No points were assigned to this cluster, some special processing is given below');
            % assign the data that's the furthest to all the other clusters
            % to the unassigned cluster
            [maxx,cluster_num] = max(max(distances));
            [maxx,data_point] = max(distances(:,cluster_num));
            data_clusters(data_point) = cluster_num;
            index = data_point;
            num_assigned = 1;
        end   %% end of exception handling.  
        
        % Save number of points per cluster,  plus the mean vectors.
        cluster_stats(c,1) = num_assigned;
        if( num_assigned > 1 )
            summ = sum(data(index,:));
            cluster_stats(c,2:ndims+1) = summ ./ num_assigned;
        else % if = 1
            cluster_stats(c,2:ndims+1) = data(index,:);
        end
        
    end
    
    % Exit criteria
    diff = sum(abs(cluster_stats(:) - last_clusters(:)));
    if( diff < 0.00001 )
        break;
    end
    
    % - Assign each point to the nearest cluster center 
    cluster_position = cluster_stats(:,2:end); 
    for i = 1:nc
        a = data-repmat(cluster_position(i,:),ndata,1);
        distances(:,i) = sqrt(sum(a.^2,2));
    end
    
    %%update the membership assignment, i.e., update the data_clusters with current values.   
    for i = 1:ndata
        [x,data_clusters(i)] = find(distances(i,:) == min(distances(i,:)),1);
    
    end
 end 







