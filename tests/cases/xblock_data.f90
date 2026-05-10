common /com/ x

if (x .eq. 1) then
  print *, "FAIL"
else
  print *, "PASS"
endif
end

block data
common /com/ x
data x /0/
end
