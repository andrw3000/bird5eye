function bott = boundary_bottom(p)

   bott = struct;

%  Lambertian reflectance: quad-averaged distribution, [M(i), M(j), N(u)]
%  ----------------------------------------------------------------------
      
%  Quad volume j-dimension
   Omj(1,:,1) = p.Om;
      Omj = repmat(Omj, [p.M, 1, p.N]);
   
%  Quad average mu value on j-dimension
   mu_av(1,:,1) = p.mu_av;
      mu_av = repmat(mu_av, [p.M, 1, p.N]);
      
%  Quad averaged reflectance / irradiance reflectance R (p. 429 (8.109))
   Rbb_u = pi^(-1) .* mu_av .* Omj;
   
%  Spectral transform terms, [M(i), M(j), N(u), N(L)]
   Rbb_uL = repmat(Rbb_u, [1, 1, 1, p.NL]);
   exN(1,1,:,:) = p.exN;
      exN = repmat(exN, [p.M, p.M, 1, 1]);

%  Take Fourier transform
   Rbb_L = reshape(sum(Rbb_uL .* exN, 3), [p.M, p.M, p.NL]);
   
%  Lambertian spectral transform, [N(L), 1] cell array with [M, M] elements
   bott.rfl = reshape(num2cell(Rbb_L, [1,2]), [p.NL, 1]);

end