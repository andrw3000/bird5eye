clear
close all

load('data_input/sol_irr.mat', 'lam_raw_sol', 'irr_raw_sol');
lam_raw = lam_raw_sol;
irr_raw = irr_raw_sol;

B0 = 2;
bwid = 10;
spec = 395:(bwid/B0):705;
bnam = bandwidth_avg(spec, bwid, B0);
solirr = bandwidth_avg(params_sol_irr(spec), bwid, B0);

laminterp = 400:1:700;
laminterp = laminterp(:);
solinterp = interp1(bnam, solirr, laminterp, 'pchip');

figure;
plot(laminterp, solinterp, 'color', 'b', 'LineWidth', 1.5);
hold on
bind = bnam < 440;
solbeer = solirr;
solbeer(bind) = solbeer(bind) * 2/1.6;
solbinterp = interp1(bnam, solbeer, laminterp, 'pchip');
plot(laminterp, solbinterp, 'color', 'g', 'LineWidth', 1.5);


title({'Spectral extra-terrestrial solar irradiance;', ...
       'results due to Chance-Kurucz (2010)'})
xlabel('Wavelength (nm)')
ylabel('Irradiance (W/m^2 nm)')
         
%saveas(gcf,'sol_irradiance_graph.png')
