%--------------------------------------------------------------------------
%  Visualise sinking MacBeth Pallet
%--------------------------------------------------------------------------

close all

% Choose model
band_run = 'sing';
inel = 'off';
pf_type = 'petzold';
aw_data = 'PF';
chl_type = 'jerlov'; %'jerlov';
jerlov = 'PW';
model_type = 'new';

% Colour display options
gamma = 1;
brightness = 1;
macbeth_norm = 19;

addpath([pwd, '/saved_models'])
addpath([pwd, '/params'])
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
nsubs = round(bandwidth/5);  % Sample every 5nm
subspec = (spec(1):(bandwidth/nsubs):spec(end));
subspec = subspec(:);

% Depths
depths = 0:0.25:3.5;
mac_depths = length(depths);

% Convert wavelengths to RGB vectors, [1, length(bands), 3]
RGB = spectrumRGB(bands);
RGB = brightness * normRGB(RGB, macbeth_norm, bands);
%RGBw = sum(RGB, 2);
%RGB = brightness * RGB ./ RGBw;

% Store colours
mac_dry = cell(24, 1);
mac_int = cell(24, 1);

for col = 1:24
   
   model_name = ['sink_', model_type, '_', band_run, ...
                 '_bwid', num2str(bandwidth), ...
                 '_inel_', inel, ...
                 '_', pf_type, '_pf', ...
                 '_aw', aw_data, ...
                 '_chl', chl_type, ...
                 '_jerlov', jerlov, ...
                 '_macbeth', num2str(col)];
           
   load(['saved_models/', model_name, '.mat'], ...
                                               'bot_depths', ...
                                               'ud_ext', ...
                                               'ud_int', ...
                                               'ud_dry');

   mac_dry{col} = rfl2rgb(ud_dry{1}, RGB);         % Dry colours, [1, 1, 3]
   %mac_depths = length(bot_depths) - 1;            % MacBeth depths
   mac_depths = length(depths);
   mac_int{col} = cell(mac_depths, 1);             % Wet colours

   %top = bandwidth_avg(params_macbeth(subspec, col), bandwidth, nsubs);
   %ratio = top ./ ud_int{1};
 
   for d = 1:mac_depths
      mac_int{col}{d} = rfl2rgb(ud_int{d}, RGB);
      %mac_int{col}{d} = rfl2rgb(ud_ext{d} .* ratio, RGB);
   end

end

%  Sea colour, [1, 1, 3]
   sea_col = rfl2rgb(ud_ext{end}, RGB);
   
%--------------------------------------------------------------------------

% Construction of tiled pallet plot
% ---------------------------------

s = 7;   % Square side length
e = 2;   % Edge width
g = 1;   % Gap width

sdry = 7;      % Square side length
edry = 1;      % Edge width
gdry = 1;      % Gap width

base   = (2 * e) + (5 * g) + (6 * s);
height = (2 * e) + (3 * g) + (4 * s);

base_dry   = (2 * edry) + (5 * gdry) + (6 * sdry);
height_dry = (2 * edry) + (3 * gdry) + (4 * sdry);


% Set background colour to sea colour
pmac_dry = repmat(sea_col, [height_dry, base_dry, 1]);
pmac_int = cell(mac_depths, 1);

for d = 1:mac_depths
   pmac_int{d} = repmat(sea_col, [height, base, 1]);
end

% Colour tiles
for col = 1:24
   
   i = ceil(col/6);
   j = 1 + mod(col-1, 6);
   
   pmac_dry = colour_sq(i, j, mac_dry{col}, pmac_dry, sdry, edry, gdry);
   
   for d = 1:mac_depths
      %if bot_depths(d) > 1
      %   meas = prod(mac_int{col}{d}(mac_int{col}{d} ~= 0));
      %   while meas < prod(sea_col)
      %      mac_int{col}{d} = 1.01 * mac_int{col}{d};
      %      meas = prod(mac_int{col}{d}(mac_int{col}{d} ~= 0));
      %   end
      %end
      
      pmac_int{d} = colour_sq(i, j, mac_int{col}{d}, pmac_int{d}, s, e, g);
   end
   
end


%--------------------------------------------------------------------------

close all
addpath([pwd, '/outputs/'])
gifname = ['outputs/macgif_', aw_data, '_', jerlov, '.gif'];

% Draw GIF
t1 = 2;
t2 = 5;
bot_dep_cm = bot_depths(end) * 100;
%max_dep_cm = bot_depths(end-1) * 100;
max_dep_cm = depths(end) * 100;

for d = 1:mac_depths

   %mac_dep_cm = bot_depths(d) * 100;
   mac_dep_cm = depths(d) * 100;
   
   % Sinking plot
   fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
   tiledlayout(t1, t2);
   % Use: 'axis tight manual' so getframe() returns a consistent size

   ax_int = nexttile([t1, t2 - 2]);
   imagesc(ax_int, pmac_int{d});
   ax_int.XTick = [];
   ax_int.YTick = [];
   ax_int.Box = 'on';
   ax_int.DataAspectRatioMode = 'manual';
   ax_int.Title.String = 'Sinking MacBeth Pallet';
   ax_int.Title.FontSize = 18;

   % Number the tiles
   for col = 1:24
      [i, j] = centre_sq(ceil(col/6), 1+mod(col-1, 6), s, e, g);
      txt = text(j, i, num2str(col));
      txt.FontSize = 16;
      txt.HorizontalAlignment = 'center';
      txt.FontWeight = 'normal';
      if col < 19 || col > 20
         txt.Color = [1, 1, 1];
      end
   end

   % Dry Plot
   ax_dry = nexttile([1, 2]);
   imagesc(ax_dry, pmac_dry);
   ax_dry.XTick = [];
   ax_dry.YTick = [];
   ax_dry.DataAspectRatioMode = 'manual';
   ax_dry.Title.String = 'Dry MacBeth Pallet';
   ax_dry.Title.FontSize = 13;
   ax_dry.Box = 'on';

   % Number the tiles
   for col = 1:24
      [i, j] = centre_sq(ceil(col/6), 1+mod(col-1, 6), sdry, edry, gdry);
      txt = text(j, i, num2str(col));
      txt.FontSize = 12;
      txt.HorizontalAlignment = 'center';
      txt.FontWeight = 'normal';
      if col < 19 || col > 20
         txt.Color = [1, 1, 1];
      end
   end
   
   % Counter
   ax_num = nexttile(t1 * t2 - 1);
   ax_num.Color = reshape(mac_int{6}{d}, [1, 3]);
   ax_num.GridColor = reshape(mac_int{6}{d}, [1, 3]);
   ax_num.DataAspectRatioMode = 'manual';
   ax_num.Box = 'on';
   ax_num.XTick = [];
   ax_num.YTick = [];
   ax_num.XTickLabel = [];
   ax_num.YTickLabel = [];
   txt = text(.5, .5, ['Depth: ', num2str(mac_dep_cm), 'cm']);
   txt.Color = [1, 1, 1];
   txt.FontSize = 24;
   txt.HorizontalAlignment = 'center';
   txt.FontWeight = 'bold';
   
   % Depth Bar
   ax_dep = nexttile(t1 * t2);
   deps = [max_dep_cm - mac_dep_cm, mac_dep_cm];
   %xb = categorical({'Cat'});
   b = bar(ax_dep, 1, deps, 'stacked');
   b(1).FaceColor = reshape(sea_col(1, 1, :), [1, 3]);
   b(2).FaceColor = [0.8500 0.3250 0.0980];
   ax_dep.DataAspectRatioMode = 'manual';
   %ax_dep.Title.String = 'Depth Indicator';
   ax_dep.Title.FontSize = 13;
   ax_dep.XTick = [];
   %ax_dep.YTick = 0:100*4:max_dep_cm;
   %ax_dep.YTickLabel = num2cell(flip(0:4:bot_depths(end-1)))';
   ax_dep.YTick = 0:50:max_dep_cm;
   ax_dep.YTickLabel = num2cell(flip(0:0.5:depths(end)))';
   ylabel('Depth (m)');
   
   % Create GIF
   %drawnow 
   frame = getframe(fig);  % Capture the plot as an image
   im = frame2im(frame);
   [imind, cm] = rgb2ind(im, 256);
   if d == 1 
       imwrite(imind, cm, gifname, 'gif', 'Loopcount', inf); 
   else 
       imwrite(imind, cm, gifname, 'gif', 'WriteMode', 'append'); 
   end

end


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
