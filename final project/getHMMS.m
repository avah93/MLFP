function [ hmms , f1c , f2c , f3c , f4c ,maxf1 ,maxf2 ,maxf3 ,maxf4 ] = getHMMS(  )

AuthenticDirectory = '..\..\CASIA1\train\AU\';
imageList = dir(AuthenticDirectory);
[numberOfImage, ~] = size(imageList);

ForgedDirectory = '..\..\CASIA1\train\SP';
imageList1 = dir(ForgedDirectory);
[numberOfImage1, ~] = size(imageList1);



numberOfTests = numberOfImage + numberOfImage1 - 4;
f1Size = 2;
f2Size = 4608;
f3Size = 36;
f4Size = 98;

AUF1 = zeros(numberOfTests,f1Size);
AUF2 = zeros(numberOfTests,f2Size);
AUF3 = zeros(numberOfTests,f3Size);
AUF4 = zeros(numberOfTests,f4Size);
class = zeros(numberOfTests ,1);

count = 1;

for i=3:numberOfImage
    
    fprintf('AU processing image number : %d\n' ,i - 2);
    
    %acquiting image
    imageAdress = strcat(AuthenticDirectory,'\' ,imageList(i).name);
    image = imread(imageAdress);
    
    f1 = getDCTFeature(image);
    f2 = getGaborFeatures(image);
    f3 = getLBPFeature(image);
    f4 = getCurveletFeature(image);
    
    AUF1(count,:) = f1;
    AUF2(count,:) = f2;
    AUF3(count,:) = f3;
    AUF4(count,:) = f4;
    class(count,1) = 1;
    count = count + 1;
end



for i=3:numberOfImage1
    
    fprintf('FO processing image number : %d\n' ,i - 2);
    
    %acquiting image
    imageAdress = strcat(ForgedDirectory,'\' ,imageList1(i).name);
    image = imread(imageAdress);
    
    f1 = getDCTFeature(image);
    f2 = getGaborFeatures(image);
    f3 = getLBPFeature(image);
    f4 = getCurveletFeature(image);
    
    AUF1(count,:) = f1;
    AUF2(count,:) = f2;
    AUF3(count,:) = f3;
    AUF4(count,:) = f4;
    count = count + 1;
end

maxf1 = max(AUF1(:));
maxf2 = max(AUF2(:));
maxf3 = max(AUF3(:));
maxf4 = max(AUF4(:));

NAUF1 = AUF1 / maxf1 * 50 + 1;
NAUF2 = AUF2 / maxf2 * 50 + 1;
NAUF3 = AUF3 / maxf3 * 50 + 1;
NAUF4 = AUF4 / maxf4 * 50 + 1;

features = [NAUF1 NAUF2 NAUF3 NAUF4];
[idx,C] = kmeans(features ,4);

[f1idx ,f1c] = kmeans(NAUF1 ,5);
[f2idx ,f2c] = kmeans(NAUF2 ,5);
[f3idx ,f3c] = kmeans(NAUF3 ,5);
[f4idx ,f4c] = kmeans(NAUF4 ,5);

f1cValue = getMatrixValues(f1c);
f2cValue = getMatrixValues(f2c);
f3cValue = getMatrixValues(f3c);
f4cValue = getMatrixValues(f4c);

sumf1 = sum(f1cValue);
sumf2 = sum(f2cValue);
sumf3 = sum(f3cValue);
sumf4 = sum(f4cValue);

obs = getObservationMatrix( f1cValue , f2cValue , f3cValue , f4cValue);
trans = [ 0.25 0.25 0.25 0.25 ; 0 0.34 0.33 0.33;0 0 0.5 0.5; 0 0 0 1];
pi = ones(1, 4) ./ 4;

hmms = cell(1 , count-1);

for i=1:count-1
    seq = getObservationOfFeatures( f1c , f2c , f3c , f4c ,NAUF1(1,:) ,NAUF2(1,:) ,NAUF3(1,:) ,NAUF4(1,:) );
    [trans2, obs2] = hmmtrain(seq, trans, obs);
    h = cell(1,2);
    h{1} = trans2;
    h{2} = obs2;
    hmms{i} = h;
    
end


end

