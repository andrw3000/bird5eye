function beta = beta_particle(psi, pf_type)
%  The particle phase functions:
%     1. Fournier--Fourand's analytic phase function
%     2. Mobley's average of Petzold's measured phase functions
%     3. Henyey--Greenstein's analytic phase function
     
%  Fournier--Fourand (1994) phase function
%  Form of Fournier--Jonasz (1999)
   if strcmpi(pf_type, 'FF')
      
%     Exponent in particle separation distribution C/r^mu  
      mu = 3.654;

%     Relative refractive index between oceanic particles
      n = 1.12;
         
%     Parameterisation
      u = 2 .* sin(psi ./ 2); u180 = 2 * sin(pi/2);
      d = u.^2 ./ (3 * (n-1)^2); d180 = u180^2 / (3 * (n-1)^2);
      v = (3 - mu)/2;
      c1 = 1 ./ (4 .* pi .* (1 - d).^2 .* d.^v);
      c2 = (1 - d180^v) / (16 * pi * (d180 - 1) * d180^v);
      beta1 = c1 .* ( (v .* (1 - d) - (1 - d.^v)) + ...
                   4 .* (d .* (1 - d.^v) - v .* (1 - d)) ./ u.^2);
      beta2 = c2 * (3 * cos(psi).^2 -1);
      beta = beta1 + beta2;
      
%  Petzold average phase function by Mobley
   elseif strcmpi(pf_type, 'petzold')
      
      load('data_input/pf_avg_petzold', 'psi_petzold', 'avg_petzold');
      psi_rad_pts = pi * psi_petzold / 180;
      beta = interp1(psi_rad_pts, avg_petzold, psi, 'linear', 'extrap');
      
%  Henyey--Greenstein (1941) phase function
   elseif strcmpi(pf_type, 'HG')
      
      g = 0.924;  % Average cosine, best fitting Petzold [Mo, p. 110]
      beta = (1/ (4 * pi)) * ...
             (1 - g^2) ./ ((1 + g^2 - 2 * g * cos(psi)).^(3/2));
      
   end
   
end