module m
implicit none
integer, parameter :: dp = kind(1.0d0)
contains
function mean(x) result(xmean)
real(kind=dp), intent(in) :: x
real(kind=dp)             :: xmean
end function mean
end module m

program main
use m
implicit none
integer, parameter :: n = 100
real(kind=dp) :: x(n)
call random_number(x)
print*,sum(x)/n
end program main
