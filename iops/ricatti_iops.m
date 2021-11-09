function [tau, rho, sigma_plus, sigma_minus] = ricatti_iops(z, L, p)
%  Local IOP transfer matrices tau, rho and source terms

%  Pure water baseline
   tau = p.tau_w{L};
   rho = p.rho_w{L};
   
   if p.raman
      tau = tau + p.tau_r{L};
      rho = rho + p.rho_r{L};
   end
   
   if p.particle
 
      ap = diag(bandwidth_avg(a_chl(z,p) + a_cdom(z,p), p.bwid, p.B0));
      bp = diag(bandwidth_avg(b_chl(z,p), p.bwid, p.B0));

%     Elastic scattering contribution
      tau = tau + kron(p.beta_p{1, L}, bp) - kron(p.mui_inv_diag, ap + bp);
      rho = rho + kron(p.beta_p{2, L}, bp);

%     PFPart only
      %tau = kron(p.beta_p{1, L}, bp) - ...
      %      kron(p.mui_inv_diag, ap + bp + p.cw);
      %tau = 1 * tau;
      %rho = kron(p.beta_p{2, L}, bp);
      %rho = 0 * rho;
      
      if p.fluo && (L==1)
         
%        Quad and band averaged Fourier trans form of the inelastic VSF
         beta_fluo = p.N * kron(p.mui_inv_Omj, bandwidth_avg( ...
                     beta_inel_fluo(z, p), p.bwid, p.B0));  % x delta(L=0)

         tau = tau + beta_fluo;
         rho = rho + beta_fluo;
         
      end
      
   end
   
%  Internal source terms
   sigma_plus = zeros(p.M * p.B, 1);
   sigma_minus = zeros(p.M * p.B, 1);
   
end
