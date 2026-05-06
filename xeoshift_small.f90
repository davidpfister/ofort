program xeoshift
implicit none
integer, parameter :: nrow = 3, ncol = 4
integer :: b(nrow,ncol), r2(nrow,ncol)
b = 123
r2 = eoshift(b, shift=1, dim=1)
print "(*(1x,i0))", r2
end program xeoshift
