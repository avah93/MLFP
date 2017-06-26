function [ responses ] = getGaborFeatures( image )

addpath('gabor filter\');

image = rgb2gray(image);
image = double(image);
image = imresize(image ,[256 256]);

filterBank = FilterBank();
filterBank.CreateFilterBank();

[~, responses] = filterBank.Convolve(image);

for i=1:length(responses)
    responses{i} = imresize(responses{i} ,[256 256]);
    responses{i} = mean(responses{i});
end

end

