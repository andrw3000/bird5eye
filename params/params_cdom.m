function [M, alpha] = params_cdom(jerlov)
%  Params defining Coloured Dissolved Organic Matter (CDOM) absorption

%  Pure water case
   if strcmpi(jerlov, 'PW')
      M = 0;
      alpha = 0;
      
%  Type I
   elseif strcmpi(jerlov, 'I')
      M     = 2.34;
      alpha = 0.018;
      
%  Type IA
   elseif strcmpi(jerlov, 'IA')
      M     = 1.69;
      alpha = 0.020;
      
%  Type IB
   elseif strcmpi(jerlov, 'IB')
      M     = 1.49;
      alpha = 0.022;
      
%  Type II
   elseif strcmpi(jerlov, 'II')
      M     = 1.31;
      alpha = 0.023;
      
%  Type III
   elseif strcmpi(jerlov, 'III')
      M     = 0.95;
      alpha = 0.024;
      
%  Type 1C
   elseif strcmpi(jerlov, '1C')
      M     = 1.22;
      alpha = 0.027;
      
%  Type 3C
   elseif strcmpi(jerlov, '3C')
      M     = 2.02;
      alpha = 0.026;
      
%  Type 5C
   elseif strcmpi(jerlov, '5C')
      M     = 1.89;
      alpha = 0.022;
      
%  Type 7C
   elseif strcmpi(jerlov, '7C')
      M     = 2.25;
      alpha = 0.017;
      
%  Type 9C
   elseif strcmpi(jerlov, '9C')
      M     = 4.32;
      alpha = 0.015;
      
   end
      
end