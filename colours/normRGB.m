function RGBnorm = normRGB(RGBspec, macbeth_norm, spec)

   R = RGBspec(1, :, 1)';
   G = RGBspec(1, :, 2)';
   B = RGBspec(1, :, 3)';

%  Normalise by summing output to white = [1, 1, 1]
   if macbeth_norm == 0

      R = R ./ sum(R);
      G = G ./ sum(G);
      B = B ./ sum(B);
      
%  Normalise about a specific MacBeth colour
   elseif any(1:24 == macbeth_norm)
      
      load('data_input/rfl_macbeth.mat', 'macbeth_rfl_raw', ...
                                         'wavelengths_raw', ...
                                         'macbeth_colours');
                                       
      rfl = interp1(wavelengths_raw, macbeth_rfl_raw{macbeth_norm}, spec);
      RGBrfl = rfl2rgb(rfl, [R, G, B]);
      R = R .* ((macbeth_colours{macbeth_norm}(1) / 255) ./ RGBrfl(1,1,1));
      G = G .* ((macbeth_colours{macbeth_norm}(2) / 255) ./ RGBrfl(1,1,2));
      B = B .* ((macbeth_colours{macbeth_norm}(3) / 255) ./ RGBrfl(1,1,3));

   end

   RGBnorm = reshape([R, G, B], [1, length(spec), 3]);
   %RGBnorm = reshape([0.9 * R, 0.8 * G, B], [1, length(spec), 3]);

end