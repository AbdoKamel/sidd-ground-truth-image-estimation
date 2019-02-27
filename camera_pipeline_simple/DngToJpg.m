function [  ] = DngToJpg( dngFile,qual,gamma )
%DNGTOJPG Summary of this function goes here
%   Detailed explanation goes here

    [raw, info] = Load_Data_and_Metadata_from_DNG(dngFile);
    if exist('gamma','var')
        srgb = run_pipeline(raw,info,'raw','srgb');
        srgb=srgb.^gamma;
        imwrite(srgb, [dngFile(1:end-4),'_gamma.JPG'], 'quality', qual);
    else
        srgb = run_pipeline(raw,info,'raw','tone');
        imwrite(srgb, [dngFile(1:end-4), '.JPG'], 'quality', qual);
    end
end

