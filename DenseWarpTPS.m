function [ rawWarp, srcMrks ] = ...
    DenseWarpTPS( raw1ref, raw2mov, meta, dstMrks)
% Warp a raw image 'raw2mov' to match a reference image 'raw1ref' using
% thin-plate splines

fourchan1 = RawTo4Channels(raw1ref);
fourchan2 = RawTo4Channels(raw2mov);

grnIdx = GreenChanIdx(meta);

gch1 = fourchan1(:,:,grnIdx);
gch2 = fourchan2(:,:,grnIdx);

% apply local registration to find corresponding landmarks 
% (local translation only)

winsz = 512;   winstep = 512;      usf = 10;

[ srcMrks ] = GetSrcMrks( gch1, gch2, dstMrks, winsz, usf  );

for i = 1:4
    [fourchan2(:,:,i), ~] = rbfwarp2d( fourchan2(:,:,i), ...
        [srcMrks(:,2), srcMrks(:,1)], [dstMrks(:,2), dstMrks(:,1)], 'thin');
end

rawWarp = RawFrom4Channels(fourchan2);

end

