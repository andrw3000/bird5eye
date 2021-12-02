% Initialise the Macbeth structure array
depths = 0:25:350;
bmax = 212;
ncols = 25;

% Define a numeric array to store hcube data
macbeth = zeros(length(depths), ncols, bmax);
save('macbeth_exp.mat', 'macbeth');

%dname = sprintf('%03d', depth);
%dnum = find(depths==depth);