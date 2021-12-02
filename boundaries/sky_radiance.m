function sky = sky_radiance(sol, p)
%  Returns a structure 'sky' containing the sky radiance L^+(-ep) as a
%  function of atmorpheric conditions based on N. Igawa et al. (2004)


%  Solar position
%  --------------

%  Change variables from zenith to altitude
   sol_alt = pi/2 - sol.zen;
   

%  Sky Radiance Model
%  ------------------

%  Sky Index
   sky_ind = p.clear_sky_index + p.cloudless_index^(0.5);

%  Coefficients
   a0 = 4.5 / (1 + 0.15 * exp(3.4 * sky_ind)) - 1.04;
   b0 = -1 / (1 + 0.17 * exp(1.3 * sky_ind)) - 0.05;
   c0 = 1.77 * (1.22 * sky_ind)^(3.56) * exp(0.2 * sky_ind) * (2.1 - ...
      sky_ind)^(0.8);
   d0 = -3.05 / (1 + 10.6 * exp(-3.4 * sky_ind));
   e0 = 0.48 / (1+ 245 * exp(-4.13 * sky_ind));


%  Subquad computation grid
%  ------------------------

%  Subquad grid, 4D [M(i), N(u), M0, N0]
   [th0, ph0, i0, u0] = ndgrid(p.th0, p.ph0, p.i0, p.u0);
   
%  Subquad centres, 4D [M(i), N(u), M0, N0]
   th0 = th0 + (i0 - (1/2)) .* p.Dth ./ p.M0;
   ph0 = ph0 + (u0 - (1/2)) .* p.Dph ./ p.N0;
   
%  Subquad volumes
   Dmu0 = cos(th0 - p.Dth/(2*p.M0)) - cos(th0 + p.Dth/(2*p.M0));
   Om0 = Dmu0 * p.Dph/p.N0;
   
%  zeta grid, 4D [M, N, M0, N0]
   zeta = acos(sin(sol_alt) .* sin(th0) + cos(sol_alt) .* ...
               cos(th0) .* cos(sol.azi - ph0));

%  Gradation, 4D [M, N, M0, N0]
   grad_th0 = 1 + a0 .* exp(b0 ./ sin(th0));
   grad_cnst = 1 + a0 .* exp(b0 ./ sin(pi/2));
   
%  Scattering indicatrix, 4D [M, N, M0, N0]
   indi_zeta = 1 + c0 .* (exp(d0 .* zeta) - exp(d0 .* pi/2)) + ...
      e0 .* (cos(zeta)).^2;
   indi_zenith = 1 + c0 .* (exp(d0 .* sol.zen) - exp(d0 .* pi/2)) + ...
      e0 .* (cos(sol.zen)).^2;
   
%  Relative sky radiance: radiance / zenith radiance
   rel_sky_rad = (grad_th0 .* indi_zeta) ./ (grad_cnst .* indi_zenith);

%  Specular sky rad
   %rel_sky_rad = th0 < 0.17;
   
   
%  Quad averaging and irradiance
%  -----------------------------

%  Irradiance volumes, 2D [M(i), N(u)]
   Omi(:,1) = p.Om;
      Omi = repmat(Omi, [1, p.N]);

%  Irradiance average mu value, 2D [M(i), N(u)]
   mui(:,1) = p.mu_av;
      mui = repmat(mui, [1, p.N]);
      
%  Quad averaged radiance, 2D [M, N] (integration over subquads)
   rel_sky_radu = (1 ./ Omi) .* squeeze(sum(Om0 .* rel_sky_rad, [3, 4]));
   
%  Relative solar irradiance
   rel_sky_irr = squeeze(sum(rel_sky_radu .* mui .* Omi, [1,2]));
   
   
%  Normalised sky radiance (so that rel_sky_irr = 1)
   sky_radu = (1 / rel_sky_irr) .* rel_sky_radu;
   
%  Spectral transform of sky radiance
%  ----------------------------------

%  Negative exponential values, 3D [M, N(u), N(L)]
   exN3(1,:,:) = p.exN;
      exN3 = repmat(exN3, [p.M, 1, 1]);
      
%  Stretch sky_radu over L, 3D [M, N(u), N(L)]
   sky_raduL(:,:,1) = sky_radu;
      sky_raduL = repmat(sky_raduL, [1, 1, p.NL]);
      
%  Spectral sky radiance, 2D [M, NL]
   sky_radL = reshape(sum(exN3 .* sky_raduL, 2), [p.M, p.NL]);
      
%  Arranged into [NL, 1] cell array with [M, 1] entries
   sky_radL = reshape(num2cell(sky_radL, 1), [p.NL, 1]);

%  Output
%  ------

   sky = struct;
   sky.rad = sky_radL;
   sky.radu = sky_radu;
   
end
