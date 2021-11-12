function aw = a_water(lam, aw_data)
%  Pure water absorption
%     Combine: Pope's data for > 380 with Sogandares data for < 380
%     and Smith-Baker for > 725; at 380 we take the average:
%                                0.010685 = (0.0100 + 0.01137)/2.
%  Output: row vector of size [1, length(lam)]

   if strcmpi(aw_data, 'PS')
      
      lam_raw = 400:10:700;
      aw_raw = [0.018, 0.017, 0.016, 0.015, 0.015, 0.015, 0.016, 0.016, ...
                0.018, 0.020, 0.026, 0.036, 0.048, 0.051, 0.056, 0.064, ...
                0.071, 0.080, 0.108, 0.157, 0.245, 0.290, 0.310, 0.320, ...
                0.330, 0.350, 0.410, 0.430, 0.450, 0.500, 0.650];
             
   elseif strcmpi(aw_data, 'SB')

      load('data_input/aw_smith_baker.mat', 'lam_sb', 'aw_sb');
      lam_raw = lam_sb;
      aw_raw  = aw_sb;
      
   elseif strcmpi(aw_data, 'PF')
      
      load('data_input/aw_pope.mat', 'lam_pope', 'aw_pope');
      lam_raw = lam_pope;
      aw_raw  = aw_pope;
   
   end

   aw = interp1(lam_raw, aw_raw, lam, 'pchip');
   
end