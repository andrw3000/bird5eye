% Plot colour matching functions
addpath([pwd, '/colours'])

% Wavelength bandwidths
band_min = 390;
band_max = 750;
bandwidth = 5;

% Compute spectrum
band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
bands = bandwidth_avg(spec, bandwidth, 1);
numb = length(bands);

% Colour system object
%cs = ColourSystem('srgb');



RGB = zeros(1, numb, 3);
for b = 1:numb
   %RGB(1, b, :) = cs.spec2rgb(bands(b), 1);
   RGB(1, b, :) = spectrumRGB(bands(b));
end
RGB = repmat(RGB, [numb, 1, 1]);

close all

% Bandwidth plot
figure;
imagesc(RGB);

bsep = 2*3;
xticks(1:bsep:length(bands));
xticklabels(bands(1:bsep:numb));
yticks([]);
xlabel('Band centres (nm)')
title(['Bandwidth spectrum to RGB with CIE human vision data; ', ...
        num2str(bandwidth), 'nm resolution'])

saveas(gcf, ['_bandwidth_res_', num2str(bandwidth), 'nm.png'])
