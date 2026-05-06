module m
implicit none
integer, parameter :: dp = kind(1.0d0)
contains
function mean(x) result(xmean)
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: xmean
xmean = sum(x)/size(x)
end function mean
end module m

program main
use m
implicit none
integer, parameter :: n = 100
real(kind=dp) :: x(n)
call random_number(x)
print*,mean(x)
print*,mean(x**2)
end program main