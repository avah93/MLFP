function [ FeatureVector ] = GetImageFeatureVector( inputImage )

addpath('matlabPyrTools\');

numberOfLevels = 4;
numberOfBands = 6;
finalDataSize = [4 ,4];

% im = imread('image\image.jpg');
im = rgb2gray(inputImage);
% firstSizes = size(im);

[pyramid,pind] = buildSpyr(im,numberOfLevels,'sp5Filters');

images = cell(1,numberOfLevels * numberOfBands);

index = 1;
for i=1:numberOfLevels
    for j=1:numberOfBands
        band = spyrBand( pyramid , pind , i , j );
        images{index} = band;
        index = index + 1;
    end
end

len = size(images ,2);
averageFilter = ones(3,3)/9;

reformedImages = [finalDataSize(1) len*finalDataSize(2)];

for i=1:len
    image = imfilter(images{i} ,averageFilter);
    image = imresize(image, finalDataSize);
    
    index = (i - 1) * finalDataSize(2) + 1;
    reformedImages(1:finalDataSize(1) , index:(index + finalDataSize(2) - 1)) = image;
end

vSize = size(reformedImages,1) * size(reformedImages,2);
FeatureVector  = reshape(reformedImages,vSize ,1);
end