%--------------------------------------------------------------------------
%  Roberts Colour check
%--------------------------------------------------------------------------

close all

addpath([pwd, '/colours'])

macbeth_norm = 0;
gamma = 1;
brightness = 1.8;

% Import PR colour data
load('data_input/rfl_pr_colours.mat', 'wavelengths_raw', ...
                                      'colour_names', ...
                                      'pr_rfl_raw');

pr_rfl = cell(6, 1);

%  Reverse define the band corners in spec to sample raw rfl values
bandwidth = 10;
band_min = 390;
band_max = 700;

band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
nbands = length(bands);

% Convert wavelengths to RGB vectors, [length(bands), 3]
%RGB = raw2rgb(bands, gamma, macbeth_norm);
RGB = spectrumRGB(bands);
RGBw = sum(RGB, 2);
RGB = brightness * RGB ./ RGBw;

for col = 1:6

%  Band average reflectances
   pr_rfl_int = interp1(wavelengths_raw, pr_rfl_raw{col}, bands, 'pchip');

%  Save RGBrfls
   pr_rfl{col} = sum(RGB .* reshape(pr_rfl_int, [1, nbands, 1]), 2);
   
   if col == 1
      pr_rfl{col} = pr_rfl{col} * 2.5;
   elseif col == 5
      pr_rfl{col} = pr_rfl{col} * 1.8;      
   elseif col == 6
      pr_rfl{col} = pr_rfl{col} * 1.5;
   end

end


%--------------------------------------------------------------------------

% Construct tiled pallet
% ----------------------

s = 7;   % Square side length
e = 2;   % Edge width
g = 1;   % Gap width

base   = (2 * e) + (2 * g) + (3 * s);
height = (2 * e) + (1 * g) + (2 * s);

pallet = zeros(height, base, 3); % Background colour is black

% Colour tiles
for col = 1:6
   
   i = ceil(col/3);
   j = 1 + mod(col-1, 3);
   
   pallet = colour_sq(i, j, pr_rfl{col}, pallet, s, e, g);
   
end


%--------------------------------------------------------------------------

% Plot reflectance pallet
close all
figure;
imagesc(pallet);
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.DataAspectRatioMode = 'manual';
ax.Title.String = ['PR Colour Pallet (brightness = ', ...
                   num2str(brightness, '%.1f'), ')'];
%['PR Colour Pallet (normalisation colour ', num2str(macbeth_norm), ')'];
ax.Title.FontSize = 13;
hold on

% Legend names and dummy plot
lgd_names = cell(6,1);
for col = 1:6
   
   lgd_names{col} = [num2str(col), '. ', colour_names{col}];
   
   i = ceil(col/3);
   j = 1 + mod(col-1, 3);
   [m, n] = corner_sq(i, j, s, e, g);
   scatter(n, m, 'MarkerEdgeColor', pr_rfl{col}, ...
                 'MarkerFaceColor', pr_rfl{col});
   hold on
   
end

legend(lgd_names, 'FontSize', 10, 'Location', 'eastoutside');

% Number the tiles
for col = 1:6
   [i, j] = centre_sq(ceil(col/3), 1+mod(col-1, 3), s, e, g);
   t = text(j, i, num2str(col));
   t.FontSize = 14;
   t.HorizontalAlignment = 'center';
   t.FontWeight = 'normal';
   t.Color = [1, 1, 1];
end

% Save graph
pr_name = ['_images/mac_roberts/_rb_colours_brightness_', ...
           num2str(brightness, '%.1f'), '.png'];
saveas(gcf, pr_name);
   


%--------------------------------------------------------------------------

% Plotting functions

function pallet = colour_sq(i, j, RGB, pallet, side, edge, gap)

   m1 = edge + ((i-1) * gap) + ((i-1) * side) + 1;
   m2 = edge + ((i-1) * gap) + (i * side);
   n1 = edge + ((j-1) * gap) + ((j-1) * side) + 1;
   n2 = edge + ((j-1) * gap) + (j * side);
   
   pallet(m1:m2, n1:n2, 1) = RGB(1, 1, 1);  % Red
   pallet(m1:m2, n1:n2, 2) = RGB(1, 1, 2);  % Green
   pallet(m1:m2, n1:n2, 3) = RGB(1, 1, 3);  % Blue
   
end

function [m, n] = centre_sq(i, j, side, edge, gap)

   m = edge + (i-1) * gap + (i-1) * side + ceil(side/2);
   n = edge + (j-1) * gap + (j-1) * side + ceil(side/2);
   
end

function [m, n] = corner_sq(i, j, side, edge, gap)

   m = edge + (i-1) * gap + (i-1) * side + 1;
   n = edge + (j-1) * gap + (j-1) * side + 1;
   
end