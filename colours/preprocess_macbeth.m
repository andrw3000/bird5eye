%%% Pre-process MacBeth data

tab = readtable('_data_raw/macbeth_data.xls', 'PreserveVariableNames', 1);
arr = table2array(tab);
wavelengths_raw = arr(:, 1);
macbeth_rfl_raw = cell(24, 1);

for col = 1:24
   macbeth_rfl_raw{col} = arr(:, col + 1);
end
   
% MacBeth RGB matrix (Copyright 2009, X­Rite Incorporated.)
macbeth_names = cell(24, 1);
macbeth_colours = cell(24, 1);

macbeth_names{1} = 'Dark Skin';
macbeth_colours{1} = [115, 82, 68];

macbeth_names{2} = 'Light Skin';
macbeth_colours{2} = [194, 150, 130];

macbeth_names{3} = 'Blue Sky';
macbeth_colours{3} = [98, 122, 157];

macbeth_names{4} = 'Foliage';
macbeth_colours{4} = [87, 108, 67];

macbeth_names{5} = 'Blue Flower';
macbeth_colours{5} = [133, 128, 177];

macbeth_names{6} = 'Bluish Green';
macbeth_colours{6} = [103, 189, 170];

macbeth_names{7} = 'Orange';
macbeth_colours{7} = [214, 126, 44];

macbeth_names{8} = 'Purplish Blue';
macbeth_colours{8} = [80, 91, 166];

macbeth_names{9} = 'Moderate Red';
macbeth_colours{9} = [193, 90, 99];

macbeth_names{10} = 'Purple';
macbeth_colours{10} = [94, 60, 108];

macbeth_names{11} = 'Yellow Green';
macbeth_colours{11} = [157, 188, 64];

macbeth_names{12} = 'Orange Yellow';
macbeth_colours{12} = [224, 163, 46];

macbeth_names{13} = 'Blue';
macbeth_colours{13} = [56, 61, 150];

macbeth_names{14} = 'Green';
macbeth_colours{14} = [70, 148, 73];

macbeth_names{15} = 'Red';
macbeth_colours{15} = [175, 54, 60];

macbeth_names{16} = 'Yellow';
macbeth_colours{16} = [231, 199, 31];

macbeth_names{17} = 'Magenta';
macbeth_colours{17} = [187, 86, 149];

macbeth_names{18} = 'Cyan';
macbeth_colours{18} = [8, 133, 161];

macbeth_names{19} = 'White (.05)';
macbeth_colours{19} = [243, 243, 242];

macbeth_names{20} = 'Neutral 8 (.23)';
macbeth_colours{20} = [200, 200, 200];

macbeth_names{21} = 'Neutral 6.5 (.44)';
macbeth_colours{21} = [160, 160, 160];

macbeth_names{22} = 'Neutral 5 (.70)';
macbeth_colours{22} = [122, 122, 121];

macbeth_names{23} = 'Neutral 3.5 (.1.05)';
macbeth_colours{23} = [85, 85, 85];

macbeth_names{24} = 'Black 8 (1.50)';
macbeth_colours{24} = [52, 52, 52];


save('_data_input/rfl_macbeth.mat', 'macbeth_names', ...
                                    'macbeth_colours', ...
                                    'wavelengths_raw', ...
                                    'macbeth_rfl_raw');
