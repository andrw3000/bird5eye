%--------------------------------------------------------------------------
%  Bird5eye plot: bird's-eye view
%--------------------------------------------------------------------------

close all

% Choose model
band_run = 'sing';
inel = 'off';
pf_type = 'petzold';
aw_data = 'SB';
chl_type = 'jerlov';
jerlov = 'PW';
model_type = 'new';
macbeth_col = 19;

% Colour display options
gamma = 1;
brightness = 1.8;

addpath([pwd, '/colours'])

load('data_input/rfl_macbeth.mat', 'macbeth_names', 'macbeth_colours');

% Reverse define the band corners in spec to sample raw rfl values
bandwidth = 10;
band_min = 390;
band_max = 740;

band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
nbands = length(bands);
nsubbs = round(bandwidth/5);  % Sample every 5nm
subspec = (spec(1):(bandwidth/nsubbs):spec(end));
subspec = subspec(:);

model_name = ['sink_', model_type, '_', band_run, ...
              '_bwid', num2str(bandwidth), ...
              '_inel_', inel, ...
              '_', pf_type, '_pf', ...
              '_aw', aw_data, ...
              '_chl', chl_type, ...
              '_jerlov', jerlov, ...
              '_macbeth', num2str(macbeth_col)];

load(['saved_models_', model_type, '/', model_name, '.mat'], ...
                                            'bot_depths', ...
                                            'ud_int', ...
                                            'ud_dry');

% Convert wavelengths to RGB vectors, [1, length(bands), 3]
%RGB = raw2rgb(bands, gamma, macbeth_norm);
RGB = spectrumRGB(bands);
RGBw = sum(RGB, 2);
RGB = brightness * RGB ./ RGBw;

mac_dry     = rfl2rgb(ud_dry{1}, RGB);       % Dry colours, [1, 1, 3]
mac_depths  = length(bot_depths) - 1;        % MacBeth depths
mac_int     = cell(mac_depths, 1);           % Wet colours

for d = 1:mac_depths
   mac_int{d} = rfl2rgb(ud_int{d}, RGB);
end

% Sea colour, [1, 1, 3]
sea_col = rfl2rgb(ud_int{end}, RGB);

%--------------------------------------------------------------------------

% Construction of cross plot
% --------------------------

u = 20;  % unit length
s = 5*u; % side length

% Inner lengths
a = u:4*u;
b = 2*u:3*u;

% Define grid with background sea colour
background = repmat(sea_col, [s, s, 1]);


% Interpolation points
p = 1;
q = 2*p + 1;
res = 50;
[X0, Y0] = meshgrid(p+1:q:q*s, p+1:q:q*s);
[X1, Y1] = meshgrid(1:1:q*s, 1:1:q*s);

% Dry corner
u2 = q*u;
v2 = q*ceil(u/5);
c1 = (4*u2 + v2):(5*u2 - v2);
c2 = v2:(u2 - v2);
a2 = u2:4*u2;
b2 = 2*u2:3*u2;
s2 = 5*u2;

% Copy to each depth
grid = repmat({background}, [mac_depths, 1]);
view = cell(mac_depths, 1);

bot_dep_cm = bot_depths(end) * 100;
max_dep_cm = bot_depths(end-1) * 100;

% Surf grid
q50 = q*s / 50;
[X50, Y50] = meshgrid(1:q50:q*s, 1:q50:q*s);
sink = -bot_depths(end) * ones(size(X1));

%--------------------------------------------------------------------------

close all
gifname = ['outputs/mac_gif/_mac_cross_', model_type, '_colour', ...
                                   num2str(macbeth_col), '.gif'];

for d = 1:mac_depths
   
   mac_dep_cm = bot_depths(d) * 100;

   while prod(mac_int{d}(mac_int{d} ~= 0)) < prod(sea_col)
      mac_int{d} = 1.01 * mac_int{d};
   end

%  Colour inner cross
   grid{d}(a, b, :) = mac_int{d} .* ones(size(grid{d}(a, b, :)));
   grid{d}(b, a, :) = mac_int{d} .* ones(size(grid{d}(b, a, :)));
   
%  Fill in bezzel
   view{d}(:,:,1) = interp2(X0, Y0, grid{d}(:, :, 1), X1, Y1, 'cubic');
   view{d}(:,:,2) = interp2(X0, Y0, grid{d}(:, :, 2), X1, Y1, 'cubic');
   view{d}(:,:,3) = interp2(X0, Y0, grid{d}(:, :, 3), X1, Y1, 'cubic');
   
   if d == 1
      view{d} = repmat(sea_col, [s2, s2, 1]);
      view{d} = repmat(sea_col, [s2, s2, 1]);
      view{d}(a2, b2, :) = mac_int{d} .* ones(size(view{d}(a2, b2, :)));
      view{d}(b2, a2, :) = mac_int{d} .* ones(size(view{d}(b2, a2, :)));
   end
   
   % Dry Corner      
   view{d}(c2, c1, 1) = mac_dry(1, 1, 1);
   view{d}(c2, c1, 2) = mac_dry(1, 1, 2);
   view{d}(c2, c1, 3) = mac_dry(1, 1, 3);
   
   % Figure
   fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
   tiledlayout(3, 5);
   
   % Sinking plot
   ax_int = nexttile([3,3]);
   imagesc(view{d});
   ax_int.XTick = [];
   ax_int.YTick = [];
   ax_int.Box = 'on';
   ax_int.DataAspectRatioMode = 'manual';
   ax_int.Title.String = ['Sinking MacBeth Colour: ', ...
                          num2str(macbeth_col), '. ', ...
                          macbeth_names{macbeth_col}];
   ax_int.Title.FontSize = 18;
   
   % Surf Plot
   ax_surf = nexttile([2,2]);
   
   Z50 = 0.5 * rand(size(X50));
   Z1 = interp2(X50, Y50, Z50, X1, Y1);
   sea = surf(ax_surf, X1, Y1, Z1, view{d});
   sea.EdgeColor = 'none';
   hold on
   
   % Bottom cross
   sink(a2, b2) = -bot_depths(d);
   sink(b2, a2) = -bot_depths(d);
   bed = surf(ax_surf, X1, Y1, sink);
   bed.FaceColor = mac_dry;
   bed.EdgeColor = 'none';
   ax_surf.ZLim = [-bot_depths(end-1), bot_depths(end-1)];
   ax_surf.XTick = [];
   ax_surf.YTick = [];
   ax_surf.Box = 'off';
   %ax_surf.DataAspectRatioMode = 'manual';
   ax_surf.View = [-45, 10];
   zoom(ax_surf, 1);
   
   % Depth Bar
   ax_dep = nexttile([1, 2]);
   deps = [mac_dep_cm, max_dep_cm - mac_dep_cm];
   %xb = categorical({'Cat'});
   db = bar(ax_dep, 1, deps, 'stacked');
   db(2).FaceColor = reshape(sea_col(1, 1, :), [1, 3]);
   db(1).FaceColor = [0.8500 0.3250 0.0980];
   ax_dep.DataAspectRatioMode = 'manual';
   %ax_dep.Title.String = 'Depth Indicator';
   ax_dep.Title.FontSize = 13;
   ax_dep.XTick = [];
   ax_dep.YTick = 0:100*4:max_dep_cm;
   ax_dep.YTickLabel = num2cell((0:4:bot_depths(end-1)))';
   ylabel('Depth (m)');
   camroll(-90)
   
   
   drawnow 
   frame = getframe(fig);  % Capture the plot as an image
   im = frame2im(frame);
   [imind, cm] = rgb2ind(im,256);
   if d == 1 
       imwrite(imind, cm, gifname, 'gif', 'Loopcount', inf); 
   else 
       imwrite(imind, cm, gifname, 'gif', 'WriteMode', 'append'); 
   end 

   % Save graph
   %saveas(gcf, ['outputs/mac_flip/flip_cross/_mac_cross_', ...
   %             model_type, '_coloue_', num2str(macbeth_col), ...
   %             '_depth_', num2str(mac_dep_cm), 'cm.png']);
      
end


