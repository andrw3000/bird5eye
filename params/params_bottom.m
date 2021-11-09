function bot_rfl = params_bottom(lam)
%  Bottom reflectance import
   
%  Bottom reflectance of sandy bottom (raw data over 250-1200nm)
   load('data_input/rfl_sand.mat', 'lam_sand', 'rfl_sand');
   bot_rfl = interp1(lam_sand, rfl_sand, lam);

end