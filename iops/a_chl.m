function achl = a_chl(z, p)
%  Absorption due to chlorophyll particulate matter

%  Absorption coefficient due to chlorophyll based on:
%     Bricaud et al., 1998, JGR 103(C13), 31033-31044 for 400-1000 nm
%     Vasilkov, et al., 2005, Applied Optics Vol 44, No. 14, pp2863-2869
%     Morrison and Nelson, 2004, L&O 49(1), 215-224.
   
   achl = p.A .* chlorophyll_profile(z, p.chl_params).^p.E;

   %if p.old_model
      
%     Old model due to Prieur and Sathyendranath (1981)
      %achl = 0.06 * p.ac .* chlorophyll_profile(z, p.chl_params).^0.65;
   
   %end

end