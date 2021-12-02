% Average DW Irradiance file

% Band avg spectrum: bands of width 10nm centred at 400 to 730
bandwidth = 10;
band_min = 400;
band_max = 730;
band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
nbands = length(bands);

exp_dwirr = zeros(nbands, 1);
for b = 1:nbands
    abv = irr_raw(:, 1) >= spec(b);
    blw = irr_raw(:, 1) < spec(b+1);
    loc = find(abv .* blw);
    num = length(loc);
    exp_dwirr(b) = sum(irr_raw(loc, 2)) / num;
end

load('data_hcube/exp_macbeth.mat', ...
            'exp_cols', ...
            'exp_spec', ...
            'exp_bands', ...
            'exp_bandcols')

save('data_hcube/exp_macbeth.mat', ...
            'exp_cols', ...
            'exp_spec', ...
            'exp_bands', ...
            'exp_bandcols', ...
            'exp_dwirr')