implicit none
integer :: v(4) = [10,20,30,40]
a1: where (v < 25)
   v = 10*v
else where
   v = -1
end where a1
print*,v
end
