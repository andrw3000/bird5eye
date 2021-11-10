function bavg = bandwidth_avg(func, bandwidth, B0)
%  Implement a bandwidth average of func(lam)
%     B0 is the sub sverage resolution, should divide length(func)-1
%     bandwidth is the interval length: lam(B0+i) - lam(i)
%     Returns a 

   d = size(func) > 1;
   e = all(d);
   
   func00 = func(1:(end-d(1)), 1:(end-d(2)));
   func01 = func(1:(end-d(1)), (1+d(2)):end);
   func10 = func((1+d(1)):end, 1:(end-d(2)));
   func11 = func((1+d(1)):end, (1+d(2)):end);
   
   midpts = (func00 + func01 + func10 + func11) / 4;

   dim1 = B0;
   dim2 = length(midpts) / B0;
   dim3 = dim1^e;
   dim4 = dim2^e;
   
   if B0 > 1
      grid = reshape(midpts, dim1, dim2, dim3, dim4);
      bavg = (bandwidth^e) * squeeze(sum(grid, [1, 3]) / (B0^(1 + e)));
      bavg = reshape(bavg, [dim2, dim4]);
      %bavg = squeeze(permute(bavg, [2, 1, 4, 3]));
      
   elseif B0 == 1
      
      bavg = (bandwidth^e) * reshape(midpts, [dim2, dim4]);
      
   end
      
end