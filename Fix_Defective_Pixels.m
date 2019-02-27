function [ rawFixed ] = Fix_Defective_Pixels( raw, defMask )
%FIX_DEFECTIVE_PIXELS Summary of this function goes here
%   Detailed explanation goes here

rawFixed = raw;

% channel start indices
cst=[1,1;1,2;2,1;2,2];

raw(defMask)=NaN;
ch=cell(4,1);
for c=1:4
    ch{c}=raw(cst(c,1):2:end , cst(c,2):2:end);
    ch{c}=inpaint_nans(ch{c},1);
    rawFixed(cst(c,1):2:end , cst(c,2):2:end) = ch{c};
end

rawFixed = min(rawFixed, 1);
rawFixed = max(rawFixed, 0);

end

