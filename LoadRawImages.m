function [ rawImages, metadataList ] = LoadRawImages(dngDir)
%Loads and returns an array of raw images and a list of corresponding 
%metadata structures

warning('off','MATLAB:imagesci:tifftagsread:zeroComponentCount');
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');
warning('off','images:initSize:adjustingMag');
warning('off', 'MATLAB:nearlySingularMatrix');

% load DNG filenames
if isunix
    tmp_fns = [dir(fullfile(dngDir, '*.dng')), ...
        dir(fullfile(dngDir, '*.DNG'))];    
elseif ispc
    tmp_fns = dir(fullfile(dngDir, '*.dng'));
end

n = numel(tmp_fns);
image_filenames = cell(n, 1);
for i = 1 : numel(tmp_fns)
    image_filenames{i} = tmp_fns(i).name;
end
fullfilenames = fullfile(dngDir, image_filenames);
fullfilenames = fullfilenames';

% load first image
metadataList = cell(n);
[raw_data, metadataList{1}] = ...
    Load_Data_and_Metadata_from_DNG(char(fullfilenames(1)));

% normalize
rawNormal = run_pipeline(raw_data, metadataList{1}, 'raw', 'normal');
rawNormal = single(rawNormal);

[h, w] = size(rawNormal);
rawImages = zeros(h, w, n, 'single');

rawImages(:, :, 1) = rawNormal;

% save metadata
metafile = fullfile(dngDir, '..', ['meta', num2str(1), '.mat']);
parsave(metafile, metadataList{1});

% for all images
for i = 2 : n

    % load data and meta data
    [raw_data, metadataList{i}] = ...
        Load_Data_and_Metadata_from_DNG(char(fullfilenames(i)));

    % normalize
    rawNormal = run_pipeline(raw_data, metadataList{i}, 'raw', 'normal');
    rawNormal = single(rawNormal);

    rawImages(:,:,i) = rawNormal;

end

end
