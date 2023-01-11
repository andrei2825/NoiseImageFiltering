clear all;
close all;

I = (imread('bird.jpg'));
I = rgb2gray(I);
noise_level2 = zeros(1, 9);
noise_level3 = zeros(1, 9);
time2 = zeros(1, 9);
time3 = zeros(1, 9);
for noise = 1:9
    img = imnoise(I,'salt & pepper', noise/10);
    n = 3;
    [r,c] = size(img);
    tic
    tmp = padarray(img, [floor(n/2) floor(n/2)]);
    res1 = zeros(size(img));
    for i = 1:r
        for j = 1:c
            mask = tmp(i:i+n-1, j:j+n-1);
            res1(i,j) = median(mask(:));
        end
    end
    time2(noise) = toc;
    
    imwrite(res1, colormap(gray), "birdClean.jpg");
    imshow(img);
    t = sprintf('Initial image at %d % noise', noise*10);
    title(t);
    figure;
    imshow("birdClean.jpg");
    t = sprintf('Clasic median filtering at %d% noise', noise*10);
    title(t);
    figure;

    tic
    nn =zeros(size(tmp));
    max_mask_size = 21;
    res2 = zeros(size(img));
    for i = 1:r-n+1
        for j = 1:c-n+1
           if j + n-1 > size(tmp,2)
               break
           end
           mask = tmp(i:i+n-1, j:j+n-1);
           pixel_noise_level = sum(mask(:) == 0 | mask(:) == 255) / numel(mask);
           while pixel_noise_level > 0.5 && n < max_mask_size
               n = n+2;
               if j + n-1 > size(tmp,2) || i + n-1 > size(tmp,1)
                    n = n-2;
                    break
               end
               mask = tmp(i:i+n-1, j:j+n-1);
               pixel_noise_level = sum(mask(:) == 0 | mask(:) == 255) / numel(mask);
           end
           nn(i, j) = n;
           sortedMask = sort(mask(:));
           res2(i, j) = sortedMask(length(sortedMask)/2+0.5);
           n = 3;
        end
    end
    time3(noise) = toc;
    
    imwrite(res2, colormap(gray), "birdClean2.jpg");
    imshow("birdClean2.jpg");
    t = sprintf('Improved median filtering at %d% noise', noise*10);
    title(t);
    figure;
    
    
    
    
    h = histogram(nn);
    t = sprintf('Mask sizes at %d% noise', noise*10);
    title(t);
    figure
    h1 = histogram(res1);
    t = sprintf('Clasic median filtering histogram at %d% noise', noise*10);
    title(t);
    figure
    h2 = histogram(res2);
    t = sprintf('Improved median filtering histogram at %d% noise', noise*10);
    title(t);
    figure
    
    
    dpRes1 = im2double(res1);
    dpRes2 = im2double(res2);
    
    
    
    %noise level clasic mean 
    mean_val2 = mean2(dpRes1);
    std_val2 = std2(dpRes1);
    noise_level2(noise) = std_val2 / mean_val2;
    
    
    %noise level improved mean 
    mean_val3 = mean2(dpRes2);
    std_val3 = std2(dpRes2);
    noise_level3(noise) = std_val3 / mean_val3;

end


plot(noise_level2, 'r--');
hold on;
plot(noise_level3, 'b');
title('noise levels');
legend('Clasic median', 'Improved median');
figure

plot(time2, 'r--');
hold on;
plot(time3, 'b');
title('time');
legend('Clasic median', 'Improved median');
