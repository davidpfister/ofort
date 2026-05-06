implicit none
integer :: i, v(5) = [2,4,8,16,32]
print "(*(i0,:,','))", v, (v, i=1,3)
end
