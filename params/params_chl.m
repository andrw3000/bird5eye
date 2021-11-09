function [A, E, A440, E440, ac] = params_chl(lam)
%  Params defining chlorophyll absorption

   load('data_input/AE_coeffs.mat', 'AEmidUV')
   
   lamAE = AEmidUV(:,1);
   Amid = AEmidUV(:,2);
   Emid = AEmidUV(:,3);
   
   A = interp1(lamAE, Amid, lam);
   E = interp1(lamAE, Emid, lam);
   A440 = interp1(lamAE, Amid, 440);
   E440 = interp1(lamAE, Emid, 440);

%  Old model due to Prieur and Sathyendranath (1981)
   ac_spec = 400:10:700;
   ac_data = [0.687, 0.828, 0.913, 0.973, 1.000, 0.944, 0.917, 0.870, ...
              0.798, 0.750, 0.668, 0.618, 0.528, 0.474, 0.416, 0.357, ...
              0.294, 0.276, 0.291, 0.282, 0.236, 0.252, 0.276, 0.317, ...
              0.334, 0.356, 0.441, 0.595, 0.502, 0.329, 0.215];
           
   ac = interp1(ac_spec', ac_data', lam, 'pchip');
   
end