function [  ] = ShowDNG( dng_file, stage )
%SHOWDNG Summary of this function goes here
%   Detailed explanation goes here
    
    [raw, info] = Load_Data_and_Metadata_from_DNG(dng_file);
    srgb = run_pipeline(raw,info,'raw',stage);
    figure,imshow(srgb);

end

