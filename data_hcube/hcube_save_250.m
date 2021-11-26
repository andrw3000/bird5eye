% Script to save average MacBeth data

% size(macbeth) = [length(depths), 25, bmax]

% depth = 25;
depths = 0:25:350;
dnum = find(depths == depth);
bmax = 212;

%root_dir = '/Users/Holmes/Programmes/joe5data/';

load('macbeth_exp.mat', 'macbeth')

% Colour 1
col = 1;
xseg = 323;
yseg = 715;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 2
col = 2;
xseg = 338;
yseg = 687;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 3
col = 3;
xseg = 354;
yseg = 658;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 4
col = 4;
xseg = 367;
yseg = 628;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 5
col = 5;
xseg = 383;
yseg = 601;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 6
col = 6;
xseg = 401;
yseg = 571;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 7
col = 7;
xseg = 259;
yseg = 704;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 8
col = 8;
xseg = 275;
yseg = 682;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 9
col = 9;
xseg = 288;
yseg = 653;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 10
col = 10;
xseg = 307;
yseg = 620;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 11
col = 11;
xseg = 323;
yseg = 593;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 12
col = 12;
xseg = 339;
yseg = 564;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 13
col = 13;
xseg = 199;
yseg = 698;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 14
col = 14;
xseg = 213;
yseg = 667;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 15
col = 15;
xseg = 230;
yseg = 639;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 16
col = 16;
xseg = 247;
yseg = 614;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 17
col = 17;
xseg = 263;
yseg = 587;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 18
col = 18;
xseg = 279;
yseg = 555;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 19
col = 19;
xseg = 136;
yseg = 691;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 20
col = 20;
xseg = 153;
yseg = 661;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 21
col = 21;
xseg = 168;
yseg = 634;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 22
col = 22;
xseg = 184;
yseg = 604;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 23
col = 23;
xseg = 199;
yseg = 574;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 24
col = 24;
xseg = 213;
yseg = 547;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 25
col = 25;
xseg = 80;
yseg = 679;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

save('macbeth_exp.mat', 'macbeth')

function colour_spec = colour_patch(hcube, xseg, yseg)
    colour_spec = squeeze(sum(hcube(yseg:(yseg+10), xseg:(xseg+10), :), ...
        [1,2])) / 100;
end