close all

psi = 0:0.01:pi;

beta_ff = beta_particle(psi, 'FF');
beta_ap = beta_particle(psi, 'AP');
beta_hg = beta_particle(psi, 'HG');
beta_w  = beta_water(psi);

figure;
%plot(psi, (beta_ff), 'r', 'LineWidth', 1.5);
%hold on
%plot(psi, (beta_ap), 'b', 'LineWidth', 1.5);
%hold on
%plot(psi, (beta_hg), 'g', 'LineWidth', 1.5);
%hold on
plot(psi, (beta_w), 'c', 'LineWidth', 1.5);

title('Linear-linear plot of the elastic scattering phase functions');
ylabel('\beta(\psi)');
xlabel('Scattering angle, \psi, rad');
%legend('Fournier-Fourand', 'Average Petzold', ...
%       'Henyey-Greenstein', 'Pure Water');
legend('Pure Water');
saveas(gcf,'_pf_lin_lin.png')

figure;
plot(psi, log10(beta_ff), 'r', 'LineWidth', 1.5);
hold on
plot(psi, log10(beta_ap), 'b', 'LineWidth', 1.5);
hold on
plot(psi, log10(beta_hg), 'g', 'LineWidth', 1.5);
hold on
plot(psi, log10(beta_w), 'c', 'LineWidth', 1.5);

title('Log-linear plot of the elastic scattering phase functions');
ylabel('log_{10}\beta(\psi)');
xlabel('Scattering angle, \psi, rad');
legend('Fournier-Fourand', 'Average Petzold', ...
       'Henyey-Greenstein', 'Pure Water');
saveas(gcf,'_pf_log_lin.png')

figure;
plot(log10(psi), log10(beta_ff), 'r', 'LineWidth', 1.5);
hold on
plot(log10(psi), log10(beta_ap), 'b', 'LineWidth', 1.5);
hold on
plot(log10(psi), log10(beta_hg), 'g', 'LineWidth', 1.5);
hold on
plot(log10(psi), log10(beta_w), 'c', 'LineWidth', 1.5);

title('Log-log plot of the elastic scattering phase functions');
ylabel('log_{10}\beta(\psi)');
xlabel('Logarithmic scattering angle, log_{10}\psi, log_{10}rad');
legend('Fournier-Fourand', 'Average Petzold', ...
       'Henyey-Greenstein', 'Pure Water');
saveas(gcf,'_pf_log_log.png')
