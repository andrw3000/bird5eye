%--------------------------------------------------------------------------
%  bird5eye: a `bird's-eye' view simulation
%--------------------------------------------------------------------------

function bird = bird5eye(depths, spec, jerlov, pf_type, chl_type, ...
                         aw_data, num_sub_bands, inel, model_type, mbcol)

%  Deactivate comments
   comment = 1;
   if length(spec) < 3; comment = 0; end

%  Bottom reflectance colour (0 = sand, 1, ..., 24 = MacBeth)
   bc = 21;

%--------------------------------------------------------------------------
%  Entrance: Compute Parameters
%--------------------------------------------------------------------------

%  Add necessary dependancies to path
   addpath('boundaries')
   addpath('chlorophyl')
   addpath('iops')
   addpath('params')

%  Load/compute/save parameters

   if comment == 1; fprintf('\n(*) Importing parameters'); end
   
   p = params_main();
   geo = params_geoloc();
   sol = solar_position(geo);
   sky = sky_radiance(sol, p);
   bott = boundary_bottom(p);
   
   if comment == 1; fprintf(' [Complete]\n'); end

%  Is there daylight?
   if sol.night == 0
      
      if comment == 1
         fprintf('\n     - There is daylight')
         fprintf(['\n     - Solar coordinates are ', ...
                  '(zenith, azimuth) = (%.1f, %.1f) degrees\n'], ...
                  sol.zen*180/pi, sol.azi*180/pi)
      end
      
   elseif sol.night == 1
      fprintf('\nThe sun has set. Come back tomorrow.\n')
      return
      
   end
   
   param_file = ['saved_params/_M', num2str(p.M), '_N', num2str(p.N), ...
                 '_', pf_type, '_pf.mat'];
                
   if exist(param_file, 'file') == 2
      if comment == 1
         fprintf('\n(*) Loading surface and scattering phase function')
      end
      load(param_file, 'surf', 'pf');
      if comment == 1; fprintf(' [Complete]\n'); end
      
   else
      t0 = tic;
      fprintf('\n(*) Integrating surface and scattering phase function')
      surf = boundary_surface(p);
      pf = beta_eval(pf_type, p);
      save(param_file, 'surf', 'pf')
      t1 = toc(t0);
      t1m = floor(round(t1) / 60);
      t1s = mod(round(t1), 60);
      if t1m > 0
         fprintf(' [Completed in %dm%ds]\n', t1m, t1s)
      else
         fprintf(' [Completed in %ds]\n', t1s)
      end

   end

   
%  Comment enabler
   p.comment = comment;

%  Pure water enabler
   p.particle = ~strcmpi(jerlov, 'PW');
   
%  Inelastic scattering enabler (chlorophyll excitation between 370-690)
   p.inel_off = strcmpi(inel, 'off');
   
%  Identify Raman inelastic scattering
   p.raman = strcmpi(inel, 'Raman') | strcmpi(inel, 'All');

%  Identify chl and cdom fluoresence
   p.fluo = strcmpi(inel, 'fluo') | strcmpi(inel, 'All');
   
%  Identify old model
   p.old_model = strcmpi(model_type, 'old');

%  Ocean or costal water
   p.costal_on = contains(jerlov, 'C', 'IgnoreCase', true);
   
   
%--------------------------------------------------------------------------
%  Doormat: Wavelength dependant parameters
%--------------------------------------------------------------------------

   if comment == 1
      fprintf('\n(*) Computing wavelength-dependant parameters')
   end
   
%  Full bandwidth
   p.bwid = spec(2) - spec(1);

%  Number B and B0 of wavelength and bands and sub-bands
   p.B = length(spec) - 1;
   p.B0 = num_sub_bands;
   p.BM = p.B * p.M;

%  Definition of sub-specturm, [B0*B+1, 1]
   p.lam = (spec(1):(p.bwid/p.B0):spec(end));
   p.lam = p.lam(:);

   if ~p.inel_off

%     Lambda matrices [B*B0+1, B*B0+1]; scatter from lam2=lam' to lam1=lam
      [p.lam1, p.lam2] = ndgrid(p.lam, p.lam);
      
   end
   
   if p.particle
      
%     Chlorophyll parameters
      p.chl_params = chlorophyll_select(chl_type, jerlov);

%     Chlorophyl absorption parameters; also contains 'AEhighUV', 'AElowUV'
      [p.A, p.E, p.A440, p.E440, ~] = params_chl(p.lam);
      
      if p.old_model

         [~, ~, ~, ~, p.ac] = params_chl(p.lam);

%        Old model parameters for a_chl at 440
         if strcmpi(jerlov, 'IB')
            p.a440 = 0.04;
         elseif strcmpi(jerlov, 'II')
            p.a440 = 0.06;
         elseif strcmpi(jerlov, 'III')
            p.a440 = 0.09;
         else
            p.a440 = 0.15;
         end         

%     CDOM absorption parameters
      p.M_cdom = 0.2;         % 0.2
      p.alpha = 0.014;   % 0.014
         
%     Constant by Jerlov type
      %[p.M_cdom, p.alpha_cdom] = params_cdom(jerlov);
      end

%     Chlorophyll and CDOM inelastic parameters
      if p.fluo
         [p.g_chl, p.h_chl, p.eta_cdom] = params_inel(p.lam1, p.lam2, p.W);
      end
      
   end

 
%  Depth indep Ricatti IOPs
%  ------------------------

%  Pure water absorption coefficients, [B, B]
   p.aw = diag(bandwidth_avg(a_water(p.lam, aw_data), p.bwid, p.B0));

%  Pure water scattering coefficients, [B, B]
   p.bw = diag(bandwidth_avg(b_water(p.lam), p.bwid, p.B0));
   
%  Pure water attenuation [B, B]
   p.cw = p.aw + p.bw;

   if p.raman
      
%     Raman scattering coefficient with wavelength redistribution, [B, B]
      p.br = bandwidth_avg(b_raman(p.lam1, p.lam2), p.bwid, p.B0);
      
   end

%  mu inverses varying along i, [M, M]
   p.mui_inv = kron(p.mu_av.^(-1), ones(1, p.M));
   p.mui_inv_diag = p.mui_inv .* eye(p.M);

%  Inelastic quad average and mui_inv normalisation
   p.mui_inv_Omj = kron(p.mu_av.^(-1), p.Om.');

%  Pure water transfer matrices and scattering functions
   p.beta_w = cell(2, p.NL);  % Pure water
   p.beta_r = cell(2, p.NL);  % Raman
   p.beta_p = cell(2, p.NL);  % Particle
   p.tau_w = cell(p.NL, 1);   % Pure water
   p.rho_w = cell(p.NL, 1);   % Pure water
   p.tau_r = cell(p.NL, 1);   % Raman
   p.rho_r = cell(p.NL, 1);   % Raman
   
   for L = 1:p.NL
      
      for sgn = 1:2
      
%        Normalised (phase) scattering function for pure water [M, M]
         p.beta_w{sgn, L} = p.mui_inv .* pf.beta_w{sgn, L};

%        Normalised (phase) inelastic Raman scattering function [M, M]
         p.beta_r{sgn, L} = p.mui_inv .* pf.beta_r{sgn, L};

%        Normalised (phase) particle scattering function [M, M]
         p.beta_p{sgn, L} = p.mui_inv .* pf.beta_p{sgn, L};
      
      end
      
%     Pure water transfer matrices
      p.tau_w{L} = kron(p.beta_w{1, L}, p.bw) - kron(p.mui_inv_diag, p.cw);
      p.rho_w{L} = kron(p.beta_w{2, L}, p.bw);

      if p.raman
         
%        Raman inelastic scattering transfer matrices [BM, BM]
         p.tau_r{L} = kron(p.beta_r{1, L}, p.br);
         p.rho_r{L} = kron(p.beta_r{2, L}, p.br);

      end
      
   end
   
%  Boundary conditions (bott, surf, sky)
%  -------------------------------------

%  Bottom reflectance, band averaged [B, 1] to geometric Rbb, [BM, BM]
   if bc == 0
      bottom_rfl = bandwidth_avg(params_bottom(p.lam), p.bwid, p.B0);
   else
      bottom_rfl = bandwidth_avg(params_macbeth(p.lam, bc), p.bwid, p.B0);
   end

%  MacBeth reflectance (pre-band averaged)/RGB reference/labels; cell(24,1)
   macbeth_rfl = bandwidth_avg(params_macbeth(p.lam, mbcol), p.bwid, p.B0);

%  Bottom boundaries
   bott.Rmb = cell(p.NL, 1); 
   bott.Rbb = cell(p.NL, 1); 
   for L = 1:p.NL
      bott.Rmb{L} = kron(bott.rfl{L}, diag(macbeth_rfl));
      bott.Rbb{L} = kron(bott.rfl{L}, diag(bottom_rfl));

   end

%  Expand surf matrices from [M, M] to [BM, BM]; a \mapsto a*eye(B)
   for L = 1:p.NL
      surf.Rab{L} = kron(surf.Rab{L}, eye(p.B));
      surf.Rba{L} = kron(surf.Rba{L}, eye(p.B));
      surf.Tab{L} = kron(surf.Tab{L}, eye(p.B));
      surf.Tba{L} = kron(surf.Tba{L}, eye(p.B));
   end
   
%  Solar irradiance, band averaged [B, 1]
   %solirr = bandwidth_avg(params_sol_irr(p.lam), p.bwid, p.B0);
   solirr = ones(p.B, 1);
   solirr = solirr(:);

%  Modified solar irradiance
   %bnam = bandwidth_avg(p.lam, p.bwid, p.B0);
   %bind = bnam < 445;
   %solirr(bind) = solirr(bind) * 2/1.6;
   %solirr = 4*ones(size(bnam));
   
%  Sky radiance, [BM, 1] for each L
   for L = 1:p.NL
      sky.rad{L} = kron(sky.rad{L}, solirr);
   end
   
   if comment == 1; fprintf(' [Complete]\n'); end

   
%--------------------------------------------------------------------------
%  Basement: Depth Computations
%--------------------------------------------------------------------------

   if comment == 1
      fprintf('\n(*) Arranging observation and bottom depths');
   end
   
%  Depth specifications (unique, ordered column vectors)
   bot_depths = unique(depths{1}(:));
   obs_depths = unique(depths{2}(:));

%  Bottom depth columns
   d0 = (bot_depths(1) == 0);
   subs = bot_depths((1+d0):end);
   ends = [0; subs];
   nsubs = length(subs);
   ndeps = nsubs + d0;
   
%  Arrange bottom reflectance
   ncol = 2;
   Rbb = repmat({bott.Rmb}, [ndeps, 1]);  % All depths from MacBeth pallet
   Rbb{ndeps} = bott.Rbb;                 % Final depth is sand
   
%  Model the above water reflectance
   Rdry = cell(ncol, 1);
   Rdry{1} = bott.Rmb;     % MacBeth colour
   Rdry{2} = bott.Rbb;     % Sand colour
   
%  Ensure observations don't excede max(bot_depths) and include zero
   obs = obs_depths(obs_depths < max(bot_depths));
   if all(obs_depths)
      obs = [0; obs_depths];
   end
   nobs = length(obs);

%  Locate permissible and bounded observations for each depth
   bobs = cell(nsubs, 1);   % Bounded: additionally not less than ends(d)
   pobs = NaN(nsubs, 1);    % Permissible: not exceeding subs(d)

   for i = 1:nsubs
      bobs{i} = obs(obs < subs(i));
      pobs(i) = length(bobs{i});
      bobs{i} = bobs{i}(bobs{i} >= ends(i));
   end

   p0 = NaN(ndeps, 1);
   p0((d0+1):end) = pobs;
   if d0
      p0(1) = 1;
   end
   
   if comment == 1
      fprintf(' [Complete]\n');
      fprintf('\n     - Number of linear observation points: %d', nobs)
      fprintf('\n     - Number of submurged bottom depths: %d\n', nsubs)
   end
   
%--------------------------------------------------------------------------
%  First floor: Integrate Ricatti equations 
%--------------------------------------------------------------------------

	rsol = cell(nsubs, 1);
   robs = cell(nsubs, 1);

   for d = 1:nsubs
      
      if comment == 1
         fprintf(['\n(*) Running ''ricatti_solver'' for L = 1, ..., ', ...
                  '%d times over interval %d of %d:\n'], p.NL, d, nsubs)
      end
      
      [rsol{d}, robs{d}] = ricatti_solver(ends(d), ends(d+1), bobs{d}, p);
      
   end        

   
%--------------------------------------------------------------------------
%  First floor: Complete the bulk solution via invariant imbedding
%--------------------------------------------------------------------------

   if comment == 1
      fprintf('\n(*) Completing the bulk solution');
      t0bulk = tic;
   end

%  Structure to store bulk transfer functions
   bulk = struct('Tab', cell(nsubs, 2, nobs), ...
                 'Rba', cell(nsubs, 2, nobs), ...
                 'Sab', cell(nsubs, 2, nobs), ...
                 'Tba', cell(nsubs, 2, nobs), ...
                 'Rab', cell(nsubs, 2, nobs), ...
                 'Sba', cell(nsubs, 2, nobs));
   
%  Store L-Fourier coefficients
   for i  = 1:nsubs
   for ud = 1:2
   for ob = 1:nobs
      bulk(i, ud, ob).Tab = cell(p.NL, 1);
      bulk(i, ud, ob).Rba = cell(p.NL, 1);
      bulk(i, ud, ob).Sab = cell(p.NL, 1);
      bulk(i, ud, ob).Tba = cell(p.NL, 1);
      bulk(i, ud, ob).Rab = cell(p.NL, 1);
      bulk(i, ud, ob).Sba = cell(p.NL, 1);
   end
   end
   end
      
   
%  Indicator flips from down (2) to up (1) after (ob==bob{i}) identified
   du = 2 * ones(nobs);
      
%  Compute bulk solution
   for ob = 1:nobs

%     i = 1
      bob = (obs(ob) == bobs{1});
      if any(bob)
               
%        Terminate the downwelling solution
         bulk(1, du(ob), ob) = robs{1}(du(ob), bob);

%        Initiate the upwelling solution
         du(ob) = 1;
         bulk(1, du(ob), ob) = robs{1}(du(ob), bob);
            
      else
            
%        Append the full bulk solution to du(ob)
         bulk(1, du(ob), ob) = rsol{1};
         
      end


%     i > 1
      for i = 2:nsubs

         bob = (obs(ob) == bobs{i});
         if any(bob)

            for L = 1:p.NL

%              Terminate the downwelling solution
%              ----------------------------------
                  
%              Downwelling geometric series
               dwgs = (eye(p.BM) - bulk(i-1, du(ob), ob).Rba{L} * ...
                                   robs{i}(du(ob), bob).Rab{L})^(-1);

%              Upwelling geometric series
               upgs = (eye(p.BM) - robs{i}(du(ob), bob).Rab{L} * ...
                                   bulk(i-1, du(ob), ob).Rba{L})^(-1);

%              T(a,b)
               bulk(i, du(ob), ob).Tab{L} = ...
                  robs{i}(du(ob), bob).Tab{L} * dwgs * ...
                  bulk(i-1, du(ob), ob).Tab{L};

%              R(b,a)
               bulk(i, du(ob), ob).Rba{L} = ...
                  robs{i}(du(ob), bob).Tab{L} * dwgs * ...
                  bulk(i-1, du(ob), ob).Rba{L} * ...
                  robs{i}(du(ob), bob).Tba{L} + ...
                  robs{i}(du(ob), bob).Rba{L};

%              S(a,b)
               bulk(i, du(ob), ob).Sab{L} = ...
                  robs{i}(du(ob), bob).Tab{L} * dwgs * ...
                  (bulk(i-1, du(ob), ob).Rba{L} * ...
                   robs{i}(du(ob), bob).Sba{L} + ...
                   bulk(i-1, du(ob), ob).Sab{L}) + ...
                  robs{i}(du(ob), bob).Sab{L};

%              R(a,b)
               bulk(i, du(ob), ob).Rab{L} = ...
                  bulk(i-1, du(ob), ob).Tba{L} * upgs * ...
                  robs{i}(du(ob), bob).Rab{L} * ...
                  bulk(i-1, du(ob), ob).Tab{L} + ...
                  bulk(i-1, du(ob), ob).Rab{L};

%              T(b,a)
               bulk(i, du(ob), ob).Tba{L} = ...
                  bulk(i-1, du(ob), ob).Tba{L} * upgs * ...
                  robs{i}(du(ob), bob).Tba{L};

%              S(b,a)
               bulk(i, du(ob), ob).Sba{L} = ...
                  bulk(i-1, du(ob), ob).Tba{L} * upgs * ...
                  (robs{i}(du(ob), bob).Rab{L} * ...
                   bulk(i-1, du(ob), ob).Sab{L} + ...
                   robs{i}(du(ob), bob).Sba{L}) + ...
                  bulk(i-1, du(ob), ob).Sba{L};

            end
            
%           Initiate the upwelling solution
            du(ob) = 1;
            bulk(i, du(ob), ob) = robs{i}(du(ob), bob);
               
         else
            
            for L = 1:p.NL
               
%              Append the full bulk solution to du(ob)
%              ---------------------------------------

%              Downwelling geometric series
               dwgs = (eye(p.BM) - bulk(i-1, du(ob), ob).Rba{L} * ...
                                   rsol{i}.Rab{L})^(-1);

%              Upwelling geometric series
               upgs = (eye(p.BM) - rsol{i}.Rab{L} * ...
                                   bulk(i-1, du(ob), ob).Rba{L})^(-1);

%              T(a,b)
               bulk(i, du(ob), ob).Tab{L} = ...
                  rsol{i}.Tab{L} * dwgs * ...
                  bulk(i-1, du(ob), ob).Tab{L};

%              R(b,a)
               bulk(i, du(ob), ob).Rba{L} = ...
                  rsol{i}.Tab{L} * dwgs * ...
                  bulk(i-1, du(ob), ob).Rba{L} * ...
                  rsol{i}.Tba{L} + ...
                  rsol{i}.Rba{L};

%              S(a,b)
               bulk(i, du(ob), ob).Sab{L} = ...
                  rsol{i}.Tab{L} * dwgs * ...
                  (bulk(i-1, du(ob), ob).Rba{L} * ...
                    rsol{i}.Sba{L} + ...
                    bulk(i-1, du(ob), ob).Sab{L}) + ...
                  rsol{i}.Sab{L};

%              R(a,b)
               bulk(i, du(ob), ob).Rab{L} = ...
                  bulk(i-1, du(ob), ob).Tba{L} * upgs * ...
                  rsol{i}.Rab{L} * ...
                  bulk(i-1, du(ob), ob).Tab{L} + ...
                  bulk(i-1, du(ob), ob).Rab{L};

%              T(b,a)
               bulk(i, du(ob), ob).Tba{L} = ...
                  bulk(i-1, du(ob), ob).Tba{L} * upgs * ...
                  rsol{i}.Tba{L};

%              S(b,a)
               bulk(i, du(ob), ob).Sba{L} = ...
                  bulk(i-1, du(ob), ob).Tba{L} * upgs * ...
                  (rsol{i}.Rab{L} * ...
                    bulk(i-1, du(ob), ob).Sab{L} + ...
                    rsol{i}.Sba{L}) + ...
                  bulk(i-1, du(ob), ob).Sba{L};

%              Duplicate the downward solution at lower depths
               if du(ob) == 1
                  bulk(i, 2, ob) = bulk(i-1, 2, ob);
               end
               
            end
            
         end

      end
      
   end

%  Reshape downward bulk terms as [NL, NL] blocks of [BM, BM] entries
%   for i = 1:nsub
%      for ob = 1:pobs(i)
%         bulk(i, 2, ob).Tab = blkdiag(bulk(i, 2, ob).Tab{:});
%         bulk(i, 2, ob).Rba = blkdiag(bulk(i, 2, ob).Rba{:});         
%         bulk(i, 2, ob).Sab = cat(1, bulk(i, 2, ob).Sab{:});
%         bulk(i, 2, ob).Rab = blkdiag(bulk(i, 2, ob).Rab{:});
%         bulk(i, 2, ob).Tba = blkdiag(bulk(i, 2, ob).Tba{:});
%         bulk(i, 2, ob).Sba = cat(1, bulk(i, 2, ob).Sba{:});
%      end
%   end

%  Free up memory by clearing unused variables
   clear rsol;
   clear robs;

   if comment == 1
      t1bulk = toc(t0bulk);
      if t1bulk > 2
         bulkh = floor(round(t1bulk) / 3600);
         bulkm = floor(mod(round(t1bulk), 3600) / 60);
         bulks = mod(round(t1bulk), 60);
         if bulkh > 0
            fprintf(' [Completed in %dh%dm]\n', bulkh, bulkm)
         elseif bulkm > 0
            fprintf(' [Completed in %dm%ds]\n', bulkm, bulks)
         else
            fprintf(' [Completed in %ds]\n', bulks)
         end
      else
         fprintf(' [Complete]\n');
      end
   end


%--------------------------------------------------------------------------
%  Second floor: Append bottom boundary condition to upwelling solution
%--------------------------------------------------------------------------

   if comment == 1
      fprintf('\n(*) Appending the bottom boundary condition');
      t0bott = tic;
   end
   
%  Array to store upwelling solution + bottom boundary
   under = cell(nsubs, 1);
   
   for i = 1:nsubs
            
%     Structure to store upwelling transfer functions
      under{i} = struct('Rab', cell(pobs(i), 1), ...
                        'Sba', cell(pobs(i), 1));

      for ob = 1:pobs(i)
         
%        Store L-Fourier coefficients
         under{i}(ob).Rab = cell(p.NL, 1);
         under{i}(ob).Sba = cell(p.NL, 1);
         
         
         for L = 1:p.NL            

%           Upwelling geometric series
            upgs = (eye(p.BM) - Rbb{i+d0}{L} * bulk(i, 1, ob).Rba{L})^(-1);

%           R(a,b)
            under{i}(ob).Rab{L} = bulk(i, 1, ob).Tba{L} * upgs * ...
                                  Rbb{i+d0}{L} * ...
                                  bulk(i, 1, ob).Tab{L} + ...
                                  bulk(i, 1, ob).Rab{L};

%           S(b,a)
            under{i}(ob).Sba{L} = bulk(i, 1, ob).Tba{L} * upgs * ...
                                  Rbb{i+d0}{L} * ...
                                  bulk(i, 1, ob).Sab{L} + ...
                                  bulk(i, 1, ob).Sba{L};
         
         end
         
%        Reshape upwelling solution as [NL, NL] blocks of [BM, BM] entries
%         under{i}(ob).Rab = blkdiag(under{i}(ob).Rab{:});
%         under{i}(ob).Sba = cat(1, under{i}(ob).Sba{:});
         
      end
      
   end
               
   if comment == 1
      t1bott = toc(t0bott);
      if t1bott > 2
         botth = floor(round(t1bott) / 3600);
         bottm = floor(mod(round(t1bott), 3600) / 60);
         botts = mod(round(t1bott), 60);
         if botth > 0
            fprintf(' [Completed in %dh%dm]\n', botth, bottm)
         elseif bottm > 0
            fprintf(' [Completed in %dm%ds]\n', bottm, botts)
         else
            fprintf(' [Completed in %ds]\n', botts)
         end
      else
         fprintf(' [Complete]\n');
      end
   end

   
%--------------------------------------------------------------------------
%  Third floor: Append surface boundary condition to downwelling solution
%--------------------------------------------------------------------------

   if comment == 1
      fprintf('\n(*) Appending the surface boundary condition');
      t0surf = tic;
   end
   
%  Array to store upwelling solution + bottom boundary
   over = cell(nsubs, 1);
   
   for i = 1:nsubs
      
%     Structure to store upwelling transfer functions
      over{i} = struct('Tab', cell(pobs(i), 1), ...
                       'Rba', cell(pobs(i), 1), ...
                       'Sab', cell(pobs(i), 1), ...
                       'Tba', cell(pobs(i), 1), ...
                       'Rab', cell(pobs(i), 1), ...
                       'Sba', cell(pobs(i), 1));

      for ob = 1:pobs(i)
         
%        Store L-Fourier coefficients
         over{i}(ob).Tab = cell(p.NL, 1);
         over{i}(ob).Rba = cell(p.NL, 1);
         over{i}(ob).Sab = cell(p.NL, 1);
         over{i}(ob).Rab = cell(p.NL, 1);
         over{i}(ob).Tba = cell(p.NL, 1);
         over{i}(ob).Sba = cell(p.NL, 1);
         
         
         for L = 1:p.NL    

%           Downwelling geometric series
            dwgs = (eye(p.BM) - surf.Rba{L} * bulk(i, 2, ob).Rab{L})^(-1);

%           Upwelling geometric series
            upgs = (eye(p.BM) - bulk(i, 2, ob).Rab{L} * surf.Rba{L})^(-1);

%           T(a,b)
            over{i}(ob).Tab{L} = bulk(i, 2, ob).Tab{L} * dwgs * ...
                                 surf.Tab{L};

%           R(b,a)
            over{i}(ob).Rba{L} = bulk(i, 2, ob).Tab{L} * dwgs * ...
                                 surf.Rba{L} * ...
                                 bulk(i, 2, ob).Tba{L} + ...
                                 bulk(i, 2, ob).Rba{L};

%           S(a,b)
            over{i}(ob).Sab{L} = bulk(i, 2, ob).Tab{L} * dwgs * ...
                                 surf.Rba{L} * ...
                                 bulk(i, 2, ob).Sba{L} + ...
                                 bulk(i, 2, ob).Sab{L};

%           R(a,b)
            over{i}(ob).Rab{L} = surf.Tba{L} * upgs * ...
                                 bulk(i, 2, ob).Rab{L} * ...
                                 surf.Tab{L} + surf.Rab{L};

%           T(b,a)
            over{i}(ob).Tba{L} = surf.Tba{L} * upgs * ...
                                 bulk(i, 2, ob).Tba{L};

%           S(b,a)
            over{i}(ob).Sba{L} = surf.Tba{L} * upgs * ...
                                 bulk(i, 2, ob).Sba{L};
      
         end
         
      end
      
   end

%  Free up memory by clearing unused variables
   clear bulk;
   
   if comment == 1
      t1surf = toc(t0surf);
      if t1surf > 2
         surfh = floor(round(t1surf) / 3600);
         surfm = floor(mod(round(t1surf), 3600) / 60);
         surfs = mod(round(t1surf), 60);
         if surfh > 0
            fprintf(' [Completed in %dh%dm]\n', surfh, surfm)
         elseif surfm > 0
            fprintf(' [Completed in %dm%ds]\n', surfm, surfs)
         else
            fprintf(' [Completed in %ds]\n', surfs)
         end
      else
         fprintf(' [Complete]\n');
      end
   end
   
   
%--------------------------------------------------------------------------
% Fourth floor: Compute radiances and irradiaces
%--------------------------------------------------------------------------
   
   if comment == 1
      fprintf('\n(*) Computing radiances and irradiances')
      t0rad = tic;
   end
   
%  Positive exponential transform factors, [B, M(i), N(u), NL-1]
   exP = reshape(p.exP, [1, 1, p.N, p.NL-1]);
   exP = repmat(exP, [p.B, p.M, 1, 1]);
   exS = reshape(p.exS, [1, 1, p.N, p.NL-1]);
   exS = repmat(exS, [p.B, p.M, 1, 1]);

%  Irradiance volumes, 2D [B, M(i), N(u)]
   Omi = reshape(p.Om, [1, p.M, 1]);
   Omi = repmat(Omi, [p.B, 1, p.N]);

%  Irradiance average mu, 2D [B, M(i), N(u)]
   mui = reshape(p.mu_av, [1, p.M, 1]);
   mui = repmat(mui, [p.B, 1, p.N]);

   
%  Control case: bottom reflectance just above the water
%  ------------

   dry = struct('rad', cell(ncol, 1), 'irr', cell(ncol, 1));

   for col = 1:ncol
   
%     Upwelling exterior radiance
      dry(col).rad.up = NaN(p.B, p.M, 1, p.NL);
      for L = 1:p.NL
         dry(col).rad.up(:,:,:,L) = reshape(Rdry{col}{L} * sky.rad{L}, ...
                                            [p.B, p.M, 1]);
      end
      dry(col).rad.up = repmat(dry(col).rad.up, [1, 1, p.N, 1]);
      dry(col).rad.up = ...
            sum(dry(col).rad.up(:,:,:,1:(end-1)) .* exP + ...
                conj(dry(col).rad.up(:,:,:,2:end)) .* exS, 4) / p.N;
      dry(col).rad.up = reshape(dry(col).rad.up, [p.B, p.M, p.N]);
      
%     Upwelling exterior irradiance
      dry(col).irr.up = sum(mui .* Omi .* dry(col).rad.up, [2,3]);
      dry(col).irr.up = reshape(dry(col).irr.up, [p.B, 1]);

%     Downwelling exterior radiance
      dry(col).rad.dw = reshape(sky.radu, [1, p.M, p.N]);
      dry(col).rad.dw = repmat(solirr, [1, p.M, p.N]) .* ...
                        repmat(dry(col).rad.dw, [p.B, 1, 1]);
              
%     Downwelling exterior irradiance       
      dry(col).irr.dw = solirr;

%     Exterior irradiance reflectance
      dry(col).irr.ud = real(dry(col).irr.up ./ dry(col).irr.dw);
   
   end

   
%     Exterior and interior radiance store
      ext = struct('rad', cell(ndeps, 1), 'irr', cell(ndeps, 1));
      int = struct('rad', cell(ndeps, 1), 'irr', cell(ndeps, 1));

   for d = 1:ndeps

%     Index for subdepths
      i = d - d0;
      
%     Exterior depth store contains only 1 element
      ext(d).rad = struct('up', cell(1, 1), ...
                          'dw', cell(1, 1));

      ext(d).irr = struct('up', cell(1, 1), ...
                          'dw', cell(1, 1), ...
                          'ud', cell(1, 1));
        
                       
%     Exterior radiances
%     ------------------

%     Upwelling exterior radiance
      ext(d).rad(1).up = NaN(p.B, p.M, 1, p.NL);

      if d == d0  % iff d = d0 = 1 iff d1 = 0

         for L = 1:p.NL

%           Upwelling geometric series
            upgs = (eye(p.BM) - Rbb{d}{L} * surf.Rba{L})^(-1);

%           Upwelling exterior radiance
            ext(d).rad(1).up(:,:,:,L) = ...
               reshape((surf.Tba{L} * upgs * ...
                        Rbb{d}{L} * ...
                        surf.Tab{L} + ...
                        surf.Rab{L}) * ...
                       sky.rad{L}, [p.B, p.M, 1]);
                    
         end
                       
      elseif d > d0

         for L = 1:p.NL
         
%           Upwelling geometric series
            upgs = (eye(p.BM) - under{i}(1).Rab{L} * surf.Rba{L})^(-1);

%           Upwelling exterior radiance
            ext(d).rad(1).up(:,:,:,L) = ...
               reshape((surf.Tba{L} * upgs * ...
                        under{i}(1).Rab{L} * ...
                        surf.Tab{L} + ...
                        surf.Rab{L}) * ...
                       sky.rad{L} + ...
                       surf.Tba{L} * upgs * ...
                       under{i}(1).Sba{L}, [p.B, p.M, 1]);
                    
         end
      
      end
      
%     Upwelling exterior radiance transform
      ext(d).rad(1).up = repmat(ext(d).rad(1).up, [1, 1, p.N, 1]);
      ext(d).rad(1).up = ...
            sum(ext(d).rad(1).up(:,:,:,1:(end-1)) .* exP + ...
                conj(ext(d).rad(1).up(:,:,:,2:end)) .* exS, 4) / p.N;
      ext(d).rad(1).up = reshape(ext(d).rad(1).up, [p.B, p.M, p.N]);

%     Upwelling exterior irradiance
      ext(d).irr(1).up = sum(mui .* Omi .* ext(d).rad(1).up, [2, 3]);
      ext(d).irr(1).up = reshape(ext(d).irr(1).up, [p.B, 1]);

      
%     Downwelling exterior radiance (pre-transformed)
      ext(d).rad(1).dw = reshape(sky.radu, [1, p.M, p.N]);
      ext(d).rad(1).dw = repmat(solirr, [1, p.M, p.N]) .* ...
                         repmat(ext(d).rad(1).dw, [p.B, 1, 1]);

%     Downwelling exterior irradiance
      ext(d).irr(1).dw = sum(mui .* Omi .* ext(d).rad(1).dw, [2, 3]);
      ext(d).irr(1).dw = reshape(ext(d).irr(1).dw, [p.B, 1]);

%     Exterior irradiance reflectance
      ext(d).irr(1).ud = real(ext(d).irr(1).up ./ ext(d).irr(1).dw);
         

%     Interior radiances
%     ------------------

%     Interior depth store
      int(d).rad = struct('up', cell(p0(d), 1), ...
                          'dw', cell(p0(d), 1));

      int(d).irr = struct('up', cell(p0(d), 1), ...
                          'dw', cell(p0(d), 1), ...
                          'ud', cell(p0(d), 1));

      for ob = 1:p0(d)

%        Upwelling and downwelling interior radiances
         int(d).rad(ob).up = NaN(p.B, p.M, 1, p.NL);
         int(d).rad(ob).dw = NaN(p.B, p.M, 1, p.NL);
         
         if d == d0  % iff d = d0 = 1 iff d1 = 0
            
            for L = 1:p.NL

%              Upwelling geometric series
               upgs = (eye(p.BM) - Rbb{d}{L} * surf.Rba{L})^(-1);
         
%              Upwelling interior radiance
               int(d).rad(ob).up(:,:,:,L) = ...
                  reshape(upgs * Rbb{d}{L} * ...
                          surf.Tab{L} * ...
                          sky.rad{L}, [p.B, p.M, 1]);

%              Downwelling geometric series
               dwgs = (eye(p.BM) - surf.Rba{L} * Rbb{d}{L})^(-1);

%              Downwelling interior radiance
               int(d).rad(ob).dw(:,:,:,L) = ...
                  reshape(dwgs * surf.Tab{L} * ...
                          sky.rad{L}, [p.B, p.M, 1]);
                    
            end
            
         elseif d > d0
            
            for L = 1:p.NL

%              Upwelling geometric series
               upgs = (eye(p.BM) - under{i}(ob).Rab{L} * ...
                                   over{i}(ob).Rba{L})^(-1);

%              Upwelling interior radiance
               int(d).rad(ob).up(:,:,:,L) = ...
                  reshape(upgs * under{i}(ob).Rab{L} * ...
                          over{i}(ob).Tab{L} * ...
                          sky.rad{L} + ...
                          upgs * (under{i}(ob).Rab{L} * ...
                                  over{i}(ob).Sab{L} + ...
                                  under{i}(ob).Sba{L}), [p.B, p.M, 1]);

%              Downwelling geometric series
               dwgs = (eye(p.BM) - over{i}(ob).Rba{L} * ...
                                   under{i}(ob).Rab{L})^(-1);
         
%              Downwelling interior radiance
               int(d).rad(ob).dw(:,:,:,L) = ...
                  reshape(dwgs * over{i}(ob).Tab{L} * ...
                          sky.rad{L} + ...
                          dwgs * (over{i}(ob).Rba{L} * ...
                                  under{i}(ob).Sba{L} + ...
                                  over{i}(ob).Sab{L}), [p.B, p.M, 1]);
                             
            end
            
         end


%        Upwelling exterior radiance transform
         int(d).rad(ob).up = repmat(int(d).rad(ob).up, [1, 1, p.N, 1]);
         int(d).rad(ob).up = ...
               sum(int(d).rad(ob).up(:,:,:,1:(end-1)) .* exP + ...
                   conj(int(d).rad(ob).up(:,:,:,2:end)) .* exS, 4) / p.N;
         int(d).rad(ob).up = reshape(int(d).rad(ob).up, [p.B, p.M, p.N]);
      
%        Upwelling interior irradiance
         int(d).irr(ob).up = sum(mui .* Omi .* int(d).rad(ob).up, [2,3]);
         int(d).irr(ob).up = reshape(int(d).irr(ob).up, [p.B, 1]);


%        Downwelling exterior radiance transform
         int(d).rad(ob).dw = repmat(int(d).rad(ob).dw, [1, 1, p.N, 1]);
         int(d).rad(ob).dw = ...
               sum(int(d).rad(ob).dw(:,:,:,1:(end-1)) .* exP + ...
                   conj(int(d).rad(ob).dw(:,:,:,2:end)) .* exS, 4) / p.N;
         int(d).rad(ob).dw = reshape(int(d).rad(ob).dw, [p.B, p.M, p.N]);
         
%        Downwelling interior irradiance       
         int(d).irr(ob).dw = sum(mui .* Omi .* int(d).rad(ob).dw, [2,3]);
         int(d).irr(ob).dw = reshape(int(d).irr(ob).dw, [p.B, 1]);

%        Interior irradiance reflectance
         int(d).irr(ob).ud = real(int(d).irr(ob).up ./ int(d).irr(ob).dw);
      
      end
      
   end
   
   bird = struct;

%  Parameter save
   bird.p = p;
   bird.pf = pf;
   bird.geo = geo;
   bird.sol = sol;
   bird.sky = sky;
   bird.surf = surf;

%  Solution save
   bird.dry = dry;
   bird.ext = ext;
   bird.int = int;

%  Parameter store
   bird.nsub = nsubs;
   bird.d0   = d0;
   bird.p0   = p0;
   bird.obs  = obs;
   bird.pobs = pobs;
   bird.bobs = bobs;
     
%  Ricatti
   %bird.rsol = rsol;
   %bird.robs = robs;
   
   if comment == 1
      t1rad = toc(t0rad);
      if t1rad > 2
         radh = floor(round(t1rad) / 3600);
         radm = floor(mod(round(t1rad), 3600) / 60);
         rads = mod(round(t1rad), 60);
         if radh > 0
            fprintf(' [Completed in %dh%dm]\n', radh, radm)
         elseif radm > 0
            fprintf(' [Completed in %dm%ds]\n', radm, rads)
         else
            fprintf(' [Completed in %ds]\n', rads)
         end
      else
         fprintf(' [Complete]\n');
      end
   end
      
end