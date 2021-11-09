%%% Pre-process PR colour data

tab = readtable('_data_raw/pr_colours.txt', 'PreserveVariableNames', 1);
arr = table2array(tab);
colour_names = tab.Properties.VariableNames(2:end);
colour_names = colour_names(:);
wavelengths_raw = arr(:, 1);
pr_rfl_raw = cell(6, 1);

for col = 1:6
   pr_rfl_raw{col} = arr(:, col + 1) / 100;
end

save('_data_input/rfl_pr_colours.mat', 'wavelengths_raw', ...
                                       'colour_names', ...
                                       'pr_rfl_raw');
