close all

load('_data_input/aw_pope.mat', 'lam_pope', 'aw_pope');   
load('_data_input/aw_smith_baker.mat', 'lam_sb', 'aw_sb');   

lam_raw = lam_pope;
pope_raw = aw_pope;

spec = 400:700;
pope = interp1(lam_pope, aw_pope, spec, 'pchip');
sb = interp1(lam_sb, aw_sb, spec, 'pchip');


lam0_nm = 400;
beta90  = 3.63 * 1e-4;
bw = 16.06 * (lam0_nm ./ spec).^(4.322) * beta90;

figure;
plot(spec, pope, 'r', 'LineWidth', 1.5);
hold on
plot(spec, sb, 'b--', 'LineWidth', 1.5);
title('Absorption Coefficents for Pure Water');
ylabel('a_{w}, m^{-1}');
xlabel('Wavelength, nm');
legend({'Pope-Fry', 'Smith-Baker'}, 'Location', 'northwest');
saveas(gcf,'_aw_plot.png')

figure;
plot(spec, bw, 'b', 'LineWidth', 1.5);
title('Scattering Coefficent for Pure Water');
ylabel('b_{w}, m^{-1}');
xlabel('Wavelength, nm');
saveas(gcf,'_bw_plot.png')
