clear
close all

load('data_input/sol_irr.mat', 'ck_sol_irr');
lam_raw = lam_raw_sol;
irr_raw = irr_raw_sol;

figure;
plt=plot(lam_raw, irr_raw, ...
         'color', 'blue', 'LineWidth', 1);
hold on

ind350 = find(lam_raw == 350);
ind700 = find(lam_raw == 700);

pts = scatter([350, 700], [irr_raw(ind350), irr_raw(ind700)], '*r');
dx = -20;
dy350 = 0.5;
dy700 = 0.3;
text([lam_raw(ind350)+dx, lam_raw(ind700)+dx], ...
     [irr_raw(ind350)-dy350, irr_raw(ind700)-dy700], ...
     {'350nm', '700nm'}, 'Color', 'r');

title({'Spectral extra-terrestrial solar irradiance;', ...
       'results due to Chance-Kurucz (2010)'})
xlabel('Wavelength (nm)')
ylabel('Irradiance (W/m^2 nm)')
         
saveas(gcf,'sol_irradiance_graph.png')

update_file = 0;

if update_file == 1
   ind350 = find(lam_raw == 350);
   ind709 = find(lam_raw == 709);
   lam_snip = irr_tab(ind350:ind709, 1);
   irr_snip = irr_tab(ind350:ind709, 2);
   whole_wl_ind = find(rem(lam_snip, 1)==0);
   lam_snip = lam_snip(whole_wl_ind);
   irr_snip = irr_snip(whole_wl_ind);
   snip_len = length(lam_snip);
   lam_avg = reshape(lam_snip, [10, snip_len/10]);
   lam_ind = lam_avg(1,:);
   lam_avg = reshape(0.1 * sum(lam_avg, 1), [snip_len/10, 1]);
   lam_avg = round(lam_avg);
   irr_avg = reshape(irr_snip, [10, snip_len/10]);
   irr_avg = reshape(0.1 * sum(irr_avg, 1), [snip_len/10, 1]);
   save('data_sol_irr_chance_kurucz.mat', ...
        'ck_sol_irr', 'lam_ind', 'irr_avg');
end