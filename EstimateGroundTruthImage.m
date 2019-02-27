function [MeanUnprocessed, AlignedMeanImage, RobustMeanImage, ...
    MeanUnprocessedSrgb, AlignedMeanImageSrgb, RobustMeanImageSrgb, ...
    refImage, refImageSrgb, refMetadata] ...
    = EstimateGroundTruthImage(dngDir, defectivePixelMask, refIdx)

totTimeStart = tic;

msg = ['Processing DNG images in: ', dngDir];
disp(msg);

msg = ['Loading DNGs... '];
fprintf(msg);

t1 = tic;
% TODO
[rawImages, metadataList] = ...
    LoadRawImages(dngDir);
loadTime = toc(t1);

msg = ['time = ', num2str(loadTime) , ' s\n'];
fprintf(msg);

[H, W, N] = size(rawImages);

%% MEAN IMAGE
% before any processing - raw-RGB and sRGB

fprintf('Mean image before processing...\n');
MeanUnprocessed = mean(rawImages, 3);
MeanUnprocessed = min(max(MeanUnprocessed, 0), 1);
MeanUnprocessedSrgb = single(run_pipeline(MeanUnprocessed, metadataList{1}, 'normal', 'srgb'));

%% ROBUST MEAN IMAGE ESTIMATION

% reference image for spatial alignment
refImage = rawImages(:, :, refIdx);
refMetadata = metadataList{refIdx};

% SHIFT IMAGE MEANS
imageMeans = mean(mean(rawImages, 1), 2);
imageMeans = imageMeans(:);
meanPixelValue = mean(imageMeans);
shiftValues = imageMeans - meanPixelValue;
for i=1:N
    rawImages(:,:,i) = rawImages(:,:,i) - shiftValues(i);
end
rawImages = min(max(rawImages, 0), 1);

% DEFECTIVE PIXEL CORRECTION

if ~isempty(defectivePixelMask)
    fprintf('Correcting defective pixels... ');

    t1 = tic;
    parfor i = 1 : N
        rawImages(:, :, i) = Fix_Defective_Pixels(rawImages(:, :, i), ...
            defectivePixelMask);
    end
    rawImages = min(max(rawImages, 0), 1);
    fixTime = toc(t1);
    msg = ['time = ', num2str(fixTime), 's \n'];
    fprintf(msg);
end

% LOCAL SPATIAL ALIGNMENT 

fprintf('Local spatial alignment... ');

% image landmarks (coordinates) used for registration
dstMrks = LandmarkPoints(H, W);
parfor i = 1 : N 
    rawImages(:, :, i) = DenseWarpTPS(refImage, ...
        rawImages(:, :, i), refMetadata, dstMrks);
end
rawImages = min(max(rawImages, 0), 1);
alignTime = toc(t1);
msg = ['time = ', num2str(alignTime), 's \n'];
fprintf(msg);
    
% ALIGNED MEAN IMAGE (NOT ROBUST)

AlignedMeanImage = mean(rawImages, 3);
AlignedMeanImage = min(max(AlignedMeanImage, 0), 1);
AlignedMeanImageSrgb = run_pipeline(AlignedMeanImage, refMetadata, ...
    'normal', 'srgb');
    
% ROBUST MEAN IMAGE ESTIMATION

fprintf('Robust mean image estimation... ');

eps = 1e-5; % used to check for under/over-exposed (clipped) pixels
minClipPercent = .05; 
nMinClipPts = round(minClipPercent * N);
clipMask = sum((rawImages < eps | rawImages > (1 - eps)), 3) > nMinClipPts;
numClipPixels = sum(clipMask(:));
clipPercent = numClipPixels / (W * H);

% Apply WLS normal distribution fitting

t1 = tic;
RobustMeanImage = AlignedMeanImage;
parfor i = 1 : H
    for j = 1 : W
        if clipMask(i, j)
            xs = rawImages(i, j, :);
            xs = xs(:);
            [ mu, ~ ] = FitNormWLS( xs );
            RobustMeanImage(i, j) = mu;
        end
    end
end
RobustMeanImage = min(max(RobustMeanImage, 0), 1);
tt = toc(t1);
msg = ['time = ', num2str(tt), ' s \n'];
fprintf(msg);
RobustMeanImageSrgb = run_pipeline(RobustMeanImage, refMetadata, 'normal', 'srgb');

% Noisy image
refImageSrgb = single(run_pipeline(refImage, refMetadata, 'normal', 'srgb'));
% imwrite(refImageSrgb, fullfile(noisySrgbDir, 'NOISY_SRGB.png'));

totTime = toc(totTimeStart);
msg =  ['Total Time = ', num2str(totTime), ' s'];
disp(msg);

end

