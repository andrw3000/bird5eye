function bfr = b_raman(lam1, lam2)
%  Params for inelastic scattering effects; lam2=lam' to lam1=lam

%  Raman scattering coe?cient (lam2)
%  C.f. Bartlett et al. (1998) and Desiderio (2000)
   b0 = 2.6e-4;
   br = b0 .* (488 ./ lam2).^(5.5);
   fr_lam = (10^7 ./ lam1.^2) .* fr_k((10^7 ./ lam2) - (10^7 ./ lam2));
   fr_lam = tril(fr_lam) .* ~eye(size(lam1));
   
   bfr = br .* fr_lam;
   
   function out = fr_k(k_shift)
   
      kdim = size(k_shift);
      jdim = ones(1, length(size(k_shift)));
      
      k_shift = reshape(k_shift, [1, kdim]);
      k_shift = repmat(k_shift, [4, jdim]);
      
      Aj  = [0.41; 0.39; 0.10; 0.10];
      kj  = [3250; 3425; 3530; 3625];
      dkj = [210; 175; 140; 140];
      
      Asum = sum(Aj);      

      Aj  = repmat(Aj, [1, kdim]);
      kj  = repmat(kj, [1, kdim]);
      dkj = repmat(dkj, [1, kdim]);

      
      out = sum((Aj ./ dkj) .* ...
                exp(-4 * log(2) .* ((k_shift - kj) ./ dkj).^2), 1) ./ ...
            (sqrt(pi / (4 * log(2))) .* Asum);
         
      out = reshape(out, kdim);
      
   end
end