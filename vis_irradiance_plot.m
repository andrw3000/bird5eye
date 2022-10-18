%--------------------------------------------------------------------------
%  bird5eye plot: irradiance reflectance
%  From a saved model, bird5plot plots the spectral irradiance reflectance
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

bandwidth = 10;  % Bandwidth resolution
macbeth_col = 19;  % Macbeth colour choice for botom boundary

model_name = ['spot_', model_type, '_', band_run, ...
              '_bwid', num2str(bandwidth), ...
              '_inel_', inel, ...
              '_', pf_type, '_pf', ...
              '_aw', aw_data, ...
              '_chl', chl_type, ...
              '_jerlov', jerlov, ...
              '_macbeth', num2str(macbeth_col)];
           
load(['saved_models/', model_name, '.mat'], 'bird', ...
                                            'band_names', ... 
                                            'bot_depths', ...
                                            'd0', ...
                                            'nsub', ....
                                            'obs', ...
                                            'pobs', ...
                                            'ud_ext', ...
                                            'ud_int');

bmin = 390;
bmax = 700;
bplot = bmin:10:bmax;
bnames = band_names(:);
binterp = bmin:1:bmax;
binterp = binterp(:);

for d = 1:(nsub + d0)

   figure;
   for ob = 1:pobs(d)
      hold on
      plotinterp = interp1(bnames, ud_int{d}(:,ob), binterp, 'pchip');

      plot(binterp, plotinterp, 'LineWidth', 1.5);

   end

   title({'Interior irradiance reflectances', ...
           ['Bottom depth located at ', num2str(bot_depths(d)), ...
            'm; bandwidths of ', num2str(bandwidth), 'nm'], ...
           ['Jerlov type ', jerlov, ...
            '; Chl type ''', chl_type, ...
            '''; Pure water abs ''', aw_data, ...
            '''; Inelastic scattering ''', inel, '''']});

   xlim([bplot(1) bplot(end)]);
   xticks(bplot);
   xlabs = num2cell(bplot);
   xlabs(2:2:end) = {[]};
   xticklabels(xlabs);
   xlabel('Wavelength (nm)');

   ylabel('E_{u}(z) / E_{d}(z)');
   if max(max(ud_int{d}(:,:))) < 0.07
      ymin = 0;
      ymax = 0.07;
      ydel = 0.0025;
      ylim([ymin ymax]);
      yticks(ymin:ydel:ymax);
      ylabs = num2cell(ymin:ydel:ymax);
      ylabs(2:4:end) = {[]};
      ylabs(3:4:end) = {[]};
      ylabs(4:4:end) = {[]};
      yticklabels(ylabs);
   end

   legend(num2str(obs(1:pobs(d)), 'z = %.0fm'), 'Location', 'northeast');

   plot_name = ['outputs/_intIR_', model_name, ...
                '_botdep_', num2str(round(bot_depths(d))), '.png'];

   if d == nsub + d0
      %saveas(gcf, plot_name)
   end

   hold off

end