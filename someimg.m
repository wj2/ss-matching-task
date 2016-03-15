function [ img, imgPath ] = someimg( record )

imageDirectory = "imgs";
havePrev = length(record.CurrentConditionStimulusInfo) > 2;
if havePrev
    prevImg = record.CurrentConditionStimulusInfo(3).MoreInfo.imgString;
else
    prevImg = '';
imtypedir = strcat(imageDirectory, '*.jpg');
fileList = dir(imtypedir);
fileList(strcmp(prevImg,fileList)) = [];
fi = randsample(1:length(fileList), 1);
imgPath = fileList{fi}.name;
img = imread(strcat(listdir, imgPath));