function pf = beta_eval(pf_type, p)

   pf = struct;

%  Psi coordinates
%  ---------------
   
%  Scattering angles, 8D [M(i), M(j), N(u), M0, M0, N0, N0, 2]
   [psi, Dmui0, Dmuj0] = beta_psi(p);
   
%  mu values, 4D [M(i), M(j), N(u), 2]
   Omi(:,1,1,1) = p.Om;
      Omi = repmat(Omi, [1, p.M, p.N, 2]);
   Omj(1,:,1,1) = p.Om;
      Omj = repmat(Omj, [p.M, 1, p.N, 2]);

   
%  Two volume scattering phase functions
%  -------------------------------------

%  Evaluate phase functions, 8D [M(i), M(j), N(u), M0, M0, N0, N0, 2]
   beta_w_sub = beta_water(psi);
   beta_r_sub = beta_water(psi);
   beta_p_sub = beta_particle(psi, pf_type);
   
%  Quad average to 4D [M(i), M(j), N(u), 2]
   beta_w_quad = (1 ./ Omi) .* (p.Dph ./ p.N0).^2 .* reshape( ...
                 sum(beta_w_sub .* Dmui0 .* Dmuj0, [4, 5, 6, 7]), ...
                                                   [p.M, p.M, p.N, 2]);
                                                
   beta_r_quad = (1 ./ Omi) .* (p.Dph ./ p.N0).^2 .* reshape( ...
                 sum(beta_r_sub .* Dmui0 .* Dmuj0, [4, 5, 6, 7]), ...
                                                   [p.M, p.M, p.N, 2]);
                                                
   beta_p_quad = (1 ./ Omi) .* (p.Dph ./ p.N0).^2 .* reshape( ...
                 sum(beta_p_sub .* Dmui0 .* Dmuj0, [4, 5, 6, 7]), ...
                                                   [p.M, p.M, p.N, 2]);
            
%  Isolate off-diagonal (non-forward scatter)
   beta_w_off = beta_w_quad;
   beta_r_off = beta_r_quad;
   beta_p_off = beta_p_quad;
   
   beta_w_off(:, :, 1, 1) = ~eye(p.M) .* beta_w_off(:, :, 1, 1);
   beta_r_off(:, :, 1, 1) = ~eye(p.M) .* beta_r_off(:, :, 1, 1);
   beta_p_off(:, :, 1, 1) = ~eye(p.M) .* beta_p_off(:, :, 1, 1);

%  Compute forward scatter terms [Mo, Ch. 8, p. 387] - note error in (8.14)
   beta_w_fwd = 1 - squeeze(sum((Omi ./ Omj) .* beta_w_off, [1, 3, 4]));
   beta_r_fwd = 1 - squeeze(sum((Omi ./ Omj) .* beta_r_off, [1, 3, 4]));
   beta_p_fwd = 1 - squeeze(sum((Omi ./ Omj) .* beta_p_off, [1, 3, 4]));
                           
   beta_w_on = zeros(p.M, p.M, p.N, 2);
   beta_w_on(:, :, 1, 1) = diag(beta_w_fwd);
   
   beta_r_on = zeros(p.M, p.M, p.N, 2);
   beta_r_on(:, :, 1, 1) = diag(beta_r_fwd);

   beta_p_on = zeros(p.M, p.M, p.N, 2);
   beta_p_on(:, :, 1, 1) = diag(beta_p_fwd);
   
%  Deduce total quad-averaged scattering function
   beta_w_tot = beta_w_on + beta_w_off;
   beta_r_tot = beta_r_on + beta_r_off;
   beta_p_tot = beta_p_on + beta_p_off;
   
%  Save for analysis
   pf.beta_w_tot = beta_w_tot;
   pf.beta_r_tot = beta_r_tot;
   pf.beta_p_tot = beta_p_tot;

   
%	Spectral Transform
%  ------------------

%  Negative exponential values, 5D [M(i), M(j), N(u), 2, NL]
   exN(1,1,:,1,:) = p.exN;
      exN = repmat(exN, [p.M, p.M, 1, 2, 1]);
   
%  Extend beta values along L, 5D [M(i), M(j), N(u), 2, NL]
   beta_w_L(:,:,:,:,1) = beta_w_tot;
      beta_w_L = repmat(beta_w_L, [1, 1, 1, 1, p.NL]);

   beta_r_L(:,:,:,:,1) = beta_r_tot;
      beta_r_L = repmat(beta_r_L, [1, 1, 1, 1, p.NL]);

   beta_p_L(:,:,:,:,1) = beta_p_tot;
      beta_p_L = repmat(beta_p_L, [1, 1, 1, 1, p.NL]);
      
%  Take Fourier transform
   beta_w_L = reshape(sum(exN .* beta_w_L, 3), [p.M, p.M, 2, p.NL]);
   beta_r_L = reshape(sum(exN .* beta_r_L, 3), [p.M, p.M, 2, p.NL]);
   beta_p_L = reshape(sum(exN .* beta_p_L, 3), [p.M, p.M, 2, p.NL]);
      
%  Spectral phase function grid, cell array, [2, NL], elts [M(i), M(j)]
   pf.beta_w = reshape(num2cell(beta_w_L, [1,2]), [2, p.NL]);
   pf.beta_r = reshape(num2cell(beta_r_L, [1,2]), [2, p.NL]);
   pf.beta_p = reshape(num2cell(beta_p_L, [1,2]), [2, p.NL]);
   
%  Resolution
   pf.M0 = p.M0;
   pf.N0 = p.N0;
   pf.M = p.M;
   pf.N = p.N;
   
end