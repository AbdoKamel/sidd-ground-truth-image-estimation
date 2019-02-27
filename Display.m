function [] = Display(im1, im2)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here

fig = figure('ButtonDownFcn', @SwitchImage);
fig.UserData.im1 = im1;
fig.UserData.im2 = im2;
fig.UserData.idx = 1;
im = imshow(im1);
im.ButtonDownFcn = @SwitchImage;
title('Click to switch between noisy and ground truth images.');

end


function [] = SwitchImage(hObject, eventdata, handles)

    fig = gcf;
    if fig.UserData.idx == 1
        im = imshow(fig.UserData.im2);
        fig.UserData.idx = 2;
    else
        im = imshow(fig.UserData.im1);
        fig.UserData.idx = 1;
    end
    im.ButtonDownFcn = @SwitchImage;
    title('Click to switch between noisy and ground truth images.');
end