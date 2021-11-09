function surf = boundary_surface(p)
   
   surf = struct;
   
%  Flat-surface air-water interface: entrance and exit angles
%  ----------------------------------------------------------

%  Refractive index of water
   nw = 1.333;
   
%  Critical angle (for water to air transmission)
   th_crit = asin(1/nw);
   
%  Subquad grid over [M0, M]; p.th0 = (p.M - (p.i-1)).*p.Dth;
   [i0, th0] = ndgrid(p.i0, p.th0);
  
%  Entrance angles, from pi/2 - Dth/2M0 to Dth/2M0
   thj = th0 - (i0 - (1/2)) * p.Dth/p.M0;       % [M0, M]
   thj = reshape(thj, [p.M0*p.M, 1]);           % [M0*M, 1]
   
%  Sub-quad mu differences [M*M0, M*M0]
   Dmu0 = cos(thj - p.Dth/(2*p.M0)) - cos(thj + p.Dth/(2*p.M0));
   [Dmui0, Dmuj0] = ndgrid(Dmu0, Dmu0);
   
%  Refracted exit angles using Snell's Law: sin(thj) = nWat * sin(thi)
   thiAW = asin(sin(thj) .* nw^(-1));	% thiAW < thj
   thiWA = asin(sin(thj) .* nw);        % thiWA > thj (TIR if thi>thCr)
%     TIR correcion in Water-to-Air case
      thiWA(thj>th_crit) = NaN;

%  Relative integer indices of exit angles; values spanning [M*M0, 1]
   indAW = floor(p.M0 * (p.M - thiAW/p.Dth) + 1/2);
   indWA =  ceil(p.M0 * (p.M - thiWA/p.Dth) + 1/2);
   
%  Permutation matrix of values
   E = eye(p.M * p.M0);
   permAW = E(:, indAW);
   permWA = E(:, indWA(~isnan(indWA))); % Points of TIR removed
%     Append zeros at TIR points
      permWA = [zeros(p.M * p.M0, nnz(isnan(indWA))), permWA];
      
   
%  Flat-surface air-water interface: Reflection and transmission values
%  --------------------------------------------------------------------    

%  Air-to-Water Reflection Coefficients
   RsAW = ((cos(thj) - nw*cos(thiAW))./(cos(thj) + nw*cos(thiAW))).^2;
   RpAW = ((nw*cos(thj) - cos(thiAW))./(nw*cos(thj) + cos(thiAW))).^2;
   RtotAW = (RsAW + RpAW)/2;
   
%  Water-to-Air Reflection Coefficients
   RsWA = ((nw*cos(thj) - cos(thiWA))./(nw*cos(thj) + cos(thiWA))).^2;
   RpWA = ((cos(thj) - nw*cos(thiWA))./(cos(thj) + nw*cos(thiWA))).^2;
   RtotWA = (RsWA + RpWA)/2;
%     Fix the reflection at TIR points
      RtotWA(isnan(RtotWA)) = 1;
      
%  Corresponding transmission values
   TtotAW = 1 - RtotAW;
   TtotWA = 1 - RtotWA;
   
   
%  Flat-surface air-water interface: quad averaged transfer matrices
%  -----------------------------------------------------------------
   
%  Subquad matrix of reflection values (thi = thj), [M0*M, M0*M]
   RmatAW = diag(RtotAW);
   RmatWA = diag(RtotWA);

%  Subquad matrix of transmission values (thi = thj), [M0*M, M0*M]
   TmatAW = permAW .* TtotAW';
   TmatWA = permWA .* TtotWA';

%  Store for printing (subquad)
   surf.RmatAWsub = RmatAW;
   surf.RmatWAsub = RmatWA;
   surf.TmatAWsub = TmatAW;
   surf.TmatWAsub = TmatWA;
   
%  Reshape for quad averaging, [M0, M, M0, M]
   RmatAW = reshape(RmatAW, [p.M0, p.M, p.M0, p.M]);
   RmatWA = reshape(RmatWA, [p.M0, p.M, p.M0, p.M]);
   TmatAW = reshape(TmatAW, [p.M0, p.M, p.M0, p.M]);
   TmatWA = reshape(TmatWA, [p.M0, p.M, p.M0, p.M]);
   Dmui0 = reshape(Dmui0, [p.M0, p.M, p.M0, p.M]);
   Dmuj0 = reshape(Dmuj0, [p.M0, p.M, p.M0, p.M]);
      
%  Quad averaged values, [M, M]
   Dmui(:,1) = p.Dmu;
      Dmui = repmat(Dmui, [1, p.M]);
      
   RmatAW = (1./Dmui) .* ...
            reshape(sum(RmatAW .* Dmui0 .* Dmuj0, [1, 3]), [p.M, p.M]);
   RmatWA = (1./Dmui) .* ...
            reshape(sum(RmatWA .* Dmui0 .* Dmuj0, [1, 3]), [p.M, p.M]);
   TmatAW = (1./Dmui) .* ...
            reshape(sum(TmatAW .* Dmui0 .* Dmuj0, [1, 3]), [p.M, p.M]);
   TmatWA = (1./Dmui) .* ...
            reshape(sum(TmatWA .* Dmui0 .* Dmuj0, [1, 3]), [p.M, p.M]);

%  Store for printing (quad)
   surf.RmatAWquad = RmatAW;
   surf.RmatWAquad = RmatWA;
   surf.TmatAWquad = TmatAW;
   surf.TmatWAquad = TmatWA;

%  Use azimuthal symetry and choose u = 0
%  phi components multiplies by delta(v = u + N/2) = delta(v = N/2)
%  normalisation by p.Dph accounted for by using p.mu instead of p.Om above

%  Azimuthal values at v > 0 (with u = 0), 3D [M(i), M(j), N(u)]
   RfullAW(:, :, :) = zeros(p.M, p.M, p.N);
   RfullWA(:, :, :) = zeros(p.M, p.M, p.N);
   TfullAW(:, :, :) = zeros(p.M, p.M, p.N);
   TfullWA(:, :, :) = zeros(p.M, p.M, p.N);
   
%  Azimuthal values at v = N/2 (u = 0), [M(i), M(j), N(u)]
   RfullAW(:, :, p.N/2) = RmatAW;
   RfullWA(:, :, p.N/2) = RmatWA;
   TfullAW(:, :, p.N/2) = TmatAW;
   TfullWA(:, :, p.N/2) = TmatWA;
   
%  Spectral transforms of quad-averaged transfer functions
%  -------------------------------------------------------

%  Exponential values, 4D [M(i), M(j), N(u), N(L)]
   exN4(1,1,:,:) = p.exN;
      exN4 = repmat(exN4, [p.M, p.M, 1, 1]);
      
%  Stretch over L, 4D [M(i), M(j), N(u), N(L)]
   RspecAW(:,:,:,1) = RfullAW;
      RspecAW = repmat(RspecAW, [1, 1, 1, p.NL]);
   RspecWA(:,:,:,1) = RfullWA;
      RspecWA = repmat(RspecWA, [1, 1, 1, p.NL]);
   TspecAW(:,:,:,1) = TfullAW;
      TspecAW = repmat(TspecAW, [1, 1, 1, p.NL]);
   TspecWA(:,:,:,1) = TfullWA;
      TspecWA = repmat(TspecWA, [1, 1, 1, p.NL]);
      
%  Spectral transforms summed over u, 3D [M(i), M(j), N(L)]
   RspecAW = reshape(sum(RspecAW .* exN4, 3), [p.M, p.M, p.NL]);
   RspecWA = reshape(sum(RspecWA .* exN4, 3), [p.M, p.M, p.NL]);
   TspecAW = reshape(sum(TspecAW .* exN4, 3), [p.M, p.M, p.NL]);
   TspecWA = reshape(sum(TspecWA .* exN4, 3), [p.M, p.M, p.NL]);

%  Reshape into [N, 1] cell arrays eith [M, M] elements
   Rab = reshape(num2cell(RspecAW, [1,2]), [p.NL, 1]);
   Rba = reshape(num2cell(RspecWA, [1,2]), [p.NL, 1]);
   Tab = reshape(num2cell(TspecAW, [1,2]), [p.NL, 1]);
   Tba = reshape(num2cell(TspecWA, [1,2]), [p.NL, 1]);
   
   surf.Rab = Rab;
   surf.Tab = Tab;
   surf.Tba = Tba;
   surf.Rba = Rba;

%  Produce an N(L)*N(L) block diagonal matrix of [M, M] blocks
   %surf.Rab = blkdiag(Rab{:});
   %surf.Tab = blkdiag(Tab{:});
   %surf.Tba = blkdiag(Tba{:});
   %surf.Rba = blkdiag(Rba{:});
   
%  Integration resolution
   surf.M0 = p.M0;
   surf.N0 = p.N0;
   surf.M = p.M;
   surf.N = p.N;
   
end