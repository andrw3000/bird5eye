function [g_chl, h_chl, eta_cdom] = params_inel_fluo(lam1, lam2, W)
%  Params for inelastic scattering effects; lam2=lam' to lam1=lam

%  Chlorophyll excitation function (lam2)
   g_chl = (lam2 >= 370 & lam2 <= 690);

%  Chlorphyll emission function (lam1)
   C0 = sqrt(4 * log(2) / pi);
   G1 = exp(-4 * log(2) * ((lam1 - 685) ./ 25).^2);
   G2 = exp(-4 * log(2) * ((lam1 - 730) ./ 50).^2);
   h_chl = W .* (C0 / 25) .* G1 + (1 - W) .* (C0 / 50) .* G2;

%  A0 data from Hawes' table 3
   A0_spec = [  310,   330,   350,   370,  390, ...
                410,   430,   450,   470,  490];
   A0_data = [ 5.18,  6.34,  8.00,  9.89, 9.39, ...
              10.48, 12.59, 13.48, 13.61, 9.27] * 1e-5;
           
%  Extended as in 'New Case 1 IOP model'
   A0_spec = [250, A0_spec, 550, 600, 700 800, 900, 1000];
   A0_data = [0,   A0_data,   0,   0,   0,   0,   0,   0];
   
%  Hawes' data for lam2 = lam'
   A0 = interp1(A0_spec, A0_data, lam2);

%  Hawes' constants (table 3)
   A1 = 0.470;
   B1 = 8.077e-4;
   A2 = 0.407;
   B2 = -4.57e-4;
  
%  Quantum efficiency function eta(lam2, lam1) due to CDOM
   eta_cdom = A0 .* exp(-( ((1 ./ lam1) - (A1 ./ lam2) - B1) ./ ...
                           (0.6 .* ((A2 ./ lam2) + B2))         ).^2);
   
end