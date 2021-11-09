function RGBnorm = normRGB(RGBspec, macbeth_norm, spec)

   R = RGBspec(:, 1);
   G = RGBspec(:, 2);
   B = RGBspec(:, 3);
      
%  Normalise by summing output to white = [1, 1, 1]
   if macbeth_norm == 0

      R = R ./ sum(R);
      G = G ./ sum(G);
      B = B ./ sum(B);
      
      
      
%  Normalise about a specific MacBeth colour
   elseif any(1:24 == macbeth_norm)
      
      load('_data_input/rfl_macbeth.mat', 'macbeth_rfl_raw', ...
                                          'wavelengths_raw', ...
                                          'macbeth_colours');
                                       
      rfl = interp1(wavelengths_raw, macbeth_rfl_raw{macbeth_norm}, spec);
      RGBrfl = rfl2rgb(rfl, [R, G, B]);
      
      R = R .* ((macbeth_colours{macbeth_norm}(1) / 255) ./ RGBrfl(1,1,1));
      G = G .* ((macbeth_colours{macbeth_norm}(2) / 255) ./ RGBrfl(1,1,2));
      B = B .* ((macbeth_colours{macbeth_norm}(3) / 255) ./ RGBrfl(1,1,3));

   end
   
   RGBnorm = [R, G, B];

end