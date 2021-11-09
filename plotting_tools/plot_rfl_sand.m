bandwidth = 10;
wavelengths_nm = 260:bandwidth:1200;
sand_refl = params_bottom(wavelengths_nm);

lam400 = find(wavelengths_nm == 400);
lam700 = find(wavelengths_nm == 700);

figure;
plt = plot(wavelengths_nm, sand_refl);
plt.Color = [0.9290 0.6940 0.1250].*0.8;
plt.LineWidth = 1.5;
plt.MarkerIndices = [lam400, lam700];
plt.MarkerFaceColor = 'b';
plt.MarkerEdgeColor = [0.9290 0.6940 0.1250].*0.7;
plt.Marker = 'o';


title({'Spectral reflectance of sand particals of order 450\mum', ...
       'due to Sun et. al. (2015)'})

%xlim([1 length(wavelengths_nm)]);
%xticks(1:2:length(wavelengths_nm));
%xticklabels(wavelengths_nm(1):(2 * bandwidth):wavelengths_nm(end));
xlabel('Wavelength (nm)');
%xlabel('Wavelength (nm)')
ylabel('Reflectance')

%ylim([0 0.4]);
         
%legend('Sand', 'Location', 'northwest');
saveas(gcf,'sand_refl_graph.png')
