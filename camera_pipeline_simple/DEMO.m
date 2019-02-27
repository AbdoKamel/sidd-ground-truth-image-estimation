% from DNG to sRGB
filename = fullfile('data', '0001_DSC_9315.DNG');
[im_raw, metadata] = Load_Data_and_Metadata_from_DNG(filename);
im_srgb = run_pipeline(im_raw, metadata, 'raw', 'srgb');
imwrite(im_srgb, fullfile('data', 'im_srgb_1.png'));

% from normalized RAW to sRGB
im_norm = load(fullfile('data', '0001_NOISY_RAW_001.MAT'));
im_norm = im_norm.x;
metadata = load(fullfile('data', '0001_METADATA_RAW_001.MAT'));
metadata = metadata.metadata;
im_srgb = run_pipeline(im_norm, metadata, 'normal', 'srgb');
imwrite(im_srgb, fullfile('data', 'im_srgb_2.png'));
