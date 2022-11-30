%%% Plotting Macbeth Colour Pallets

% Import MacBeth data
load('data_input/rfl_macbeth.mat', 'macbeth_names', ...
                                   'macbeth_colours', ...
                                   'wavelengths_raw', ...
                                   'macbeth_rfl_raw');

% Wavelength bandwidths
band_min = 390;
band_max = 750;
bandwidth = 10;

% Compute spectrum
band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
numb = length(bands);

nsubbs = round(bandwidth/5);  % Sample every 5nm
subspec = (spec(1):(bandwidth/nsubbs):spec(end));
subspec = subspec(:);

% Construction of tiled pallets
s = 7;   % Square side length
e = 2;   % Edge width
g = 1;   % Gap width

base   = (2 * e) + (5 * g) + (6 * s);
height = (2 * e) + (3 * g) + (4 * s);

pallet_ref = zeros(height, base, 3); % Background colour is black
pallet_rfl = zeros(height, base, 3);

% Colour the pallet tiles
for sq = 1:24
   
   i = ceil(sq/6);
   j = 1 + mod(sq-1, 6);
   pallet_ref = colour_sq(i, j, macbeth_colours{sq}, pallet_ref, s, e, g);

end


% Plot reference pallet
close all
figure;
imagesc(pallet_ref);
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.DataAspectRatioMode = 'manual';
ax.Title.String = 'Manufacturer Prescribed MacBeth Pallet';
ax.Title.FontSize = 13;
hold on

% Legend names and dummy plot
lgd_names = cell(24,1);
for sq = 1:24
   
   lgd_names{sq} = [num2str(sq), '. ', macbeth_names{sq}];
   
   i = ceil(sq/6);
   j = 1 + mod(sq-1, 6);
   [m, n] = corner_sq(i, j, s, e, g);
   scatter(n, m, 'MarkerEdgeColor', macbeth_colours{sq}/255, ...
                 'MarkerFaceColor', macbeth_colours{sq}/255);
   hold on
   
end

%lgd_names{25} = '*Copyright 2009, X­Rite Incorporated.';
%scatter(1, 1, 'MarkerEdgeColor', 'k');

legend(lgd_names, 'FontSize', 10, 'Location', 'eastoutside');

%cr = '*Copyright 2009, X­Rite Incorporated.';
%annotation('textbox', [.01, .2, .2, 0], 'String', cr);%, 'FitBoxToText', 'on');

% Number the tiles
for sq = 1:24
   [i, j] = centre_sq(ceil(sq/6), 1+mod(sq-1, 6), s, e, g);
   t = text(j, i, num2str(sq));
   t.FontSize = 14;
   t.HorizontalAlignment = 'center';
   t.FontWeight = 'normal';
   if sq < 19 || sq > 20
      t.Color = [1, 1, 1];
   end
end

% Save graph
saveas(gcf, '_macbeth_pallet_ref.png')
%saveas(gcf, ['_macbeth_pallet_', num2str(bandwidth), 'nm.png'])



function pallet = colour_sq(i, j, RGB, pallet, side, edge, gap)

   m1 = edge + ((i-1) * gap) + ((i-1) * side) + 1;
   m2 = edge + ((i-1) * gap) + (i * side);
   n1 = edge + ((j-1) * gap) + ((j-1) * side) + 1;
   n2 = edge + ((j-1) * gap) + (j * side);
   
   pallet(m1:m2, n1:n2, 1) = RGB(1) / 255;  % Red
   pallet(m1:m2, n1:n2, 2) = RGB(2) / 255;  % Green
   pallet(m1:m2, n1:n2, 3) = RGB(3) / 255;  % Blue
   
end

function [m, n] = centre_sq(i, j, side, edge, gap)

   m = edge + (i-1) * gap + (i-1) * side + ceil(side/2);
   n = edge + (j-1) * gap + (j-1) * side + ceil(side/2);
   
end

function [m, n] = corner_sq(i, j, side, edge, gap)

   m = edge + (i-1) * gap + (i-1) * side + 1;
   n = edge + (j-1) * gap + (j-1) * side + 1;
   
end