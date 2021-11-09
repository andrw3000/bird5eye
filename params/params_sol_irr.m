function sol_irr = params_sol_irr(lam)
%  Solar irradiance import 
   
%  Data from Chance-Kurucz over 300-900nm
   load('data_input/sol_irr.mat', 'lam_raw_sol', 'irr_raw_sol');
   sol_irr = interp1(lam_raw_sol, irr_raw_sol, lam);

end