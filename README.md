# bird5eye
Source code for bird5eye: 2D radiative transfer in natural waters

## Model variable key

- Bandwith run:
'sing' = Single;
'spec' = Spectral;

- Jerlov types:
'PW' = Pure Water;
'I';
'IA';
'IB';
'II';
'III';
'3C';
'5C';
'7C';
'9C'

- Chlorophyl types:
Choose 'Jerlov' for automatic assignment based on Jerlov type
Choose 'PR' for Phil Roberts' assignments for Jerlov types IB, II, III
Choose from Uitz' 9 stratified classes 'S1' to 'S9'
Choose from Platt's Celtic Green Sea 'CG' or New England Harbour 'NE'

- Phase functions:
'FF' = Fournier-Fourand
'AP' = 'Average Petzold'
'HG' = Henyey-Greenstein

- Pure water absorption data:
'PS' = Prieur-Sathyendranath (1981), only between 400-700nm
'SB' = Smith-Baker (1981)
'PF' = Pope-Fry (1997)

- To activate inelastic scattering:
'off'
'raman' for Raman inelastic scattering only (may be used with 'PW')
'fluo'  for chl and cdom fluorescence (chlorophyll excitation: 370-690)
'all'

- To use the classic or new IOP selection
'new'
'old'