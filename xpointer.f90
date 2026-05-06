program main
implicit none
integer, target :: v(3) = [10, 20, 30]
integer, pointer :: p(:)
p => v(2:)
print*,p
p = 10*p
print*,v
end program main
