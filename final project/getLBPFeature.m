function [ featureVector ] = getLBPFeature( image )

addpath('lbp\');
image = rgb2gray(image);
mapping = GETMAPPING(8,'ri');
featureVector=LBP(image,5,8,mapping,'nh');

end

