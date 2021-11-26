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
xseg = 201;
yseg = 225;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 2
col = 2;
xseg = 260;
yseg = 271;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 3
col = 3;
xseg = 318;
yseg = 225;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 4
col = 4;
xseg = 337;
yseg = 192;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 5
col = 5;
xseg = 438;
yseg = 179;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 6
col = 6;
xseg = 498;
yseg = 168;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 7
col = 7;
xseg = 175;
yseg = 202;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 8
col = 8;
xseg = 232;
yseg = 187;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 9
col = 9;
xseg = 289;
yseg = 177;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 10
col = 10;
xseg = 350;
yseg = 165;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 11
col = 11;
xseg = 409;
yseg = 151;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 12
col = 12;
xseg = 466;
yseg = 138;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 13
col = 13;
xseg = 146;
yseg = 174;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 14
col = 14;
xseg = 203;
yseg = 161;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 15
col = 15;
xseg = 259;
yseg = 147;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 16
col = 16;
xseg = 318;
yseg = 134;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 17
col = 17;
xseg = 380;
yseg = 126;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 18
col = 18;
xseg = 436;
yseg = 110;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 19
col = 19;
xseg = 114;
yseg = 144;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 20
col = 20;
xseg = 173;
yseg = 132;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 21
col = 21;
xseg = 233;
yseg = 119;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 22
col = 22;
xseg = 291;
yseg = 106;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 23
col = 23;
xseg = 348;
yseg = 93;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 24
col = 24;
xseg = 409;
yseg = 80;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

% Colour 25
col = 25;
xseg = 89;
yseg = 118;
macbeth(dnum, col, :) = colour_patch(hcrop, xseg, yseg);

save('macbeth_exp.mat', 'macbeth')

function colour_spec = colour_patch(hcube, xseg, yseg)
    colour_spec = squeeze(sum(hcube(yseg:(yseg+10), xseg:(xseg+10), :), ...
        [1,2])) / 100;
end