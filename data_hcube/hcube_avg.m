% Average MacBeth file

% 'macbeth' has shape length(depths)=15, ncols=25, bmax=212
ncols = 25;
depths = 0:25:350;
addpath([pwd, '/data_hcube'])
load('data_hcube/exp_macbeth.mat', 'exp_cols', 'exp_spec');

% Band avg spectrum: bands of width 10nm centred at 400 to 730
bandwidth = 10;
band_min = 400;
band_max = 730;
band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);

nbands = length(bands);
exp_bandcols = zeros(length(depths), ncols, nbands);
exp_bands = zeros(nbands, 1);
for b = 1:nbands
    abv = exp_spec >= spec(b);
    blw = exp_spec < spec(b+1);
    loc = find(abv .* blw);
    num = length(loc);
    exp_bandcols(:, :, b) = squeeze(sum(exp_cols(:, :, loc), 3)) / num;
    exp_bands(b) = sum(exp_spec(loc)) / num;
end

save('data_hcube/exp_macbeth.mat', ...
            'exp_cols', ...
            'exp_spec', ...
            'exp_bands', ...
            'exp_bandcols')