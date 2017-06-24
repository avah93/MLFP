clear;
clc;
addpath('matlabPyrTools\');

numberOfLevels = 4;
numberOfBands = 6;
finalDataSize = 4;

im = imread('image\image.jpg');
firstSizes = size(im);
im = rgb2gray(im);



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

for

% len = size(images ,2);
% averageFilter = ones(5,5)/25;
% filteredAndResizedImages = cell(1 ,len);
% 
% for i=1:len
%     image = imfilter(cell(i) ,averageFilter);
%     image = imresize(image, finalDataSize ,finalDataSize);
%     image = imresize(image ,firstSizes);
%     imshow(image ,[]);
% end


% showSpyr(pyramid,pind);