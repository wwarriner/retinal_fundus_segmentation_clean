FOLDER = "";
MASKS = "";
OUT = fullfile(FOLDER, "cleaned");

contents = get_contents(FOLDER);
contents = get_files_with_extension(contents, ".png");

mask_contents = get_contents(MASKS);
mask_contents = get_files_with_extension(mask_contents, ".TIF");

assert(height(contents) == height(mask_contents));

stack = [];
for i = 1 : height(contents)
    c = contents(i, :);
    im_filepath = fullfile(c.folder, c.name);
    im_filepath = string(im_filepath);
    im = imread(im_filepath);

    m = mask_contents(i, :);
    mask_filepath = fullfile(m.folder, m.name);
    mask_filepath = string(mask_filepath);
    mask = imread(mask_filepath);
    mask = imresize(mask, size(im), "nearest");

    k = 3;
    mask = padarray(mask, [k k], "replicate");
    st = strel("disk", 3, 0);
    mask = imerode(mask, st);
    mask = mask(k+1:end-k, k+1:end-k);

    im(~mask) = false;

    im(1:k, :) = false;
    im(:, 1:k) = false;
    im(end-k+1:end, :) = false;
    im(:, end-k+1:end) = false;

    im = bwareaopen(im, 1000);
    stack = cat(3, stack, im);

    out_filepath = fullfile(OUT, c.name);
    [~, ~, ~] = mkdir(OUT);
    imwrite(im, out_filepath);
end

figure();
montage(stack, "interpolation", "bilinear");
