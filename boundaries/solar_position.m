function sol = solar_position(geo)
%  Function to compute solar position
%     From the conditions paramemters c=overCast(), we use
%     [p.date=[dd,mm,yyyy], p.time=[mm,hh], p.tZone, p.lat, p.long]
%
%  References:
%     https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-time
%     http://en.wikipedia.org/wiki/Solar_azimuth_angle
%     https://en.wikipedia.org/wiki/Solar_zenith_angle
%     https://en.wikipedia.org/wiki/Position_of_the_Sun
%     See also Seinfeld & Pandis or Duffie & Beckman

%  Day number since 01/01/0000. Input format: (yyyy,mm,dd,hh,mm,ss)
   fullDate = datenum(geo.date(3), geo.date(2), geo.date(1), ...
                      geo.time(1), geo.time(2), 0);
   
   day_num = floor(fullDate)-1;      % in days since 01/01/0000   
   time_num = fullDate - day_num -1; % in days from 00:00 on day_num-th day

   [year_num,~,~] = datevec(day_num);

%  Local times
%  -----------

%  Local time (in hours)
   LT = 24*time_num;   
   
%  Local Standard Time Meridian (15 degrees * change in time zone)
   LSTM = 15*geo.time_zone;
   
%  Equation of time and approximate solar time
%  -------------------------------------------
   
%  Day number: full days past since the start of the year
   day_in_year = mod(day_num - datenum(year_num,1,1) + 1, 365);
   
%  Argument B in EoT (in radians)
   B = 2 * pi * (day_in_year - 81)/365;
   
%  Equation of time (in munutes)
   EoT = 9.87 * sin(2 * B) - 7.53 * cos(B) - 1.5 * sin(B);
   
%  Time correction factor (in munutes)
   TC = 4 * (geo.long - LSTM) + EoT;
   
%  Local Solar time (in hours)
   LST = LT + TC/60;
   
%  Approximate solar time (in days)
%   solarTime = LST/24;
   
%  Hour angle (in radians)
   HRA = 15 * (LST-12) * pi/180;
   
%  Declination (in radians)
   decl = (-23.44 * cos(2 * pi * (day_in_year + 10)/365)) * pi/180;

%  Computing the Zenith
%  --------------------

%  Convert lat/long to radians   
   lat_rad = geo.lat * pi/180;        % latitude in radians
   %longRad = p.long*pi/180;      % longitude in radians

%  Zenith angle (in radians)
   zenith = acos(sin(lat_rad) * sin(decl) + ...
                 cos(lat_rad) * cos(decl) * cos(HRA));
   
%  Day/night test
   night = 0;
   if zenith >= pi/2
      night = 1;
   end
   
      
%  Computing the Azimuth
%  ---------------------
   
%  Cosine of the azimuth (via spherical trig identity)
   cos_az = (cos(zenith) * sin(lat_rad) - sin(decl)) / ...
            (sin(zenith) * cos(lat_rad));
   
%  Resolving cosAz in [0, 180], measured from due south:
%  east = west = 90; south = 0; north = 180.
   south_az = acos(min(1,max(-1,cos_az)));     % fudge factor alert
   
%  Resolving azimuth in [0, 360], measured clockwise from due north:
%  east = 90; south = 180; west = 270.
   if night == 1
      azimuth = NaN;
   elseif night == 0
%     Shift range to [0,2*pi] rad
      azimuth = pi + sign(HRA)*south_az;
   end
   
%  Output
%  ------

   sol = struct;
   sol.zen = zenith;
   sol.azi = azimuth;
   sol.night = night;

end
