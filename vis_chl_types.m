%--------------------------------------------------------------------------
%  Bird5eye plot: bird's-eye view
%--------------------------------------------------------------------------

close all

% Choose model
band_run = 'sing';
inel = 'off';
pf_type = 'petzold';
aw_data = 'PF';
chl_type = 'jerlov';
jerlov = 'PW';
model_type = 'new';
macbeth_col = 19;

% Chlorophyll types to cycle through
chl_types = {'jerlov', 'S1', 'S2', 'S3', 'S4', 'S5', ...
                             'S6', 'S7', 'S8', 'S9'};

% Depths
depths = 0:0.25:3.5;
mac_depths = length(depths);

% Colour display options
gamma = 1;
brightness = 1;

addpath([pwd, '/saved_models'])
addpath([pwd, '/params'])
addpath([pwd, '/data_hcube'])
addpath([pwd, '/colours'])
addpath([pwd, '/colours/spectral_color'])

load('data_input/rfl_macbeth.mat', 'macbeth_names', 'macbeth_colours');

% Reverse define the band corners in spec to sample raw rfl values
bandwidth = 10;
band_min = 400;
band_max = 730;

band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
nbands = length(bands);
nsubbs = round(bandwidth/5);  % Sample every 5nm
subspec = (spec(1):(bandwidth/nsubbs):spec(end));
subspec = subspec(:);

% Convert wavelengths to RGB vectors, [1, length(bands), 3]
%RGB = raw2rgb(bands, gamma, macbeth_norm);
RGB = spectrumRGB(bands);
RGBw = sum(RGB, 2);
RGB = brightness * RGB ./ RGBw;


%--------------------------------------------------------------------------

% Construction of colour chart
% ----------------------------

X = length(chl_types);
Y = mac_depths;

grid = ones(Y, X, 3);

for x = 1:X

    clear('bot_depths', 'ud_int', 'ud_dry', 'mac_int');
    if strcmpi(chl_types{x}, 'jerlov')
        jerlov = 'PW';
    else
        jerlov = 'off';
    end

    model_name = ['sink_', model_type, '_', band_run, ...
                                 '_bwid', num2str(bandwidth), ...
                                 '_inel_', inel, ...
                                 '_', pf_type, '_pf', ...
                                 '_aw', aw_data, ...
                                 '_chl', chl_types{x}, ...
                                 '_jerlov', jerlov, ...
                                 '_macbeth', num2str(macbeth_col)];
    load(['saved_models/', model_name, '.mat'], ...
         'bot_depths', 'ud_int', 'ud_dry');
    
    disp(chl_types{x})
    disp(ud_int{5}(1:4))
    for y = 1:Y
        grid(y, x, :) = rfl2rgb(ud_int{y}, RGB);
    end

end

fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
imagesc(grid)
title('Chlorophyll variation submerging white Lambertian reflector.', 'FontSize', 22);

xlabel('Chlorophyll Strata', 'FontSize', 18);
xlabs = [{'Pure Water'}, chl_types{2:end}];
xticklabels(xlabs);
ylabel('Depth (m)', 'FontSize', 18);
ylabs = num2cell(bot_depths(2:2:end));
%ylabs(2:2:end) = {[]};
yticklabels(ylabs);
ax = gca;
ax.FontSize = 20;


%--------------------------------------------------------------------------

   % Save graph
   %saveas(gcf, ['outputs/mac_flip/flip_cross/_mac_cross_', ...
   %             model_type, '_coloue_', num2str(macbeth_col), ...
   %             '_depth_', num2str(mac_dep_cm), 'cm.png']);
      
saveas(gcf, 'outputs/chl-compare.png')
