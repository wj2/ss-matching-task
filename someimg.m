function [ img, imgPath ] = someimg( record )

imageDirectory = 'C:\anl\monkeylogic\tasks\wjj\ss-matching-task\imgs\';
record
haveField = isfield(record, 'CurrentConditionStimulusInfo');
if haveField
    record.CurrentConditionStimulusInfo
    havePrev = length(record.CurrentConditionStimulusInfo) > 2;
    if havePrev
        record.CurrentConditionStimulusInfo{3}  
        prevImg = record.CurrentConditionStimulusInfo{3}.MoreInfo;
    else
        prevImg = '';
    end
else
    prevImg = '';
end
imtypedir = strcat(imageDirectory, '*.jpg');
imtypedir
fileList = dir(imtypedir);
fileList
strcmp(prevImg,fileList)
fileList(strcmp(prevImg,fileList)) = [];
fi = randsample(1:length(fileList), 1);
imgPath = fileList(fi).name;
img = imread(strcat(imageDirectory, imgPath));