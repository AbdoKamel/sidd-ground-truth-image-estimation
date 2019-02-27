function [ srcMrks ] = GetSrcMrks( im1, im2, dstMrks, winsz, usf  )

[h,w] = size(im1);
winhalf = winsz/2;   

nMrks = size(dstMrks, 1);

for k=1:nMrks
    
    wstarti = dstMrks(k,1) - winhalf;    wstartj = dstMrks(k,2) - winhalf;
    wendi = dstMrks(k,1) + winhalf;      wendj = dstMrks(k,2) + winhalf;

    if wendi > h, wendi = h;   end
    if wendj > w, wendj = w;   end
    if wstarti < 1, wstarti = 1;   end
    if wstartj < 1, wstartj = 1;   end

    win1 = im1(wstarti:wendi, wstartj:wendj);
    win2 = im2(wstarti:wendi, wstartj:wendj);

    output = dftregistration(fft2(win1),fft2(win2),usf);
    tx=output(4); % col/horizontal shift
    ty=output(3); % row/vertical shift

    srcMrks(k,1:2) = [dstMrks(k,1)-ty, dstMrks(k,2)-tx]; 
        
end

