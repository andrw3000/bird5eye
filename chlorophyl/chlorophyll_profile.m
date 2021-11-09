function C = chlorophyll_profile(z, cp)
%  Gaussian chlorophyll profile based on work of Uitz et al (2006)

   C = cp.A - (cp.B .* z) + (cp.C ./ (cp.sigma .* sqrt(2 * pi))) .* ...
       exp(-0.5 .* ((z - cp.zmax).^2) ./ (cp.sigma.^2)); 

end