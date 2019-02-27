function [ mu, sig ] = FitNormWLS( x )
%Fitting a normal distribution using weighted least squares (WLS)

N=numel(x);

p = (1:N) - .5;
p = p' / N;

x = sort(x);
mask =  x>0.0 & x<1.0 ;
x = x( mask );

p = p(mask);

wgt = 1 ./ sqrt(p.*(1-p));
normObjCen = @(params) sum(wgt.*(normcdf(x,(params(1)),(params(2))) - p).^2);
options = optimset('Display','off');
[paramHatCen, fval, exitflag] = ...
    fminsearch(normObjCen, [double(mean(x)),double(std(x))], options);

if exitflag < 1
    mu = median(x);
    sig = std(x);
else
    mu = paramHatCen(1);
    sig = paramHatCen(2);
end

end

