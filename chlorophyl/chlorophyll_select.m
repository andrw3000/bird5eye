function cp = chlorophyll_select(chl_type, jerlov)
%  Parameters defining the Gaussian chlorophyll profile
%  Classified according to Uitz et al (2006) and Johnson et al (2012)
%  Two exampls from Platt and Sathyendranath (1988)
   
%  Structure to store parameters
   load('data_input/chl_data.mat', 'uitz', 'platt', 'phil');
   
%  Assignment via Jerlov type
   if strcmpi(chl_type, 'Jerlov')
      
      if contains('PW I IA IB', jerlov, 'IgnoreCase', true)
         cp = uitz(1,1);
         
      elseif strcmpi(jerlov, 'II')
         cp = uitz(2,1);
         
      elseif strcmpi(jerlov, 'III')
         cp = uitz(4,1);

      elseif strcmpi(jerlov, '1C')
         cp = uitz(7,1);
         
      elseif strcmpi(jerlov, '3C')
         cp = uitz(8,1);
         
      elseif strcmpi(jerlov, '5C')
         cp = uitz(9,1);
         
      else
%        Otherwise use Platt's "Celtic Green Sea"
         cp = platt(1,1);
         
      end
      
%  Phil Roberts' chlorophyll profiles
   elseif strcmpi(chl_type, 'Roberts')

      if strcmpi(jerlov, 'IB')
         cp = phil(1,1);
         
      elseif strcmpi(jerlov, 'II')
         cp = phil(2,1);
         
      elseif strcmpi(jerlov, 'III')
         cp = phil(3,1);
         
      else
%        Otherwise use Platt's "New England Harbour"
         cp = platt(2,1);
         
      end
      
%  Assignment by Uitz' strata type
   elseif strcmpi(chl_type, 'S1')
      cp = uitz(1,1);
         
   elseif strcmpi(chl_type, 'S2')
      cp = uitz(2,1);
         
   elseif strcmpi(chl_type, 'S3')
      cp = uitz(3,1);
         
   elseif strcmpi(chl_type, 'S4')
      cp = uitz(4,1);
      
   elseif strcmpi(chl_type, 'S5')
      cp = uitz(5,1);
         
   elseif strcmpi(chl_type, 'S6')
      cp = uitz(6,1);
         
   elseif strcmpi(chl_type, 'S7')
      cp = uitz(7,1);
         
   elseif strcmpi(chl_type, 'S8')
      cp = uitz(8,1);
      
   elseif strcmpi(chl_type, 'S9')
      cp = uitz(9,1);
         
   elseif strcmpi(chl_type, 'CG')
%     Platt--Sathyendranath's "Celtic Green Sea"
      cp = platt(1,1);
      
   elseif strcmpi(chl_type, 'NE')
%     Platt--Sathyendranath's "New England Harbour"
      cp = platt(2,1);
      
   else
      fprintf('\n\n***   Please choose a valid chlorophyll type   ***\n\n')
      return
      
   end
   
end