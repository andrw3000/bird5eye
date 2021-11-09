function acdom = a_cdom(z, p)
%  Absorption due to Coloured Dissolved Organic Matter (CDOM)

   chl = chlorophyll_profile(z, p.chl_params);
   
%  Absorption coefficient due to chlorophyll at 440
   a440 = p.A440 .* chl.^p.E440;
   
   if p.costal_on
      M_cdom = 0.35 * chl + 1.054;
      alpha = -0.00164 * chl + 0.027;
      
   else
      M_cdom = 0.544 * chl^(-0.311);
      alpha = 0.0306 * chl^(0.112);
      
   end
   
%  Absorption coefficient due to CDOM
   if p.old_model
      acdom = p.a440 .* p.M_cdom .* exp(-p.alpha .* (p.lam - 440));
      
   else
      acdom = a440 .* 0.2 * M_cdom .* exp(-alpha .* (p.lam - 440));
      
   end

end