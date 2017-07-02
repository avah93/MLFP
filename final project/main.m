close all;
clear;
clc;

[ hmms , f1c , f2c , f3c , f4c ,maxf1 ,maxf2 ,maxf3 ,maxf4 ] = getHMMS();
image = imread('image.jpg');

f1 = getDCTFeature(image) / maxf1 * 50 + 1;
f2 = getGaborFeatures(image) / maxf2 * 50 + 1;
f3 = getLBPFeature(image) / maxf3 * 50 + 1;
f4 = getCurveletFeature(image) / maxf4 * 50 + 1;

u = getObservationOfFeatures( f1c , f2c , f3c , f4c , f1 ,f2 ,f3 ,f4 );

len = size(hmms ,2);
for i=1:len
    trans = hmms{i}{1};
    obs = hmms{i}{2};
    v = hmmviterbi(u ,trans ,obs);
    getProbabilityOftheStateSeqAdnObsSeq(u ,v ,trans ,obs);
end

% max = 1;




