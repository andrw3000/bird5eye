function geo = params_geoloc()
%  Input parameters for bird5eye

%  Structure containing geo-location parameters
   geo = struct;
   
%  Time in 24 hour format: [hh,mm]
   geo.time = [13,00];
   
%  Date as [dd,mm,yyyy]
   geo.date = [04,07,2020];

%  Timezone +/- hours from GMT = UTC, Coodinated Universal Time
   geo.time_zone = -4;

%  Latitude (+ is north, - is south)
   geo.lat = 25.0000;  % degrees, north
   
%  Longitude from the prime meridian in Greenwhich (+ is east, - is west)
   geo.long = -71.0000; % degrees, west

end