chl_types = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9'};

X = length(chl_types);


for x = 1:X
    run_check(19, chl_types{x})
end