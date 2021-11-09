function beta = beta_raman(psi)
%  Due to Ge et. al. (1993)
%  See Kattawar and Xu (1992) for discussion on polarisation effects

%  Normalised phase function
   beta = 0.068 * (1 + 0.53 .* cos(psi).^2);
   
end