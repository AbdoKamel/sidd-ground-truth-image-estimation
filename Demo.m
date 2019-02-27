%% dependencies

addpath(fullfile(pwd, 'camera_pipeline_simple'));
addpath(fullfile(pwd, 'RBF_ThinPlate_image_warping'));
addpath(fullfile(pwd, 'efficient_subpixel_registration'));

%% data and parameters (replace with your preferences)

dngDir = fullfile(pwd, 'DNGs'); % contains only 3 images
defectivePixelsMask = load(fullfile(dngDir, 'DefectivePixelsMask.mat')); 
defectivePixelsMask = defectivePixelsMask.DefectivePixelsMask;
% if not available, use an empty array
% defectivePixelsMask = [];
refIdx = 1; % use first image as reference for spatial alignment

%% prepare parallel pool

NUM_WORKERS = 4;
prepare_parallel_pool(NUM_WORKERS);

%% ground truth image estimation

[MeanUnprocessed, AlignedMeanImage, RobustMeanImage, ...
    MeanUnprocessedSrgb, AlignedMeanImageSrgb, RobustMeanImageSrgb, ...
    refImage, refImageSrgb, refMetadata] ...
    = EstimateGroundTruthImage(dngDir, defectivePixelsMask, refIdx);

%% saving outputs

parsave(fullfile(pwd, 'output', 'MeanUnprocessed.mat'), MeanUnprocessed);
parsave(fullfile(pwd, 'output', 'AlignedMeanImage.mat'), AlignedMeanImage);
parsave(fullfile(pwd, 'output', 'GT_RAW.mat'), RobustMeanImage);

imwrite(MeanUnprocessedSrgb, ...
    fullfile(pwd, 'output', 'MeanUnprocessedSrgb.png'));
imwrite(AlignedMeanImageSrgb, ...
    fullfile(pwd, 'output', 'AlignedMeanImageSrgb.png'));
imwrite(RobustMeanImageSrgb, ...
    fullfile(pwd, 'output', 'GT_SRGB.png'));

parsave(fullfile(pwd, 'output', 'NOISY_RAW.mat'), refImage);
imwrite(refImageSrgb, fullfile(pwd, 'output', 'NOISY_SRGB.png'));
parsave(fullfile(pwd, 'output', 'METADATA_RAW.mat'), refMetadata);

%% Display

Display(refImageSrgb, RobustMeanImageSrgb);
