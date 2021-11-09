function bchl = b_chl(z, p)

%  Chlorophyll value
   chl = chlorophyll_profile(z, p.chl_params);
      
%  bchl550 derived in Loisel--Morel
   bchl550 = 0.416 .* chl.^0.766;              % Morel (2002), Eq. (8)

%  New particle (chlorophyll) scattering function
   if chl <= 2 && chl > 0.02
      nu = 0;
      bchl = bchl550 .* (p.lam ./ 550).^(nu);   % Morel (2002), Eq. (14)

   elseif chl > 2
      nu = 0.5 * (log10(chl) - 0.3);
      bchl = bchl550 .* (p.lam ./ 550).^(nu);   % Morel (2002), Eq. (14)

   else
      bchl = 0;  %bchl = (p.lam ./ 550).^(-1) .* 0.3 .* chl^(0.62);
   end
   
   %if p.old_model
      
%     Old particle scattering function due to Gordon & Morel (1983)
%     See [Mo, Ch. 3, p. 122, (3.40)]
      %bchl = 0.3 * chl^(0.62) .* (550 ./ p.lam);
      
   %end


end