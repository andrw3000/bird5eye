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
xseg = 332;
yseg = 121;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 2
col = 2;
xseg = 293;
yseg = 146;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 3
col = 3;
xseg = 248;
yseg = 172;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 4
col = 4;
xseg = 205;
yseg = 195;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 5
col = 5;
xseg = 166;
yseg = 222;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 6
col = 6;
xseg = 129;
yseg = 245;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 7
col = 7;
xseg = 389;
yseg = 142;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 8
col = 8;
xseg = 346;
yseg = 168;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 9
col = 9;
xseg = 304;
yseg = 194;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 10
col = 10;
xseg = 258;
yseg = 220;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 11
col = 11;
xseg = 216;
yseg = 240;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 12
col = 12;
xseg = 147;
yseg = 262;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 13
col = 13;
xseg = 439;
yseg = 166;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 14
col = 14;
xseg = 397;
yseg = 191;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 15
col = 15;
xseg = 353;
yseg = 215;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 16
col = 16;
xseg = 313;
yseg = 238;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 17
col = 17;
xseg = 286;
yseg = 259;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 18
col = 18;
xseg = 227;
yseg = 281;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 19
col = 19;
xseg = 492;
yseg = 189;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 20
col = 20;
xseg = 452;
yseg = 213;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 21
col = 21;
xseg = 410;
yseg = 235;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 22
col = 22;
xseg = 365;
yseg = 256;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 23
col = 23;
xseg = 319;
yseg = 278;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 24
col = 24;
xseg = 282;
yseg = 299;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 25
col = 25;
xseg = 556;
yseg = 209;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

save('macbeth_exp.mat', 'macbeth')

function colour_spec = colour_patch(hcube, xseg, yseg)
    colour_spec = squeeze(sum(hcube(yseg:(yseg+10), xseg:(xseg+10), :), ...
        [1,2])) / 100;
end