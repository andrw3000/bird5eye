%--------------------------------------------------------------------------
%  ricatti_solver: integrates Ricatti system
%--------------------------------------------------------------------------

function [rsol, robs] = ricatti_solver(z0, z1, band_obs, p)
%  Solves the Ricatte ODEs for each L-Fourier coefficient
   
%--------------------------------------------------------------------------
% Ground floor: integrate the Ricatti ODEs in [z0, z1]
%--------------------------------------------------------------------------

%  Structure arrays to store intermediate L-mode outputs
   rsol = struct('Tab', 'Rba', 'Sab', 'Tba', 'Rab', 'Sba');
      rsol.Tab = cell(p.NL, 1);
      rsol.Rba = cell(p.NL, 1);
      rsol.Sab = cell(p.NL, 1);
      rsol.Tba = cell(p.NL, 1);
      rsol.Rab = cell(p.NL, 1);
      rsol.Sba = cell(p.NL, 1);
      
   if ~isempty(band_obs)

      robs = struct('Tab', cell(2, length(band_obs)), ...
                    'Rba', cell(2, length(band_obs)), ...
                    'Sab', cell(2, length(band_obs)), ...
                    'Tba', cell(2, length(band_obs)), ...
                    'Rab', cell(2, length(band_obs)), ...
                    'Sba', cell(2, length(band_obs)));

      for ud = 1:2
      for ob = 1:length(band_obs)
         robs(ud,ob).Tab = cell(p.NL, 1);
         robs(ud,ob).Rba = cell(p.NL, 1);
         robs(ud,ob).Sab = cell(p.NL, 1);
         robs(ud,ob).Tba = cell(p.NL, 1);
         robs(ud,ob).Rab = cell(p.NL, 1);
         robs(ud,ob).Sba = cell(p.NL, 1);
      end
      end

   end

%  Compute the L-Fourier coefficients
   for L = 1:p.NL
            
      if p.comment == 1; t0 = tic; end
            
%     Boundary conditions for the Ricatti equations
      T0 = eye(p.BM);         % 2D [BM, BM]
      R0 = zeros(p.BM);       % 2D [BM, BM]
      S0 = zeros(p.BM, 1);    % 1D [BM, 1]
      
      f0 = [reshape(T0, [p.BM^2, 1]); reshape(R0, [p.BM^2, 1]); S0; ...
            reshape(R0, [p.BM^2, 1]); reshape(T0, [p.BM^2, 1]); S0];
      
      fone = cell(1, 1);   % Store full solution fdw(end, :) = fup(end, :)
      ftwo = cell(2, 1);   % Allocate ftwo{1} = fup; ftwo{2} = fdw
      
%     Integrate and interpolate the Ricatti ODEs using fup(z0) = fdw(z1)
      if isempty(band_obs)
         
         [zdw, fdw] = ode45(@(z,f) ricatti_dw(z, f, L, p), [z0, z1], f0);
         
         fone{1} = interp1(zdw, fdw, z1);  % fup(z0) = fdw(z1) = fdw(end,:)

         if p.comment == 1
            if L==1
               fprintf('\n     * No observations in [%.1f, %.1f)\n', ...
                                                       z0, z1)
            end
         end

      elseif all(band_obs == z0)
         
         [zdw, fdw] = ode45(@(z,f) ricatti_dw(z, f, L, p), [z0, z1], f0);
         
         fone{1} = interp1(zdw, fdw, z1);
         ftwo{1} = interp1(zdw, fdw, z1 .* ones(size(band_obs))); % fup(z0)
         ftwo{2} = interp1(zdw, fdw, band_obs);                   % fdw(z0)
         
         if p.comment == 1
            if L==1
               fprintf(['\n     * Only observation at %.1fm in', ...
                        ' [%.1f, %.1f)\n'], z0, z0, z1)
            end
         end
         
      else
         
         [zup, fup] = ode45(@(z,f) ricatti_up(z, f, L, p), [z1, z0], f0);
         [zdw, fdw] = ode45(@(z,f) ricatti_dw(z, f, L, p), [z0, z1], f0);
         
         fone{1} = interp1(zdw, fdw, z1);        % fup(z0) = fdw(z1)
         ftwo{1} = interp1(zup, fup, band_obs);  % fup(z)
         ftwo{2} = interp1(zdw, fdw, band_obs);  % fdw(z)

         if p.comment == 1
            if L==1
               fprintf('\n     * %d observations in [%.1f, %.1f)\n', ...
                  length(band_obs), z0, z1)
            end
         end
         
      end

%     Record time for each L
      if p.comment == 1
         t1 = toc(t0);
         if t1 > 2
            t1m = floor(round(t1) / 60);
            t1s = mod(round(t1), 60);
            if t1m > 0
               fprintf(['     - Solution for L = %d ', ...
                        '[Completed in %dm%ds]\n'], L, t1m, t1s)
            else
               fprintf(['     - Solution for L = %d ', ...
                        '[Completed in %ds]\n'], L, t1s)
            end
         end
      end
      

%     Reshape solutions; % (ric(1), ric(2)) <--> (dw, up)
%     ---------------------------------------------------

%     T(z0, z1), 2D [BM, BM]
      rsol.Tab{L} = reshape(fone{1}(1, ...
                    1:(p.BM^2)).', p.BM, p.BM);
              
%     R(z1, z0), 2D [BM, BM]
      rsol.Rba{L} = reshape(fone{1}(1, ...
                    (p.BM^2+1):(2*p.BM^2)).', p.BM, p.BM);
      
%     S(z0, z1), 1D [BM, BM]
      rsol.Sab{L} = reshape(fone{1}(1, ...
                    (2*p.BM^2+1):(2*p.BM^2+p.BM)).', p.BM, 1);
                        
%     R(z0, z1), 2D [BM, BM]
      rsol.Rab{L} = reshape(fone{1}(1, ...
                    (2*p.BM^2+p.BM+1):(3*p.BM^2+p.BM)).', p.BM, p.BM);
                        
%     T(z1, z0), 2D [BM, BM]
      rsol.Tba{L} = reshape(fone{1}(1, ...
                    (3*p.BM^2+p.BM+1):(4*p.BM^2+p.BM)).', p.BM, p.BM);
                        
%     S(z1, z0), 1D [BM, BM]
      rsol.Sba{L} = reshape(fone{1}(1, ...
                    (4*p.BM^2+p.BM+1):(4*p.BM^2+2*p.BM)).', p.BM, 1);
                        
      if ~isempty(band_obs)
         
         for ud = 1:2
         for ob = 1:length(band_obs)
         
%           T(z0, z1), 2D [BM, BM]
            robs(ud, ob).Tab{L} = reshape(ftwo{ud}(ob, ...
                         1:(p.BM^2)).', p.BM, p.BM);

%           R(z1, z0), 2D [BM, BM]
            robs(ud, ob).Rba{L} = reshape(ftwo{ud}(ob, ...
                         (p.BM^2+1):(2*p.BM^2)).', p.BM, p.BM);

%           S(z0, z1), 1D [BM, BM]
            robs(ud, ob).Sab{L} = reshape(ftwo{ud}(ob, ...
                         (2*p.BM^2+1):(2*p.BM^2+p.BM)).', p.BM, 1);

%           R(z0, z1), 2D [BM, BM]
            robs(ud, ob).Rab{L} = reshape(ftwo{ud}(ob, ...
                         (2*p.BM^2+p.BM+1):(3*p.BM^2+p.BM)).', p.BM, p.BM);

%           T(z1, z0), 2D [BM, BM]
            robs(ud, ob).Tba{L} = reshape(ftwo{ud}(ob, ...
                         (3*p.BM^2+p.BM+1):(4*p.BM^2+p.BM)).', p.BM, p.BM);

%           S(z1, z0), 1D [BM, BM]
            robs(ud, ob).Sba{L} = reshape(ftwo{ud}(ob, ...
                         (4*p.BM^2+p.BM+1):(4*p.BM^2+2*p.BM)).', p.BM, 1);
                    
         end
         end
         
      else
         
         robs = [];

      end
      
   end
   
   
%  Reshape solution as [N,N]/[N,1] block matrices of [BM,BM]/[BM,1] blocks
%
%   rsol.Tab = blkdiag(rsol.Tab{:});
%   rsol.Rba = blkdiag(rsol.Rba{:});
%   rsol.Sab = reshape([rsol.Sab{:}], [p.BMN, 1]);
%   rsol.Rab = blkdiag(rsol.Rab{:});
%   rsol.Tba = blkdiag(rsol.Tba{:});
%   rsol.Sba = reshape([rsol.Sba{:}], [p.BMN, 1]);

%   if ~isempty(band_obs)

%      for ud = 1:2
%      for ob = 1:length(band_obs)

%         robs(ud, ob).Tab = blkdiag(robs(ud, ob).Tab{:});
%         robs(ud, ob).Rba = blkdiag(robs(ud, ob).Rba{:});
%         robs(ud, ob).Sab = reshape([robs(ud, ob).Sab{:}], [p.BMN, 1]);
%         robs(ud, ob).Rab = blkdiag(robs(ud, ob).Rab{:});
%         robs(ud, ob).Tba = blkdiag(robs(ud, ob).Tba{:});
%         robs(ud, ob).Sba = reshape([robs(ud, ob).Sba{:}], [p.BMN, 1]);

%      end
%      end
      
%   end

%--------------------------------------------------------------------------
% First floor: define Ricatti ODEs
%--------------------------------------------------------------------------

   function dfdz = ricatti_dw(z, f, L, p)
%     dfdz = downward Ricatti ODEs; 1D length [4*p.BM^2 + 2*p.BM, 1]; 
%        z = positive scalar (depth)
%        f = column vector of size [4*p.BM^2 + 2*p.BM, 1]

%     Import IOPs
      [tau, rho, sigma_plus, sigma_minus] = ricatti_iops(z, L, p);
      
%     Rematrixification of R, T, of size [BM, BM], & Sigma, of size [BM, 1]
      Taz = reshape(f(1:(p.BM^2)), p.BM, p.BM);
      Rza = reshape(f((p.BM^2+1):(2*p.BM^2)), p.BM, p.BM);
      Saz = reshape(f((2*p.BM^2+1):(2*p.BM^2+p.BM)), p.BM, 1);
      
      %Raz = reshape(f((2*p.BM^2+p.BM+1):(3*p.BM^2+p.BM)), p.BM, p.BM);
      Tza = reshape(f((3*p.BM^2+p.BM+1):(4*p.BM^2+p.BM)), p.BM, p.BM);
      %Sza = reshape(f((4*p.BM^2+p.BM+1):(4*p.BM^2+2*p.BM)), p.BM, 1);
      
%     Ricatti differential equations (downward)
      dTaz = (tau + Rza * rho) * Taz;
      dRza = (tau + Rza * rho) * Rza + Rza * tau + rho;  % Indep
      dSaz = (tau + Rza * rho) * Saz + Rza * sigma_minus + sigma_plus;
      dRaz = Tza * rho * Taz;
      dTza = Tza * (tau + rho * Rza);
      dSza = Tza * (rho * Saz + sigma_minus);

%     Reshape the solution
      dfdz = [reshape(dTaz, p.BM^2, 1); reshape(dRza, p.BM^2, 1); dSaz;...
              reshape(dRaz, p.BM^2, 1); reshape(dTza, p.BM^2, 1); dSza];
           
   end


   function dfdz = ricatti_up(z, f, L, p)
%     dfdz = upward Ricatti ODEs of size [4*p.BM^2 + 2*p.BM, 1]; 
%        z = positive scalar (depth)
%        f = column vector of size [4*p.BM^2 + 2*p.BM, 1]

%     Import IOPs
      [tau, rho, sigma_plus, sigma_minus] = ricatti_iops(z, L, p);

%     Rematrixification of R, T, of size [BM, BM], & Sigma, of size [BM, 1]
      Tzb = reshape(f(1:(p.BM^2)), p.BM, p.BM);
      %Rbz = reshape(f((p.BM^2+1):(2*p.BM^2)), p.BM, p.BM);
      %Szb = reshape(f((2*p.BM^2+1):(2*p.BM^2+p.BM)), p.BM, 1);
      
      Rzb = reshape(f((2*p.BM^2+p.BM+1):(3*p.BM^2+p.BM)), p.BM, p.BM);
      Tbz = reshape(f((3*p.BM^2+p.BM+1):(4*p.BM^2+p.BM)), p.BM, p.BM);
      Sbz = reshape(f((4*p.BM^2+p.BM+1):(4*p.BM^2+2*p.BM)), p.BM, 1);
      
%     Ricatti differential equations (downward)
      dTzb = - Tzb * (tau + rho * Rzb);
      dRbz = - Tzb * rho * Tbz;
      dSzb = - Tzb * (rho * Sbz + sigma_plus);
      dRzb = - ((tau + Rzb * rho) * Rzb + Rzb * tau + rho);  % Indep
      dTbz = - (tau + Rzb * rho) * Tbz;
      dSbz = - ((tau + Rzb * rho) * Sbz + Rzb * sigma_plus + sigma_minus);
      
%     Reshape the solution
      dfdz = [reshape(dTzb, p.BM^2, 1); reshape(dRbz, p.BM^2, 1); dSzb;...
              reshape(dRzb, p.BM^2, 1); reshape(dTbz, p.BM^2, 1); dSbz];
           
   end
   
end