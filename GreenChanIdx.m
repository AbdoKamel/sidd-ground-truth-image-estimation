function [ grnIdx ] = GreenChanIdx( meta )
%GREENCHANIDX Summary of this function goes here
%   Detailed explanation goes here

cfastr = cfa_pattern(meta);
if cfastr(1) == 'g'
    grnIdx=1;
else
    grnIdx=2;
end

end

