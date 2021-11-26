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
xseg = 289;
yseg = 54;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 2
col = 2;
xseg = 258;
yseg = 81;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 3
col = 3;
xseg = 228;
yseg = 109;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 4
col = 4;
xseg = 194;
yseg = 136;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 5
col = 5;
xseg = 161;
yseg = 165;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 6
col = 6;
xseg = 135;
yseg = 193;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 7
col = 7;
xseg = 353;
yseg = 69;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 8
col = 8;
xseg = 323;
yseg = 97;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 9
col = 9;
xseg = 291;
yseg = 123;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 10
col = 10;
xseg = 260;
yseg = 151;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 11
col = 11;
xseg = 224;
yseg = 181;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 12
col = 12;
xseg = 194;
yseg = 208;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 13
col = 13;
xseg = 416;
yseg = 85;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 14
col = 14;
xseg = 386;
yseg = 113;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 15
col = 15;
xseg = 353;
yseg = 138;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 16
col = 16;
xseg = 322;
yseg = 167;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 17
col = 17;
xseg = 288;
yseg = 194;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 18
col = 18;
xseg = 253;
yseg = 224;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 19
col = 19;
xseg = 477;
yseg = 99;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 20
col = 20;
xseg = 451;
yseg = 125;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 21
col = 21;
xseg = 420;
yseg = 155;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 22
col = 22;
xseg = 384;
yseg = 181;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 23
col = 23;
xseg = 352;
yseg = 210;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 24
col = 24;
xseg = 315;
yseg = 238;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 25
col = 25;
xseg = 559;
yseg = 115;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

save('macbeth_exp.mat', 'macbeth')

function colour_spec = colour_patch(hcube, xseg, yseg)
    colour_spec = squeeze(sum(hcube(yseg:(yseg+10), xseg:(xseg+10), :), ...
        [1,2])) / 100;
end