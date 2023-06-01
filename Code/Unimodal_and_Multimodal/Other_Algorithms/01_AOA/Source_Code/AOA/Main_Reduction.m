%% Using PCA to bring Dim to 2Dimension
% Subtract the mean to use PCA
[X_norm, mu, sigma] = featureNormalize(Store_Best_P);

% PCA and project the data to 2D
[U, S] = pca(X_norm);
Z = projectData(X_norm, U, 2);