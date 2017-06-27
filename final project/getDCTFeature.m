function [ featureVector ] = getDCTFeature( image )

image = rgb2gray(image);
B = dct2(image);
mean = mean2(B);
variance = var(B(:));

featureVector = [mean variance];

end

