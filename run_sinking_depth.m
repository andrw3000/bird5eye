%--------------------------------------------------------------------------
%  Run bird5eye with sinking depth to output a fixed observation depth
%--------------------------------------------------------------------------

function run_sinking_depth(macbeth_col)
fprintf('\nRunning bird5eye\n----------------\n')

%clear
%close all;
%format short
ttot = tic;

%profile on
%<run your program>
%profile report
%profile off

%--------------------------------------------------------------------------
% Model variable key
%--------------------------------------------------------------------------

% Bandwith run:
%  'sing' = Single; 'spec' = Spectral;

% Jerlov types:
%  'PW' = Pure Water; 'I'; 'IA'; 'IB'; 'II'; 'III'; '3C'; '5C'; '7C'; '9C'

% Chlorophyl types:
%  Choose 'Jerlov' for automatic assignment based on Jerlov type
%  Choose 'PR' for Phil Roberts' assignments for Jerlov types IB, II, III
%  Choose from Uitz' 9 stratified classes 'S1' to 'S9'
%  Choose from Platt's Celtic Green Sea 'CG' or New England Harbour 'NE'

% Phase functions:
%  'FF' = Fournier-Fourand
%  'AP' = 'Average Petzold'
%  'HG' = Henyey-Greenstein

% Pure water absorption data:
%  'PS' = Prieur-Sathyendranath (1981), only between 400-700nm
%  'SB' = Smith-Baker (1981)
%  'PF' = Pope-Fry (1997)

% To activate inelastic scattering:
%  'off'
%  'raman' for Raman inelastic scattering only (may be used with 'PW')
%  'fluo'  for chl and cdom fluorescence (chlorophyll excitation: 370-690)
%  'all'

% To use the classic or new IOP selection
%  'new'
%  'old'


%--------------------------------------------------------------------------
%  Drive way: options
%--------------------------------------------------------------------------

% Model options
band_run = 'sing';
inel = 'off';
pf_type = 'petzold';
aw_data = 'PF';
chl_type = 'jerlov'; %'jerlov';
jerlov = 'PW';
model_type = 'new';
bandwidth = 10;

% Spectrum boundaries,'band_max - band_max' divisible by 'bandwidth'
band_min = 400;
band_max = 730;

% Observation and bottom depths
obs_depths = 0;
mac_depths = 0:0.25:3.5;
bot_depths = [mac_depths, 5];

%--------------------------------------------------------------------------
%  Entrance steps: depth computations
%--------------------------------------------------------------------------

% Depth geometry
fprintf('\n(*) Computing the depth geometry')

%floor = geom_bottom_single(dep_bottom);
%[bot_depths, ~, dep_index] = unique(floor);  % Vector of depths

num_obs_deps = length(obs_depths);
num_bot_deps = length(bot_depths);

fprintf(' [Complete]\n')

depths = {bot_depths, obs_depths};

%  depths  = [num_deps,1] ordered vector of elts of floor, least first
%  ifloor  = [num_deps,1] index vector such that depths = floor(ifloor)
%  idepths = [length(floor(:)),1] index vector, floor(:) = depths(idepths)


fprintf('\n     - There are %d depth intervals', num_bot_deps - 1)
fprintf('\n     - Deepest depth at %.2f metres', bot_depths(end))
fprintf('\n     - Shallowest depth at %.2f metres', bot_depths(1))
fprintf('\n     - The number of observed depths is %d\n', num_obs_deps)


%--------------------------------------------------------------------------
%  Front door: spectrum initalisation
%--------------------------------------------------------------------------

fprintf('\n(*) Initiating the spectrum')

% Band average values
band_max = band_min + bandwidth * ceil((band_max - band_min) / bandwidth);
spec = (band_min - bandwidth/2):bandwidth:(band_max + bandwidth/2);
band0 = spec(1:(end-1));
band1 = spec(2:end);
bands = (band1 + band0) / 2;
num_bands = length(bands);
num_subs = round(bandwidth/5);  % Sample every 5nm

fprintf(' [Complete]\n')

fprintf('\n     - Resolution of B = %d bands of width %dnm', ...
                  num_bands, bandwidth);
               
fprintf('\n     - Shortest waveband at %dnm, longest at %dnm\n', ...
                  bands(1), bands(end));
               
               
%--------------------------------------------------------------------------
%  Welcome: Run model over spec
%--------------------------------------------------------------------------

% Single wavelength runs
if strcmpi(band_run, 'sing')

%  Force inelastic scattering off
   inel = 'off';
   
%  Store solution for each wave band
   bird = cell(num_bands, 1);

   for b = 1:num_bands

      t0b = tic;

      fprintf('\n(*) Single bandwidth run at %dnm', round(bands(b)))

      band = [spec(b), spec(b+1)];
      bird{b} = bird5eye(b, depths, band, jerlov, pf_type, chl_type, ...
                         aw_data, num_subs, inel, model_type, macbeth_col);

   %  Time wavelength runs
      t1b = toc(t0b);
      tbh = floor(round(t1b) / 3600);
      tbm = floor(mod(round(t1b), 3600) / 60);
      tbs = mod(round(t1b), 60);
      tbss = t1b - tbh*3600 - tbm*60;

      if tbh > 0
         fprintf(' [Completed in %dh%dm]\n', tbh, tbm)
      elseif tbm > 0
         fprintf(' [Completed in %dm%ds]\n', tbm, tbs)
      else
         fprintf(' [Completed in %.2fs]\n', tbss)
      end

   end
   
%  Store outputs
   d0   = bird{1}.d0;
   p0   = bird{1}.p0;
   obs  = bird{1}.obs;
   pobs = bird{1}.pobs;
   nsub = bird{1}.nsub;

   
   ud_ext = cell(nsub + d0, 1);
   ud_int = cell(nsub + d0, 1);

   for d = 1:(nsub + d0)

      ud_ext{d} = NaN(num_bands, 1);
      ud_int{d} = NaN(num_bands, p0(d));

      for b = 1:num_bands

         ud_ext{d}(b, 1) = bird{b}.ext(d).irr(1).ud;

         for ob = 1:p0(d)

            ud_int{d}(b, ob) = bird{b}.int(d).irr(ob).ud;

         end

      end

   end

%  Reflectance of the dry surfaces
   ud_dry{1} = NaN(num_bands, 1);
   ud_dry{2} = NaN(num_bands, 1);
   for b = 1:num_bands
      ud_dry{1}(b) = bird{b}.dry(1).irr.ud;
      ud_dry{2}(b) = bird{b}.dry(2).irr.ud;
   end
   
   
% Spectral wavelength runs
elseif strcmpi(band_run, 'spec')
   
   bird = bird5eye(1:num_bands, depths, spec, jerlov, pf_type, chl_type, ...
                      aw_data, num_subs, inel, model_type, macbeth_col);

%  Store outputs
   d0   = bird.d0;
   p0   = bird.p0;
   obs  = bird.obs;
   pobs = bird.pobs;   
   nsub = bird.nsub;

   ud_ext = cell(nsub + d0, 1);
   ud_int = cell(nsub + d0, 1);

   for d = 1:(nsub + d0)

      ud_ext{d} = NaN(num_bands, 1);
      ud_int{d} = NaN(num_bands, p0(d));

      ud_ext{d}(:, 1) = bird.ext(d).irr(1).ud;

      for ob = 1:p0(d)

         ud_int{d}(:, ob) = bird.int(d).irr(ob).ud;

      end

   end
   
%  Reflectance of the dry surfaces
   ud_dry{1} = bird.dry(1).irr.ud;
   ud_dry{2} = bird.dry(2).irr.ud;
   
end

%--------------------------------------------------------------------------
%  Goodybag: Save model
%--------------------------------------------------------------------------

model_name = ['sink_', model_type, '_', band_run, ...
              '_bwid', num2str(bandwidth), ...
              '_inel_', inel, ...
              '_', pf_type, '_pf', ...
              '_aw', aw_data, ...
              '_chl', chl_type, ...
              '_jerlov', jerlov, ...
              '_macbeth', num2str(macbeth_col)];

addpath([pwd, '/saved_models'])
save([pwd, '/saved_models/', model_name, '.mat'], 'bird', ...
                                            'bands', ... 
                                            'bot_depths', ...
                                            'd0', ...
                                            'nsub', ....
                                            'obs', ...
                                            'pobs', ...
                                            'ud_ext', ...
                                            'ud_int', ...
                                            'ud_dry');

fprintf('\n***** Output ready *****\n\n')


%--------------------------------------------------------------------------
%  Home yet? Running time
%--------------------------------------------------------------------------

trot = toc(ttot);
toth = floor(round(trot) / 3600);
totm = floor(mod(round(trot), 3600) / 60);
tots = mod(round(trot), 60);

if toth > 0
   fprintf('\n(*) Total running time: %dh%dm\n\n', toth, totm)
elseif totm > 0
   fprintf('\n(*) Total running time: %dm%ds\n\n', totm, tots)
else
   fprintf('\n(*) Total running time: %ds\n\n', tots)
end


end