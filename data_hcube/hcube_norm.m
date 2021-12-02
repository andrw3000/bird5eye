% Normalise the MacBeth structure array


% Define spectrum
bandwidth = 10;
band_min = 400;
band_max = 730;
band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
nbands = length(bands);
nsubs = round(bandwidth/5);  % Sample every 5nm
subspec = (spec(1):(bandwidth/nsubs):spec(end));
subspec = subspec(:);


% Load data
addpath([pwd, '/data_hcube'])
load('exp_macbeth.mat', 'exp_bandcols');  % exp_bandcols has shape:
                                          % [ndepths, ncols, nbands]

% Load Macbeth rfl
addpath([pwd, '/params'])
true19 = bandwidth_avg(params_macbeth(subspec, 19), bandwidth, nsubs);

% Normalise the white square 19
ratio = true19 ./ squeeze(exp_bandcols(1, 19, :));
ratio = repmat(reshape(ratio, [1, 1, length(ratio)]), ...
                                        [length(0:25:350), 25, 1]);
exp_normcols = exp_bandcols .* ratio;

save('exp_macnorm.mat', 'exp_normcols')