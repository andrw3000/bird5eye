for col = 1:24
   fprintf('\nMacBeth Colour %d\n----------------\n\n', col)
   run_sinking_depth(col)
   clear
end
