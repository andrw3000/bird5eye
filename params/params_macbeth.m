function rfl = params_macbeth(lam, macbeth)
%  Import MacBeth colour data

   load('data_input/rfl_macbeth.mat', 'wavelengths_raw', ...
                                      'macbeth_rfl_raw');

	rfl = interp1(wavelengths_raw, macbeth_rfl_raw{macbeth}, lam, 'pchip');

end
