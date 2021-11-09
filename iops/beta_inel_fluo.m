function beta = beta_inel_fluo(z, p)
%  Inelastic volume scattering function, see:
%  https://www.oceanopticsbook.info/view/scattering/level-2/...
%                                            chlorophyll-fluorescence
%                                        &   cdom-fluorescence
%  Scattering describes transfer from lam2=lam' (cols) to lam1 = lam (rows)

   
%  Chlorophyll fluorescence scattering coeffcient (lam2=lam')
   b_chl = kron(ones(length(p.lam), 1), a_chl(z, p).');
   
%  Total inelastic chlorophyll scattering coefficient
   beta_chl = b_chl .* p.phi_chl .* p.g_chl .* p.h_chl .* ...
              p.lam2 ./ (p.lam1 .* 4 .* pi);
            
%  Inelastic scattering coefficient due to CDOM (lam2)
   b_cdom = kron(ones(length(p.lam), 1), a_cdom(z, p).');

%  Total inelastic scattering coefficient due to CDOM
   beta_cdom = b_cdom .* p.eta_cdom .* p.lam2 ./ (p.lam1 .* 4 .* pi);
   
%  Sum total of the fluorescing scattering coefficients
   beta = beta_chl + beta_cdom;
  
end