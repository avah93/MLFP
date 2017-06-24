clear;
clc;
addpath('matlabPyrTools\');
im = imread('image\image.jpg');
im = rgb2gray(im);
numberOfLevels = 4;
numberOfBands = 6;
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

for i=1:len
    
end


% showSpyr(pyramid,pind);