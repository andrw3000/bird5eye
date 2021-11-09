function RGBspec = raw2rgb(spec, gamma)
%  Input:   spec is a vector of wavelengths in nm
%  Outputs: RGB is a [length(spec), 3] matrix containing the RGB values
%  Ref:     http://www.noah.org/wiki/Wavelength_to_RGB_in_Python

%  Correction for diaplay devices. The linear RGB values will require 
%  gamma correction if the display device has nonlinear response.
   %gamma = 5;

   spec = spec(:);
   nspec = length(spec);
   
   R = NaN(nspec, 1);   %  Pure B at 440nm
   G = NaN(nspec, 1);   %  Pure G at 510nm
   B = NaN(nspec, 1);   %  Pure R at 645nm
   
%  380 to 440
   lam = spec(spec >= 380 & spec <= 440);
   attenuation = 0.3 + (0.7 .* (lam - 380) ./ (440 - 380));
   R(spec >= 380 & spec <= 440) = (-((lam - 440) ./ (440 - 380)) .* ...
                                    attenuation) .^ gamma;
   G(spec >= 380 & spec <= 440) = 0;
   B(spec >= 380 & spec <= 440) = attenuation .^ gamma;
   
%  440 to 490
   lam = spec(spec > 440 & spec <= 490);
   R(spec > 440 & spec <= 490) = 0;
   G(spec > 440 & spec <= 490) = ((lam - 440) ./ (490 - 440)) .^ gamma;
   B(spec > 440 & spec <= 490) = 1;

%  490 to 510
   lam = spec(spec > 490 & spec <= 510);
   R(spec > 490 & spec <= 510) = 0;
   G(spec > 490 & spec <= 510) = 1;
   B(spec > 490 & spec <= 510) = (-(lam - 510) ./ (510 - 490)) .^ gamma;

%  510 to 580
   lam = spec(spec > 510 & spec <= 580);
   R(spec > 510 & spec <= 580) = ((lam - 510) ./ (580 - 510)) .^ gamma;
   G(spec > 510 & spec <= 580) = 1;
   B(spec > 510 & spec <= 580) = 0;

%  580 to 645
   lam = spec(spec > 580 & spec <= 645);
   R(spec > 580 & spec <= 645) = 1;
   G(spec > 580 & spec <= 645) = (-(lam - 645) ./ (645 - 580)) .^ gamma;
   B(spec > 580 & spec <= 645) = 0;

%  645 to 750
   lam = spec(spec > 645 & spec <= 750);
   attenuation = 0.3 + 0.7 .* (750 - lam) ./ (750 - 645);
   R(spec > 645 & spec <= 750) = attenuation .^ gamma;
   G(spec > 645 & spec <= 750) = 0;
   B(spec > 645 & spec <= 750) = 0;
   
   RGBspec = [R, G, B];
   
end