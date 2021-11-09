clear
close all

load('colour_chart.mat', 'wl', 'wl_mat', 'rgb_mat', 'rgb_cell');

nwl = length(wl);
load('solar_chance_kurucz_data.mat', 'ck_avg_data');
sol_irr = ck_avg_data;
tot_irr = sum(sol_irr);
fra_irr = sol_irr / tot_irr;

my_rgb = sum(rgb_mat, 1)/nwl;
sky_rgb = fra_irr' * rgb_mat;
x=1;

figure;
imagesc(x);
colormap(sky_rgb)
title('Sky irradiance colour mix')
xticks([]);
xticklabels({});
yticks([]);
yticklabels({});

figure;
imagesc(x);
colormap(my_rgb)
title('RGB colour mix')
xticks([]);
xticklabels({});
yticks([]);
yticklabels({});

%saveas(gcf,'_sky_irr_colour.png')

%plam = cell(nwl, 1);
%for i = 1:nwl
%   filename = ['_saved_params/_saved_params', num2str(wl(i)), 'nm.mat'];
%   load(filename, 'p')
%   plam{i,1} = p;
%   sky = sky_radiance(p);
%end
