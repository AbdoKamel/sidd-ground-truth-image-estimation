function [ raw ] = RawFrom4Channels( fourchan )
%RAWTO4CHANNELS Summary of this function goes here
%   Detailed explanation goes here

[h,w,~] = size(fourchan);

raw = zeros(h*2,w*2);

idx = [1,1; 1,2; 2,1; 2,2];

for c=1:4
    raw(idx(c,1):2:end, idx(c,2):2:end) = fourchan(:,:,c);
end


end

