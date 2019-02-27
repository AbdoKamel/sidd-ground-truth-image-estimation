%   By WangLin
%   2015-11-5
%   wanglin193@hotmail.com

clear all
%close all
%create a canvas
a = 32;
cc = 255*rand(1,3);
bb = 255*rand(1,3);
for i=1:3
    im(:,:,i) = [   cc(i)*ones(a,a),25+zeros(a,a);
                   25+zeros(a,a),cc(i)*ones(a,a)];
end

im = uint8(repmat(im,4,5));


[imh,imw,imc] = size(im);

%define landmarks
ps = [1,1;imw-0,1;imw-0,imh-0;1,imh-0;
      0.4*imw,imh*3/8;
      0.6*imw,imh*3/8;      
      0.4*imw,imh*5/8; 
      0.6*imw,imh*5/8];
pd = ps;
%move some points
% pd(5:8,:) = pd(5:8,:) + 15*[1,1;-1,1;1,-1;-1,-1];
pd(1:4,:) = pd(1:4,:) + 30*[1,1;-1,1;1,-1;-1,-1];
%pd(5:8,:) = pd(5:8,:) + 30*[-1,1;-1,-1;1,1;1,-1];

% ps=ps(5:end,:);
% pd=pd(5:end,:);

figure

subplot(2,2,1)
imshow(uint8(im))
title('Orininal image with base landmarks');
hold on
plot( ps(:,1),ps(:,2),'r.' );
 plot( pd(:,1),pd(:,2),'g.' ); % added by Abdo
 
%% Gaussian RBF function 
[imo1,mask1] = rbfwarp2d( im, ps, pd,'gau',imw*0.1 );
[imo2,mask2] = rbfwarp2d( im, ps, pd,'gau',imw*0.5 );

subplot(2,2,2)
imshow(uint8(imo1));
title('RBF warping Rad = 0.1*imwidth');
hold on
plot( ps(:,1),ps(:,2),'r.' );
plot( pd(:,1),pd(:,2),'g.' );

subplot(2,2,3)
imshow(uint8(imo2));
title('RBF warping Rad = 0.5*imwidth');
hold on
plot( ps(:,1),ps(:,2),'r.' );
plot( pd(:,1),pd(:,2),'g.' );

%% Thin plate warping
tic
for i=1:150
[imo1,mask1] = rbfwarp2d( im, ps, pd,'thin');
end
toc
subplot(2,2,4)
imshow(uint8(imo1));
title('Thin-plate warping');
hold on
plot( ps(:,1),ps(:,2),'r.' );
plot( pd(:,1),pd(:,2),'g.' );
