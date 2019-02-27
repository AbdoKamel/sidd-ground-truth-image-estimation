function [ fourchan ] = RawTo4Channels( raw )
%RAWTO4CHANNELS Summary of this function goes here
%   Detailed explanation goes here

[h,w] = size(raw);

fourchan = zeros(h/2,w/2,4);

idx = [1,1; 1,2; 2,1; 2,2];

for c=1:4
    fourchan(:,:,c) = raw(idx(c,1):2:end, idx(c,2):2:end);
end


end

