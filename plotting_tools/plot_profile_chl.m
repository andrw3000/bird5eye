close all

zed = 0:0.1:250;
ind100 = find(zed == 100);
dez = flip(zed);

S1      = chlorophyll_profile(zed, chlorophyll_params(1,0));
S2      = chlorophyll_profile(zed, chlorophyll_params(2,0));
S3      = chlorophyll_profile(zed, chlorophyll_params(3,0));
S4      = chlorophyll_profile(zed, chlorophyll_params(4,0));
S5      = chlorophyll_profile(zed, chlorophyll_params(5,0));
S6      = chlorophyll_profile(zed, chlorophyll_params(6,0));
S7      = chlorophyll_profile(zed, chlorophyll_params(7,0));
S8      = chlorophyll_profile(zed, chlorophyll_params(8,0));
S9      = chlorophyll_profile(zed, chlorophyll_params(9,0));

PhilIB  = chlorophyll_profile(zed, chlorophyll_params(0.5,1.2));
PhilII  = chlorophyll_profile(zed, chlorophyll_params(0.5,2));
PhilIII = chlorophyll_profile(zed, chlorophyll_params(0.5,3));

PlattCS = chlorophyll_profile(zed, chlorophyll_params(10,0));
PlattNE = chlorophyll_profile(zed, chlorophyll_params(11,0));


figure;
plot(S1, zed, 'LineWidth', 1.5);hold on
plot(S2, zed, 'LineWidth', 1.5);hold on
plot(S3, zed, 'LineWidth', 1.5);hold on
plot(S4, zed, 'LineWidth', 1.5);hold on
plot(S5, zed, 'LineWidth', 1.5);
xlim([0 0.4]);
set(gca, 'YDir','reverse')
title('Chlorophyll profiles for stratified water types S1-S5');
xlabel('Chl(z), mg/m^3');
ylabel('Depth z, m');
legend('S1', 'S2', 'S3', 'S4', 'S5', 'Location', 'southeast')
saveas(gcf,'_chl_plot_S1toS5.png')


figure;
plot(S5(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(S6(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(S7(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(S8(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(S9(1:ind100), zed(1:ind100), 'LineWidth', 1.5);
xlim([0 4]);
set(gca, 'YDir','reverse')
title('Chlorophyll profiles for stratified water types S5-S9');
xlabel('Chl(z), mg/m^3');
ylabel('Depth z, m');
legend('S5', 'S6', 'S7', 'S8', 'S9','Location', 'southeast');
saveas(gcf,'_chl_plot_S5toS9.png')

figure;
plot(S1, zed, 'LineWidth', 1.5);hold on
plot(S4, zed, 'LineWidth', 1.5);hold on
plot(S5, zed, 'LineWidth', 1.5);hold on
plot(PhilIB, zed, 'LineWidth', 1.5);hold on
plot(PhilII, zed, 'LineWidth', 1.5);
xlim([0 0.5]);
set(gca, 'YDir','reverse')
title({'Chlorophyll profiles for S1, S3, S4 vs. PIB, PII.', ...
       'Note the difference in Chl(z<15m) for S5 vs. PII.'});
xlabel('Chl(z), mg/m^3');
ylabel('Depth z, m');
legend('S1', 'S4', 'S5', 'PIB', 'PII', 'Location', 'southeast')
saveas(gcf,'_chl_plot_S1toPII.png')

figure;
plot(S6(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(S7(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(S8(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(PhilII(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(PhilIII(1:ind100), zed(1:ind100), 'LineWidth', 1.5);
xlim([0 1.5]);
set(gca, 'YDir','reverse')
title({'Chlorophyll profiles for S6-S8 vs. PII, PIII (only z<100m)', ...
       'Note the difference in Chl(z<15m) for S8 vs. PIII.'});
xlabel('Chl(z), mg/m^3');
ylabel('Depth z, m');
legend('S6', 'S7', 'S8', 'PII', 'PIII', 'Location', 'southeast');
saveas(gcf,'_chl_plot_S6toPIII.png')

figure;
plot(PlattCS(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(S9(1:ind100), zed(1:ind100), 'LineWidth', 1.5);hold on
plot(PhilIII(1:ind100), zed(1:ind100), 'LineWidth', 1.5);
xlim([0 7]);
set(gca, 'YDir','reverse')
title(['Chlorophyll profiles of Platt''s Green Celtic Sea, S9 and ', ...
       'PIII (only z<100m)']);
xlabel('Chl(z), mg/m^3');
ylabel('Depth z, m');
legend('Celtic Sea', 'S9', 'PIII', 'Location', 'southeast');
saveas(gcf,'_chl_plot_CS.png')

figure;
plot(PlattNE, zed, 'LineWidth', 1.5);hold on
plot(PhilII, zed, 'LineWidth', 1.5);hold on
plot(PhilIII, zed, 'LineWidth', 1.5);hold on
plot(S5, zed, 'LineWidth', 1.5);hold on
plot(S6, zed, 'LineWidth', 1.5);hold on
plot(PlattNE, zed, 'LineWidth', 1.5);
xlim([0 1.5]);
set(gca, 'YDir','reverse')
title('Chlorophyll profiles of Platt''s New England Seamount');
xlabel('Chl(z), mg/m^3');
ylabel('Depth z, m');
legend('New England Seamount', 'PII', 'PIII', 'S5', 'S6', ...
       'Location', 'southeast');
saveas(gcf,'_chl_plot_NE.png')
