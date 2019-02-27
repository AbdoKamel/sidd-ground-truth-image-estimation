function [dstMrks] = LandmarkPoints(h, w)
% Returns a list of (i, j) coordinates to use as landmarks for image
% registration
step = 1024;
nh = round(h / step);
nw = round(w / step);
dstMrks = zeros(nh * nw, 2);
k = 1;
% use step/2 as the raw image will be split into 4 channels of half width and
% height
for i = step / 2 : step : h
    for j = step / 2 : step : w
        dstMrks(k, :) = [i, j];
        k = k + 1;
    end
end
dstMrks = round(dstMrks / 2);
