function [  ] = DngToPng( dngFile, gamma )
%DNGTOJPG Summary of this function goes here
%   Detailed explanation goes here

%     [raw, info] = ReadImageAndInfoFromDNG(dngFile);
    [raw, info] = Load_Data_and_Metadata_from_DNG(dngFile);
    if exist('gamma','var')
        srgb = run_pipeline(raw,info,'raw','srgb');
        srgb=srgb.^gamma;
        imwrite(srgb, [dngFile(1:end-4),'_gamma.PNG']);
    else
        srgb = run_pipeline(raw,info,'raw','srgb');
        imwrite(srgb, [dngFile(1:end-4), '.PNG']);
    end
end

