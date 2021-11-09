function [psi, Dmui0, Dmuj0] = beta_psi(p)
   
%  Half subquad grid, 5D [M(i), N(v), M0, N0, 2]
   [th0, ph0, i0, u0, ~] = ndgrid(p.th0, p.ph0, p.i0, p.u0, p.sgn);
   
   mu0  = cos(th0);
   Dmu0 = cos(th0 - p.Dth) - cos(th0);
 
%  Forget the u=0 variable for the thj, muj computation, [M, M0, N0, 2]
   th00  = reshape(th0(:,1,:,:,:), [p.M, p.M0, p.N0, 2]);
   mu00  = reshape(mu0(:,1,:,:,:), [p.M, p.M0, p.N0, 2]);
   Dmu00 = reshape(Dmu0(:,1,:,:,:), [p.M, p.M0, p.N0, 2]);
   ph00  = reshape(ph0(:,1,:,:,:), [p.M, p.M0, p.N0, 2]);
   i00   = reshape(i0(:,1,:,:,:), [p.M, p.M0, p.N0, 2]);
   v00   = reshape(u0(:,1,:,:,:), [p.M, p.M0, p.N0, 2]);
   
%  Subquad centres (v=0), 5D [M(i), 1(j), N(u), M0, 1, N0, 1, 2]
   phv(:,1,:,:,1,:,1,:) = ph0  + (u0 - (1/2)) .* p.Dph ./ p.N0;
   
%  Subquad centres (v=0), 4D [1(i), M(j), 1(u), 1, M0, 1, N0, 2]
   phu(1,:,1,1,:,1,:,:) = ph00 + (v00 - (1/2)) .* p.Dph ./ p.N0;
   
%  Stretch to 8D [M(i), M(j), N(u), M0, M0, N0, N0, 2]
   phv = repmat(phv, [  1, p.M,   1,    1, p.M0,    1, p.N0, 1]);
   phu = repmat(phu, [p.M,   1, p.N, p.M0,    1, p.N0,    1, 1]);

   if p.constant_mu_partition == 1
      Dmui0(:,1,:,:,1,:,1,:) = Dmu0/p.M0;
      Dmuj0(1,:,1,1,:,1,:,:) = Dmu00/p.M0;
      mui(:,1,:,:,1,:,1,:)   = mu0 + (i0 - (1/2)) .* Dmu0 ./ p.M0;
      muj(1,:,1,1,:,1,:,:)   = mu00 + (i00 - (1/2)) .* Dmu00 ./ p.M0;
      
      Dmui0 = repmat(Dmui0, [1 ,p.M, 1, 1, p.M0, 1, p.N0, 1]);
      Dmuj0 = repmat(Dmuj0, [p.M, 1, p.N, p.M0, 1, p.N0, 1, 1]);      
      mui   = repmat(mui, [1 ,p.M, 1, 1, p.M0, 1, p.N0, 1]);
      muj   = repmat(muj, [p.M, 1, p.N, p.M0, 1, p.N0, 1, 1]);
         
   else
      thi(:,1,:,:,1,:,1,:) = th0 - (i0 - (1/2)) .* p.Dth ./ p.M0;
      thj(1,:,1,1,:,1,:,:) = th00 - (i00 - (1/2)) .* p.Dth ./ p.M0;
      thi = repmat(thi, [1 ,p.M, 1, 1, p.M0, 1, p.N0, 1]);      
      thj = repmat(thj, [p.M, 1, p.N, p.M0, 1, p.N0, 1, 1]);
      
      Dmui0 = cos(thi - p.Dth/(2*p.M0)) - cos(thi + p.Dth/(2*p.M0));
      Dmuj0 = cos(thj - p.Dth/(2*p.M0)) - cos(thj + p.Dth/(2*p.M0));
      mui = cos(thi);
      muj = cos(thj);
      
   end

%  th0 starts at pi/2 + (1/2)Dmu/M0
%  ph0 starts at -Dph/2 + (1/2)Dph/N0
   
%  Sign function, 8D [M, M, N, M0, M0, N0, N0, 2]
   sgn(1,1,1,1,1,1,1,:) = p.sgn;
      sgn = repmat(sgn, [p.M,p.M,p.N,p.M0,p.M0,p.N0,p.N0,1]);

%  Scattering angle, 8D [M, M, N, M0, M0, N0, N0, 2]
   psi = acos( sgn .* mui .* muj + sqrt(1-mui.^2) .* sqrt(1-muj.^2) .* ...
      cos(phv - phu));
   psi = real(psi);

%     psi.angle is the angle between (muj,phv) --> (mui,phu)
%     spherical coords: mu=cos(th) in [0,1], th=nadir, and ph=azimuth
%     p.sgn = +1 for same hemisphere / sgn = -1 for different
%     Here mu=cos(th)=-cos(pi-th) for mu in [0,-1], pi-th in [pi/2,0]

end