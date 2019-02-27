function [ output_image ] = run_pipeline( input_image, meta_info, input_stage, output_stage, cfastr  )
%RUN_PIPELINE Run a raw image through the pipeline and return the image
% after the specified 'stage'. stages are: 'raw', 'normal', 'wb',
% 'demosaic', 'srgb', and 'tone'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% normalization

if strcmp(input_stage, 'raw')
    
    if isfield(meta_info,'BlackLevel')
        black = meta_info.BlackLevel(1);
        saturation = meta_info.WhiteLevel;
    else
        black = meta_info.SubIFDs{1,1}.BlackLevel(1);
        saturation = meta_info.SubIFDs{1,1}.WhiteLevel;
    end
    input_image=double(input_image);

    lin_bayer = (input_image-black)/(saturation-black);
    lin_bayer = max(0,min(lin_bayer,1));
       
    % go to next stage
    input_image=lin_bayer;
    input_stage='normal';
end

if strcmp(output_stage,'normal')
    output_image=single(lin_bayer);
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get cfapattern

if ~ exist ('cfastr','var')
    cfastr=cfa_pattern(meta_info);
end
if strcmp(cfastr, 'none')
    cfastr=cfa_pattern(meta_info);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% white balancing
if strcmp(input_stage,'normal')
    
    lin_bayer=input_image;
    
    wb_multipliers = meta_info.AsShotNeutral; 
    wb_multipliers = wb_multipliers.^-1;
    mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,cfastr);
    balanced_bayer = lin_bayer .* mask; 
    balanced_bayer = max(0,min(balanced_bayer,1));
    
    % go to next stage
    input_image=balanced_bayer;
    input_stage='wb';
end

if strcmp(output_stage,'wb')
    output_image=single(balanced_bayer);
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% demosaic

if strcmp(input_stage,'wb')
    
    balanced_bayer = input_image;
    
    temp = uint16(balanced_bayer*(2^16));
    lin_rgb = single(demosaic(temp,cfastr))/(2^16);
    
    % go to next stage
    input_image=lin_rgb;
    input_stage='demosaic';
end

if strcmp(output_stage , 'demosaic')
    output_image = single(lin_rgb);
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% color space conversion

if strcmp(input_stage,'demosaic')
    
    lin_rgb = input_image;
    
    xyz2cam9=meta_info.ColorMatrix2;
    xyz2cam=reshape(xyz2cam9,3,3)';
    xyz2cam = xyz2cam ./ repmat(sum(xyz2cam,2),1,3); % Normalize rows to 1
    
    %%%%%%%%%% color space conversion (xyz2rgb)

    cam2xyz=xyz2cam^-1;
    lin_xyz=apply_cmatrix(lin_rgb, cam2xyz);
    lin_xyz = max(0,min(lin_xyz,1)); % clip
    srgb=xyz2rgb(lin_xyz); % xyz to srgb -- this one applies gamma
    
    srgb = max(0,min(srgb,1));
    
    % go to next stage
    input_image=srgb;
    input_stage='srgb';
end

if strcmp(output_stage , 'srgb')
    output_image = single(srgb);
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% tone curve

if strcmp(input_stage,'srgb')
    
    srgb = input_image;
    load('tone_curve.mat','tc');
    x=uint16(srgb*(size(tc,1)-1) + 1);
    tone=tc(x);

    % go to next stage
    input_image=tone;
    input_stage='tone';%%%
end

if strcmp(output_stage , 'tone')
    output_image = single(tone);
    return;
else
    % unrecognized stage!
    output_image=single(input_image);
end

end

