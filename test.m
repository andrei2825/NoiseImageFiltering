%{
tic
for i = 1:1000*1000
    r = rand(3);
    median(r(:));
end
toc
tic
for i = 1:1000*1000
    r = rand(3);
    [counts, binLocations] = imhist(r(:));
    cdf = cumsum(counts) / numel(r(:));
    x = binLocations(find(cdf > 0.5, 1));
end
toc
%}
tic
for i = 1:1000*1000
r = rand(3);
median(r(:));
end
toc


tic
for i = 1:1000*1000
r = rand(3);
median(median(r));
end
toc


tic
for i = 1:1000*1000
r = rand(3);
y = sort(r(:));
in = length(y)/2+0.5;
res = y(in);
end
toc

