function RGBrfl = rfl2rgb(rfl, RGBspec)
%  Input:   rfl is a length(spec) vector of reflectances wrt raw2rgb(spec)
%           RGBspec is a [length(spec), 3] matrix containing the RGB values
%  Outputs: RGBrfl is a [1, 1, 3] RGB value
   rfl_row = repmat(reshape(rfl(:), [1, length(rfl), 1]), [1, 1, 3]);
   RGBrfl = reshape(sum(rfl_row .* RGBspec, 2), [1, 1, 3]);
   
end