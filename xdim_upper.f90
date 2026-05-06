module m
implicit none
contains
subroutine sub(ng, d)
integer, intent(in) :: ng
integer, DIMENSION(1-ng:,1-ng:), intent(out) :: d
print*,ng, lbound(d), ubound(d)
d = 42
end subroutine sub
end module m

program main
use m
implicit none
integer, parameter :: ng = 3
integer :: d(3,3)
call sub(ng, d)
print*,d
end program main