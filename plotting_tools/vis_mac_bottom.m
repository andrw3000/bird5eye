%--------------------------------------------------------------------------
%  MacBeth check
%--------------------------------------------------------------------------

close all

addpath([pwd, '/colours'])

% Choose model
band_run = 'sing';
inel = 'off';
pf_type = 'petzold';
aw_data = 'PS';
chl_type = 'roberts';
jerlov = 'II';
model_type = 'new';
bandwidth = 10;

brightness = 1.8;
load('_data_input/rfl_macbeth.mat', 'macbeth_rfl_raw', ...
                                    'wavelengths_raw', ...
                                    'macbeth_names', ...
                                    'macbeth_colours');
   
model_name = ['sink_', model_type, '_', band_run, ...
              '_bwid', num2str(bandwidth), ...
              '_inel_', inel, ...
              '_', pf_type, '_pf', ...
              '_aw', aw_data, ...
              '_chl', chl_type, ...
              '_jerlov', jerlov, ...
              '_macbeth', num2str(1)];

load(['_saved_models_', model_type, '/', model_name, '.mat'], ...
                                             'bands', ...
                                             'bot_depths', ...
                                             'ud_ext', ...
                                             'ud_int', ...
                                             'ud_dry');

% Reverse define the band corners in spec to sample raw rfl values
bandwidth = bands(2) - bands(1);
spec = (bands(1) - bandwidth/2):bandwidth:(bands(end) + bandwidth/2);
nbands = length(bands);
nsubbs = round(bandwidth/5);  % Sample every 5nm
subspec = (spec(1):(bandwidth/nsubbs):spec(end));
subspec = subspec(:);

% Convert wavelengths to RGB vectors, [length(bands), 3]
RGB = spectrumRGB(bands);
RGBw = sum(RGB, 2);
RGB = brightness * RGB ./ RGBw;

% Save RGBrfls
bot_col = rfl2rgb(ud_dry{2}, RGB);
sea_col = rfl2rgb(ud_int{end}, RGB);

%--------------------------------------------------------------------------

close all
figure;
tiledlayout(1,2)

nexttile
imagesc(bot_col);
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.DataAspectRatioMode = 'manual';
ax.Title.String = 'Bottom (sand) colour';
ax.Title.FontSize = 13;

nexttile
imagesc(sea_col);
title({['Sea colour of ', model_type, ' model;'], ...
       ['Bottom depth of ', num2str(bot_depths(end)), 'm']});
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.DataAspectRatioMode = 'manual';

% Save graph
bot_name = ['_images/mac_bottom/_bottom_sea_colour_', ...
            model_type, '_model.png'];
saveas(gcf, bot_name);

