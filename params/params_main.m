function p = params_main()
%  Input parameters for bird5eye

%  Structure p containing all depth independant parameters
   p = struct;
   
%--------------------------------------------------------------------------
%  Testing parameters
%--------------------------------------------------------------------------
   
%  Subquad partition for beta calc: 'constant_mu = 1', else 'constant_th'
   p.constant_mu_partition = 0;
   
%  Inelastic Quantum efficiency of chlorophyll fuorescence in [0, 0.07]
   p.phi_chl = 0.07;
   
%  Inelastic chlorophyll emission: W = 1 for single Gaussian; else W = 0.75
   p.W = 0.75;
   
%--------------------------------------------------------------------------
%  Atmospheric parameters
%--------------------------------------------------------------------------

%  Clear Sky Index
   p.clear_sky_index = 1;    % 0 = opaque, 1 = clear
   
%  Cloudless Index
   p.cloudless_index = 1;   % 0 = cloudy, 1 = cloudless 
   
%--------------------------------------------------------------------------
%  Quad, subquad and bandwidth partition parameters
%--------------------------------------------------------------------------
   
%  Partition numbers: (M, N) = (10,24) recommended
   p.M = 10;            % Half the number of polar quads
   p.N = 2*12;          % Total number of azimuthal quads
   p.NL = p.N/2 + 1;    % Reduced number of Fourier coefficients
   p.MN = p.M * p.N;

%  Subquad resolution; (M0,N0) = (7,9) recommended
   p.M0 = 20;	% number of subdivisions of each i-quad on mu axis
   p.N0 = 20;	% number of subdivisions of each u-quad on phi axis
   
%--------------------------------------------------------------------------
%  Fine structural parameters
%--------------------------------------------------------------------------

%  Quad indices (i,u)
   p.i = 1:p.M;      p.i = p.i(:);    % index column p.i = [1,...,M]'
   p.u = 0:(p.N-1);  p.u = p.u(:);    % index column p.u = [0,...,N-1]'
   
%  Subquad indices (i,j)
   p.i0 = 1:p.M0;    p.i0 = p.i0(:);
   p.u0 = 1:p.N0;    p.u0 = p.u0(:);
   
%  Hemisphere indicator: +1 = lower; -1 = upper
   p.sgn = [1, -1];  p.sgn = p.sgn(:);
   
%  Angular spacing   
   p.Dth = pi/(2*p.M);     % polar ang quad width (scalar)
   p.Dph = 2*pi/p.N;       % azimuthal quad width (scalar)
   
%  theta centre [M, 1]
   p.th = (p.M - (p.i - (1/2))) * p.Dth;

%  phi centre [N, 1]
   p.ph = p.u * p.Dph;
   
%  mu centre [M, 1]
   p.mu = cos(p.th);
   
%  mu spacing [M, 1]
   p.Dmu = cos(p.th - p.Dth/2) - cos(p.th + p.Dth/2);
   
%  mu average [M, 1]
   p.mu_av = (cos(p.th - p.Dth/2) + cos(p.th + p.Dth/2)) / 2;
   
%  Solid angles [M, 1]
   p.Om = p.Dph * p.Dmu;
   
%  Quad corners
   p.th0 = (p.M - (p.i-1)).*p.Dth;	% th = [pi/2,...,Dth]'
   p.mu0 = cos(p.th0);              % mu = [0,...,cos(Dth)]'
   p.ph0 = (p.u - (1/2)).*p.Dph;    % ph = [-Dph/2,+Dph/2,...,2pi-Dph/2]'

%  Spectral transform indices: L = 0,...,N/2 indices [N/2 + 1, 1]
   p.L = 0:(p.N/2);  p.L = p.L(:);
   
%  u-L grids, [N(u), NL-1]
   [p.uN, p.LN] = ndgrid(p.u, p.L);
   [p.uP, p.LP] = ndgrid(p.u, p.L(1:(end-1)));
   [p.uS, p.LS] = ndgrid(p.u, p.L(2:end));

%  Exponential factors (positive P and S and negative N)
   p.exN = exp(- 2 .* pi .* 1i .* p.uN .* p.LN ./ p.N);  % [N(u), NL]
   p.exP = exp(  2 .* pi .* 1i .* p.uP .* p.LP ./ p.N);  % [N(u), NL-1]
   p.exS = exp(- 2 .* pi .* 1i .* p.uS .* p.LS ./ p.N);  % [N(u), NL-1]
   
end