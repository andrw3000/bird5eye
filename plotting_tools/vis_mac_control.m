%--------------------------------------------------------------------------
%  MacBeth check
%--------------------------------------------------------------------------

close all

macbeth_norm = 0;
gamma = 1;
brightness = 1.8;

addpath([pwd, '/colours/spectral_color'])

load('_data_input/rfl_macbeth.mat', 'macbeth_rfl_raw', ...
                                    'wavelengths_raw', ...
                                    'macbeth_names', ...
                                    'macbeth_colours');

mac_ref = cell(24, 1);
mac_rfl = cell(24, 1);

% Spectral bandwidths
bandwidth = 10;
band_min = 390;
band_max = 740;

% Reverse define the band corners in spec to sample raw rfl values
band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
nbands = length(bands);

% Colour system object
R0 = [0.70, 0.33];
G0 = [0.21, 0.71];
B0 = [0.15, 0.06];
W0 = [0.33, 0.33];

%cs = ColourSystem(R0, G0, B0, W0);
%cs = ColourSystem('sRGB');
RGB = spectrumRGB(bands);
RGBw = sum(RGB, 2);
RGB = brightness * RGB ./ RGBw;

for col = 1:24

%  Band average reflectances
   mac_rfl_int = interp1(wavelengths_raw, macbeth_rfl_raw{col}, bands);

%  Convert wavelengths to RGB vectors, [length(bands), 3]
   %RGB = normRGB(raw2rgb(bands, gamma), macbeth_norm, bands);
   %RGB = normRGB(squeeze(spectrumRGB(bands)), macbeth_norm, bands);
      
%  Save RGBrfls, [1, 1, 3]
   mac_ref{col} = macbeth_colours{col} / 255;
   %mac_rfl{col} = cs.spec2rgb(bands, raw_mac_rfl);
   mac_rfl{col} = rfl2rgb(mac_rfl_int, RGB);
      
end

%--------------------------------------------------------------------------

% Construction of tiled pallet plot
% ---------------------------------

s = 7;   % Square side length
e = 2;   % Edge width
g = 1;   % Gap width

base   = (2 * e) + (5 * g) + (6 * s);
height = (2 * e) + (3 * g) + (4 * s);

% Set background colour to black
pmac_ref = zeros(height, base, 3);
pmac_rfl = zeros(height, base, 3);

% Colour tiles
for col = 1:24
   
   i = ceil(col/6);
   j = 1 + mod(col-1, 6);
   
   pmac_ref = colour_sq(i, j, mac_ref{col}, pmac_ref, s, e, g);
   pmac_rfl = colour_sq(i, j, mac_rfl{col}, pmac_rfl, s, e, g);
   
end


%--------------------------------------------------------------------------

close all

figure('units','normalized','outerposition',[0 0 1 1]);
tiledlayout(1,2)

nexttile
imagesc(pmac_ref);
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.DataAspectRatioMode = 'manual';
ax.Title.String = 'Reference MacBeth Pallet';
ax.Title.FontSize = 13;

% Number the tiles
for col = 1:24
   [i, j] = centre_sq(ceil(col/6), 1+mod(col-1, 6), s, e, g);
   t = text(j, i, num2str(col));
   t.FontSize = 14;
   t.HorizontalAlignment = 'center';
   t.FontWeight = 'normal';
   if col < 19 || col > 20
      t.Color = [1, 1, 1];
   end
end

nexttile
imagesc(pmac_rfl);
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.DataAspectRatioMode = 'manual';
ax.Title.String = ['Reflectance MacBeth Pallet (brightness = ', ...
                   num2str(brightness, '%.1f'), ')'];
ax.Title.FontSize = 13;

%  Number the tiles
for col = 1:24
   [i, j] = centre_sq(ceil(col/6), 1+mod(col-1, 6), s, e, g);
   t = text(j, i, num2str(col));
   t.FontSize = 14;
   t.HorizontalAlignment = 'center';
   t.FontWeight = 'normal';
   if col < 19 || col > 20
      t.Color = [1, 1, 1];
   end
end

% Save graph
macref_name = ['_images/mac_check/_mac_ref_brightness_', ...
               num2str(brightness, '%.1f'), '.png'];
saveas(gcf, macref_name);
   


%--------------------------------------------------------------------------

% Plotting functions

function pallet = colour_sq(i, j, RGB, pallet, side, edge, gap)

   m1 = edge + ((i-1) * gap) + ((i-1) * side) + 1;
   m2 = edge + ((i-1) * gap) + (i * side);
   n1 = edge + ((j-1) * gap) + ((j-1) * side) + 1;
   n2 = edge + ((j-1) * gap) + (j * side);
   
   pallet(m1:m2, n1:n2, 1) = RGB(1);  % Red
   pallet(m1:m2, n1:n2, 2) = RGB(2);  % Green
   pallet(m1:m2, n1:n2, 3) = RGB(3);  % Blue
   
end

function [m, n] = centre_sq(i, j, side, edge, gap)

   m = edge + (i-1) * gap + (i-1) * side + ceil(side/2);
   n = edge + (j-1) * gap + (j-1) * side + ceil(side/2);
   
end
