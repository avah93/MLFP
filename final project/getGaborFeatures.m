function [ featureVector ] = getGaborFeatures( image )

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

featureVector = [1 size(responses,2)*256];
for i=1:length(responses)
    s = 1 +  (i - 1) * 256;
    e = s + 255;
    featureVector(s:e) = responses{i};
end

end

