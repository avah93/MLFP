function [ featureVector ] = getCurveletFeature( image )

addpath('CurveLab-2.1.2\fdct_wrapping_matlab\');

image = rgb2gray(image);
image = imresize(image ,[256 256]);
x = fdct_wrapping(image,1 ,1 ,3 ,16);

len = 0;

for i=1:size(x,2)
    y = x{i};
    for j=1:size(y,2);
        len = len+1;
    end
end

featureVector = zeros(1, len * 2);

count = 1;
for i=1:size(x,2)
    y = x{i};
    for j=1:size(y,2);
        z = y{j};
        m = mean2(z);
        v = var(z(:));
        
        featureVector(count) = m;
        count = count+1;
        featureVector(count) = v;
        count = count+1;
    end
end
end

