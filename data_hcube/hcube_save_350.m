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
xseg = 107;
yseg = 291;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 2
col = 2;
xseg = 130;
yseg = 315;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 3
col = 3;
xseg = 154;
yseg = 339;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 4
col = 4;
xseg = 180;
yseg = 365;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 5
col = 5;
xseg = 207;
yseg = 388;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 6
col = 6;
xseg = 235;
yseg = 413;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 7
col = 7;
xseg = 155;
yseg = 281;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 8
col = 8;
xseg = 182;
yseg = 305;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 9
col = 9;
xseg = 201;
yseg = 329;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 10
col = 10;
xseg = 233;
yseg = 354;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 11
col = 11;
xseg = 259;
yseg = 380;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 12
col = 12;
xseg = 282;
yseg = 404;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 13
col = 13;
xseg = 209;
yseg = 270;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 14
col = 14;
xseg = 233;
yseg = 293;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 15
col = 15;
xseg = 260;
yseg = 317;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 16
col = 16;
xseg = 310;
yseg = 368;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 17
col = 17;
xseg = 157;
yseg = 307;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 18
col = 18;
xseg = 335;
yseg = 391;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 19
col = 19;
xseg = 254;
yseg = 260;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 20
col = 20;
xseg = 280;
yseg = 284;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 21
col = 21;
xseg = 307;
yseg = 308;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 22
col = 22;
xseg = 339;
yseg = 333;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 23
col = 23;
xseg = 359;
yseg = 358;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 24
col = 24;
xseg = 386;
yseg = 384;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 25
col = 25;
xseg = 316;
yseg = 394;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

save('macbeth_exp.mat', 'macbeth')

function colour_spec = colour_patch(hcube, xseg, yseg)
    colour_spec = squeeze(sum(hcube(yseg:(yseg+10), xseg:(xseg+10), :), ...
        [1,2])) / 100;
end