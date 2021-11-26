% Script to load hcubes

% wl(212) = 740.9270 nm
% wl(1)   = 399.0100 nm
% wl(212) - wl(1) / 212 = 1.6128 nm

close all
clear
root_dir = '/Users/Holmes/Programmes/joe5data/';
addpath(root_dir)
addpath([root_dir, 'hcubes/'])

% Identify file
depth = 350;
dname = sprintf('%03d', depth);
rdat = ['raw_', dname, '.dat'];
rhdr = ['raw_', dname, '.hdr'];
hcube = hypercube(rdat,rhdr);

% Band indexes
bmax = 212;
bRGB = [45, 94, 156];

% Crop hcube
spec = hcube.Wavelength(1:bmax);
hcrop = hypercube(hcube.DataCube(:, 1:650, 1:bmax), spec).DataCube;
%hyperspectralViewer(hcrop)

% Print RGB image
slice = hcrop(:, :, bRGB)*10;
plot = imagesc(slice);
datacursormode on
imwrite(slice, [root_dir, 'rgbs/', 'img_', dname, '.png'])
