function betaw = beta_water(psi)
%  Due to Morel (1974), see [Mo, Ch. 3, p. 102] or Mobley-Solonenko

%  Normalised phase function
   betaw = 0.06225 * (1 + 0.835 .* cos(psi).^2);
   
end