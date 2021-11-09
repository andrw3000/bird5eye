function bw = b_water(lam)

%  Pure fresh/sea water Due to Morel (1974), see [Mo, Ch. 3, p. 102-104]
   %lam0   = 550;           % (nm)
   %beta90 = 0.93 * 1e-4;   % For pure fresh water, 0% salinity, (1/m sr)
   %beta90 = 1.21 * 1e-4;   % For pure sea water, 3.5-3.9% salinity

%  Root lam0 = 400 used in Solonenko--Mobley
   lam0   = 400;       % (nm)
   beta90 = 3.63e-4;   % For pure water (1/m sr)

%  Pure water scattering coefficient
   bw = 16.06 * ((lam0 ./ lam).^(4.322)) * beta90;
   
end